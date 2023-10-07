import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:bottom_sheet_scaffold/views/bottom_sheet.dart';
import 'package:bottom_sheet_scaffold/views/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_post/PostModule/PostModels/post_model.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_events.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_states.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_view_model.dart';
import 'package:reddit_post/shared/themes.dart';
import 'package:sizer/sizer.dart';

import '../../shared/views.dart';
import 'Widgets/comments_view.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  PostViewModel? _postViewModel;
  PostModel? postModel ;
  bool isLiked=false;
  bool isDisliked=false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostViewModel,PostState>(
      listener: (context, state) {
        listenToStateChanges(state);
      },
      builder: (context, state) {
        _postViewModel =context.read<PostViewModel>();
        return (state is FetchPostLoadingState)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : buildPostBody();
      },
    );
  }
  buildPostBody()=>BottomSheetScaffold(
        draggableBody: true,
        dismissOnClick: true,
        backgroundColor: Themes.kScreenBackGroundColor,
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back_sharp),
          actions: const [Icon(Icons.format_list_bulleted)],
          title: Center(
              child: Text(
            'Post Category',
            style: Themes.textTheme.displaySmall,
          )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPostContent(),
            buildPostFooter(),
          ],
        ),
        bottomSheet: DraggableBottomSheet(
          maxHeight: 55.h,
          animationDuration:const  Duration(milliseconds: 200),
          backgroundColor: Themes.kScreenBackGroundColor,
          body: CommentsView(comments: postModel?.comments??[],postModel: postModel),
          // header: SizedBox(), //header is not required
        ),
      );
  listenToStateChanges(state){
    if(state is FetchPostSuccessState) {
      postModel=state.posts[0];
    }
    if(state is LikePostSuccessState) {
      isLiked=state.isLiked;
      isDisliked=state.isDisliked;
    }
  }
 Widget buildPostContent(){
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: Image.network(postModel?.postContent??'',fit: BoxFit.cover,),
    );
  }
  Widget buildPostFooter(){
    return Padding(
      padding:  EdgeInsets.all(2.w),
      child: Row(children: [
        buildUserDataWidget(),
        buildPostActions(),
      ],),
    );
  }
  Widget buildUserDataWidget(){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildUserMeta('${postModel?.publisher.name}'),
          buildPostDescription(),

        ],
      ),
    );
  }
 Widget buildPostDescription()=> Padding(
   padding: const EdgeInsets.all(8.0),
   child: Text('${postModel?.description}',style: Themes.textTheme.displaySmall,maxLines: 8,overflow: TextOverflow.ellipsis,),
 );


  Widget buildPostActions(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildLikeButton(),
        SizedBox(height:2.h,child: Text('${postModel?.likes}',style: Themes.textTheme.displaySmall,)),
        buildDislikeButton(),
        SizedBox(height:3.h ,),
        buildCommentsButton(),
        SizedBox(height:2.h,child: Text('${postModel?.comments?.length}',style: Themes.textTheme.displaySmall,)),
        SizedBox(height:3.h ,),
        buildShareButton(),
      ],);
  }

  buildLikeButton()=>
      SizedBox(height: 5.h, child: IconButton(
        onPressed: () {
          if(isDisliked) {
            postModel?.likes += 1;
          }
          _postViewModel?.add(LikePostLoadingEvent(postModel!,!isLiked,false));
        },
        color:isLiked?Colors.red:Colors.white ,
        icon:isLiked?getActionIcon(Icons.upload_sharp): getActionIcon(Icons.upload_outlined),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,));

  buildDislikeButton() =>
      SizedBox(height: 5.h,
          child: IconButton(onPressed: () {
            if(isLiked) {
              postModel?.likes -= 1;
            }
            _postViewModel?.add(LikePostLoadingEvent(postModel!,false,!isDisliked));
          },
              color: isDisliked?Colors.blue:Colors.white,
              icon: isDisliked?getActionIcon(Icons.download_sharp):getActionIcon(Icons.download_outlined),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent));

  buildCommentsButton() =>
      SizedBox(height: 4.h,
          child: IconButton(padding: EdgeInsets.zero,
              onPressed: () {
                BottomSheetPanel.open();
              },
              color: Colors.white,
              icon: getActionIcon(Icons.comment),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent));

  buildShareButton() =>
      SizedBox(height: 4.h,
          child: IconButton(onPressed: () {},
              color: Colors.white,
              icon: getActionIcon(Icons.ios_share_outlined),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent));


}
