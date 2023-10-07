import 'package:reddit_post/PostModule/PostModels/comment_model.dart';

import '../PostModels/post_model.dart';

abstract class PostState {}
class PostInitState extends PostState {}

class FetchPostLoadingState extends PostState {}
class FetchPostSuccessState extends PostState {
  List<PostModel> posts;
  FetchPostSuccessState(this.posts);
}

class FetchPostErrorState extends PostState {}

class LikePostLoadingState extends PostState {}
class LikePostSuccessState extends PostState {
  final bool isLiked ;
  final bool isDisliked ;
  LikePostSuccessState(this.isLiked,this.isDisliked);
}
class LikePostErrorState extends PostState {}

class LikeCommentLoadingState extends PostState {}
class LikeCommentSuccessState extends PostState {
  final bool isLiked ;
  final bool isDisliked ;
  LikeCommentSuccessState(this.isLiked,this.isDisliked);
}
class LikeCommentErrorState extends PostState {}



class PostCommentLoadingState extends PostState{}
class PostCommentSuccessState extends PostState{
  final CommentModel commentModel;
  PostCommentSuccessState(this.commentModel);
}

class PostCommentErrorState extends PostState{}
class FetchCommentSuccessState extends PostState{
  final List<CommentModel> comments;
  FetchCommentSuccessState(this.comments);
}
class FetchCommentErrorState extends PostState{}