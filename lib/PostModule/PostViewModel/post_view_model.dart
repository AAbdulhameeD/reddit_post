import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_post/PostModule/PostModels/comment_model.dart';
import 'package:reddit_post/PostModule/PostModels/post_model.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_events.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_states.dart';

import '../PostRepo/post_repository.dart';

class PostViewModel extends Bloc<PostEvent, PostState> {
  PostViewModel() : super(PostInitState());
  PostRepository postRepository = PostRepository();

  fetchPosts() {
    postRepository.getRedditPosts().then((List<PostModel> posts) {
      emit(FetchPostSuccessState(posts));
    }).catchError((e) {
      emit(FetchPostErrorState());
    });
  }

  updatePostLikes(PostModel postModel,bool isLiked, bool isDisliked) {
      postModel.likes=getLikesValue(isLiked,isDisliked,postModel.likes);
    postRepository.updatePostLikes(postModel).then(( _) {
      emit(LikePostSuccessState(isLiked,isDisliked));
    }).catchError((e) {
      emit(LikePostErrorState());
    });
  }

  updateCommentLikes(PostModel postModel,CommentModel commentModel,bool isLiked, bool isDisliked) {
    commentModel.commentLikes=getLikesValue(isLiked,isDisliked,commentModel.commentLikes);
    resetLikesIfNegative(commentModel);
    postRepository.updateCommentLikes(postModel,commentModel).then(( _) {
      emit(LikeCommentSuccessState(isLiked,isDisliked));
      fetchComments(postModel);
    }).catchError((e) {
      emit(LikeCommentErrorState());
    });
  }

  resetLikesIfNegative(CommentModel commentModel){
    if(commentModel.commentLikes<0) {
      commentModel.commentLikes=0;
    }
  }
  int getLikesValue(bool isLiked,bool isDisliked,int likes){
    if(isLiked && !isDisliked) {
      return likes+=1;
    }else if(!isLiked &&isDisliked) {
    return  likes -= 1;
    }else {
      return likes-1;
    }
  }

  postComment(PostModel postModel,CommentModel commentModel){
    postRepository.postComment(postModel,commentModel).then((value) {
      emit(PostCommentSuccessState(commentModel));
      fetchComments(postModel);
    }).catchError((e){
      emit(PostCommentErrorState());
    });
  }
  fetchComments(PostModel postModel){
    FirebaseDatabase.instance.ref().child('posts').child('${postModel.postID}').child('comments').onValue.listen((event) {
      List<CommentModel> comments =getCommentModelList(Map<String,dynamic>.from(event.snapshot.value as Map));
      emit( FetchCommentSuccessState(comments));
    });
  }
  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is FetchPostLoadingEvent) {
      yield FetchPostLoadingState();
      fetchPosts();
    }
    if (event is LikePostLoadingEvent) {
      yield LikePostLoadingState();
      updatePostLikes(event.postModel,event.isLiked,event.isDisliked);
    }
    if (event is LikeCommentLoadingEvent) {
      yield LikeCommentLoadingState();
      updateCommentLikes(event.postModel,event.commentModel,event.isLiked,event.isDisliked);
    }
    if (event is PostCommentLoadingEvent) {
      yield PostCommentLoadingState();
      postComment(event.postModel,event.commentModel);
    }

  }
}
