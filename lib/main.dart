import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_pull_down_to_home_screen/swipe_provider.dart';
import 'package:youtube_pull_down_to_home_screen/the%20file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> SwipeProvider() ,
      child: MaterialApp(
        title: 'youtube home page animation',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child: Scaffold(
        body: YoutubeHome(),
      ),
    );
  }
}


