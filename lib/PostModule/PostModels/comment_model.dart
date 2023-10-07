import 'package:reddit_post/PostModule/PostModels/user.dart';

class CommentModel {
  String commentContent;
  int commentLikes;
  String commentID;
  User commentator;
  bool isLiked;
  bool isDisliked;
  String date;

  CommentModel(
      {required this.commentator,
      required this.commentLikes,
      required this.commentID,
      required this.commentContent,
        this.isLiked=false,
        this.isDisliked=false,
        this.date=""
      });

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
        commentator: User.fromMap(map["commentator"]) ,
        commentLikes: map["commentLikes"],
        commentID: map["commentID"],
        commentContent: map["commentContent"],
        isLiked: map["isLiked"]??false,
        isDisliked: map["isDisliked"]??false,
        date: map["date"]??"",
      );
  Map<String,dynamic> toMap()=>{
    "commentator":commentator.toMap(),
    "commentLikes":commentLikes,
    "commentID":commentID,
    "isLiked":isLiked,
    "isDisliked":isDisliked,
    "date":date,
    "commentContent":commentContent,
  };
}
