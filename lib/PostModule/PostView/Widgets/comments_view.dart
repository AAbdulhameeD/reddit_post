import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_events.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_view_model.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/themes.dart';
import '../../../shared/views.dart';
import '../../PostModels/comment_model.dart';
import '../../PostModels/post_model.dart';
import '../../PostModels/user.dart';
import '../../PostViewModel/post_states.dart';

class CommentsView extends StatefulWidget {
    List<CommentModel> comments;
    PostModel? postModel;
   CommentsView({Key? key,required this.comments, this.postModel}) : super(key: key);

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  bool isLiked=false;
  bool isDisliked=false;
  TextEditingController commentController =TextEditingController();
  PostViewModel? _postViewModel;
  CommentModel commentModel = CommentModel(
    commentator: User(name: "Ahmed Abdulhameed",image: ""),
    commentLikes: 0,
    commentID: "",
    commentContent: "",
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostViewModel,PostState>(
      listener: (context,state){
        listenToStateChanges(state);
      },
      builder: (context,state){
        listenToStateChanges(state);
        _postViewModel =context.read<PostViewModel>();
        return SizedBox(
          height: 55.h,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child : ListView.builder(itemBuilder: (context,index)=>buildCommentContainer( widget.comments[index]),itemCount: widget.comments.length,)),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: commentController,
                        style:const  TextStyle(
                          color: Colors.white,
                        ),
                        decoration: getInputDecoration(),
                      ),
                    ),
                    FilledButton(style:FilledButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.white,
                      // other arguments
                    ) ,onPressed: (){
                      commentModel.commentContent=commentController.text;
                      commentModel.date=DateTime.now().toString();
                      _postViewModel?.add(PostCommentLoadingEvent(widget.postModel!, commentModel));
                      commentController.clear();
                    }, child: const Text('Reply'),)
                  ],
                ),
              )
            ],),
        );
      },
    );
  }
  InputDecoration getInputDecoration() => InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        filled: true,
        fillColor:ThemeColors.kPrimaryLight.withOpacity(.5)  ,
        contentPadding: const EdgeInsets.all(10),
        labelText: "Add a comment",
        labelStyle: TextStyle(
          height: .5,
          color: Colors.white.withOpacity(.3) ,
          fontSize: 14.sp,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeColors.kPrimaryLight,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
      );
  Widget buildCommentContainer(CommentModel commentModel)=>Card(
    color: Colors.black26.withOpacity(.5),
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildUserMeta(commentModel.commentator.name),
          buildCommentDescription(commentModel.commentContent),
          buildCommentActions(commentModel)
        ],
      ),
    ),
  );
  Widget buildCommentDescription(String comment)=> Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(comment,style: Themes.textTheme.displaySmall,maxLines: 8,overflow: TextOverflow.ellipsis,),
  );

  Widget buildCommentActions(CommentModel commentModel) => Row(
        children: [
          const Spacer(),
          buildLikeButton(commentModel),
          SizedBox(height:2.h,child: Text('${commentModel.commentLikes}',style: Themes.textTheme.displaySmall,)),
          buildDislikeButton(commentModel)
        ],
      );

  buildLikeButton(CommentModel commentModel)=>
      SizedBox(height: 5.h, child: IconButton(
        onPressed: () {
          if(!commentModel.isLiked) {
            if (commentModel.isDisliked) {
              commentModel.commentLikes += 1;
            }
            commentModel.isLiked = !commentModel.isLiked;
            commentModel.isDisliked = false;
            _postViewModel?.add(LikeCommentLoadingEvent(
                widget.postModel!, commentModel, commentModel.isLiked, false));
          }
        },
        color:commentModel.isLiked?Colors.red:Colors.white ,
        icon:commentModel.isLiked?getActionIcon(Icons.upload_sharp): getActionIcon(Icons.upload_outlined),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,));

  buildDislikeButton(CommentModel commentModel) =>
      SizedBox(height: 5.h,
          child: IconButton(onPressed: () {
            if(!commentModel.isDisliked){
              if (commentModel.isLiked) {
                commentModel.commentLikes -= 1;
              }
              commentModel.isDisliked = !commentModel.isDisliked;
              commentModel.isLiked = false;

              _postViewModel?.add(LikeCommentLoadingEvent(widget.postModel!,
                  commentModel, false, commentModel.isDisliked));
            }
          },
              color: commentModel.isDisliked?Colors.blue:Colors.white,
              icon:commentModel. isDisliked?getActionIcon(Icons.download_sharp):getActionIcon(Icons.download_outlined),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent));

  void listenToStateChanges(state){
    if(state is FetchCommentSuccessState) {
      widget.comments =state.comments;
    }
    if(state is LikeCommentSuccessState) {
      {
        isLiked = state.isLiked;
        isDisliked = state.isDisliked;
      }
    }
  }

}
