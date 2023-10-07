import 'package:reddit_post/PostModule/PostModels/comment_model.dart';

import '../PostModels/post_model.dart';

abstract class PostEvent {}

class FetchPostLoadingEvent extends PostEvent {}
class LikePostLoadingEvent extends PostEvent {
  final bool isLiked;
  final bool isDisliked;
  final PostModel postModel;
  LikePostLoadingEvent(this.postModel,this.isLiked,this.isDisliked);
}
class LikeCommentLoadingEvent extends PostEvent {
  final bool isLiked;
  final bool isDisliked;
  final PostModel postModel;
  final CommentModel commentModel;
  LikeCommentLoadingEvent(this.postModel,this.commentModel,this.isLiked,this.isDisliked,);
}
class DislikePostLoadingEvent extends PostEvent {
  final bool isDisliked;
  final bool isLiked;
  final PostModel postModel;
  DislikePostLoadingEvent(this.postModel,this.isDisliked,this.isLiked);
}
class PostCommentLoadingEvent extends PostEvent {
  final PostModel postModel;
  final CommentModel commentModel;
  PostCommentLoadingEvent(this.postModel,this.commentModel);
}