import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hblgdx/utils/data_store.dart';
import 'package:oktoast/oktoast.dart';

import 'pages/about_page.dart';
import 'pages/faq_page.dart';
import 'pages/feedback_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() async {
  await DataStore.init();
  runApp(MyApp());

  // 状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: '校园查',
        theme: ThemeData(
          primaryColor: Colors.deepPurpleAccent,
          scaffoldBackgroundColor: Colors.black,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => DataStore.isSignedIn ? HomePage() : LoginPage(),
          '/login': (context) => LoginPage(),
          '/faq': (context) => FAQPage(),
          '/feedback': (context) => FeedBackPage(),
          '/about': (context) => AboutPage(context),
        },
      ),
    );
  }
}
