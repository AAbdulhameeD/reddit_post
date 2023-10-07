import 'package:reddit_post/PostModule/PostModels/user.dart';

import 'comment_model.dart';

class PostModel {
  String description;
  int likes;
  int postID;
  String postContent;
  List<CommentModel>? comments;
  String postTitle;
  User publisher;
  PostModel({
    required this.description,
    required this.likes,
    required this.postContent,
    required this.postTitle,
    required this.publisher,
    required this.postID,
    this.comments,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) => PostModel(
      description: map["description"],
      likes: map["likes"],
      postContent: map["postContent"],
      postID: map["postID"],
      comments: map["comments"]!=null?getCommentModelList( map["comments"]):[] ,
      publisher: User.fromMap(Map<String,dynamic>.from(map["publisher"])),
      postTitle: map["postTitle"]);

  Map<String, dynamic> toMap() => {
        "description": description,
        "likes": likes,
        "postContent": postContent,
        "postTitle": postTitle,
        "postID": postID,
        "publisher": publisher.toMap(),
      };
}
List<CommentModel> getCommentModelList(Map  json) {

/*  List<CommentModel> comments = [];
  for (var element in Map<dynamic, dynamic>.fromIterable(json).entries){
    comments.add(CommentModel(commentContent: element.value['commentContent'],
        commentLikes: element.value['commentLikes'],
        commentID: element.value['commentID'],
        commentator:User.fromMap(element.value['commentator'])));
  }
  return comments;*/
  List<CommentModel> comments = [];
  for (var element in Map<String, dynamic>.from(json).values) {
    comments.add(CommentModel.fromMap(Map<String, dynamic>.from(element)));
  }
  return comments;
}