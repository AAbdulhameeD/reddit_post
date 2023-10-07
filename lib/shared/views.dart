import 'package:flutter/material.dart';
import 'package:reddit_post/shared/themes.dart';
import 'package:sizer/sizer.dart';

Widget getAvatarWidget()=>Container(
  padding: EdgeInsets.all(1.w),
  width: 10.w,
  height: 10.w,
  child: const CircleAvatar(
      radius: 100,
      backgroundColor: Colors.amber,
      child: Icon(Icons.accessibility_rounded,color: Colors.white,)),
);

Widget buildUserMeta(String name)=> Row(children: [
  getAvatarWidget(),
  Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text(name,style: Themes.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600 ),),
  ),
],);

Icon getActionIcon(IconData iconData)=>Icon(iconData,size: 8.w,);
