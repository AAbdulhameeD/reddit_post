import 'package:random_password_generator/random_password_generator.dart';
import 'package:reddit_post/PostModule/PostModels/comment_model.dart';
import 'package:reddit_post/PostModule/PostModels/post_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class IPostRepository{
  Future<List<PostModel>> getRedditPosts();
  Stream<List<CommentModel>> getPostComments(PostModel postModel);
  Future<void> updatePostLikes(PostModel postModel);
  Future<void> updateCommentLikes(PostModel postModel,CommentModel commentModel);
  Future<void> postComment(PostModel postModel,CommentModel commentModel);

}
class PostRepository extends IPostRepository {
   final DatabaseReference _databaseReference=FirebaseDatabase.instance.ref();

  @override
  Future<List<PostModel>> getRedditPosts() async{
    final  snapShot = await _fetchPosts();
    final Map<String,dynamic> postsMap= Map<String,dynamic>.from(snapShot as Map) ;
    List<PostModel> posts=[];
      for (var element in Map<dynamic, dynamic>.fromIterable(postsMap['posts']).entries) {
        posts.add(PostModel.fromMap(Map<String,dynamic>.from(element.value)));
    }
    return  posts;
  }
  @override
  Stream<List<CommentModel>> getPostComments(PostModel postModel) async*{
    List<CommentModel>? comments;
    _databaseReference.child('posts').child('${postModel.postID}').child('comments').onValue.listen((event) {
       comments =getCommentModelList(event.snapshot as Map);
    });
     yield comments??[];
  }

  _fetchPosts()async{
    final snapshot = await _databaseReference.get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return 'No data available.';
    }
  }

  @override
  Future<void> updatePostLikes(PostModel postModel) async {
    _databaseReference.child('posts').child('${postModel.postID}').child('likes').set(postModel.likes);
  }
  @override
  Future<void> updateCommentLikes(PostModel postModel,CommentModel commentModel) async {
    _databaseReference.child('posts').child('${postModel.postID}').child('comments').child(commentModel.commentID).set(commentModel.toMap());
  }

  @override
  Future<void> postComment(PostModel postModel,CommentModel commentModel) async{
    String commentID =RandomPasswordGenerator()
        .randomPassword(
        letters: false,
        numbers: true,
        passwordLength: 6,
        specialChar: false,
        uppercase: false)
        .toString();
    Map<String, dynamic> updates = {};
    commentModel.commentID=commentID;
    updates = {
      commentID: commentModel.toMap()
    };
    _databaseReference.child('posts').child('${postModel.postID}').child('comments').update(updates);
  }
}