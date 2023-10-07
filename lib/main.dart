import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_post/PostModule/PostViewModel/post_events.dart';
import 'package:reddit_post/shared/themes.dart';
import 'package:sizer/sizer.dart';

import 'PostModule/PostView/post_view.dart';
import 'PostModule/PostViewModel/post_view_model.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (BuildContext context, Orientation orientation,
                DeviceType deviceType) =>
            MaterialApp(
              title: 'Reddit post',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Themes.kPrimarySwatch,
                  fontFamily: Themes.kFontFamily),
              home: const MyHomePage(),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>PostViewModel()..add(FetchPostLoadingEvent()),
      child:  const PostView(),
    );
  }
}
