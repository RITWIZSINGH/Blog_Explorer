// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_explorer/screens/blog_list_screen.dart';
import 'package:blog_explorer/screens/blog_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_explorer/blocs/blog_bloc.dart';
import 'package:blog_explorer/services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCtDYpUPqSN1Vuh4C5zkG4vFNK3WXbJK1U",
          appId: "1:1025134458145:web:aeca5a8c448e0a4f563a60",
          messagingSenderId: "1025134458145",
          projectId: "blog-explorer-d7580"));       
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => BlogBloc(
          ApiService(),
          FirebaseFirestore.instance,
        ),
        child: const BlogListScreen(),
      ),
    );
  }
}
