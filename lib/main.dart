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
import 'pages/welcome_page.dart';
import 'utils/analytics.dart' as Analytics;

void main() async {
  Analytics.analytics.logAppOpen();
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
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: '校园查',
        theme: ThemeData(
          primaryColor: Colors.deepPurpleAccent,
          scaffoldBackgroundColor: Colors.black,
        ),
        navigatorObservers: <NavigatorObserver>[Analytics.observer],
        //加入路由统计
        initialRoute: '/',
        routes: {
          '/': (context) => getRootPage(),
          '/login': (context) => LoginPage(),
          '/faq': (context) => FAQPage(),
          '/feedback': (context) => FeedBackPage(),
          '/about': (context) => AboutPage(context),
          '/welcome': (context) => WelcomePage(),
        },
      ),
    );
  }

  Widget getRootPage() {
//    // 取消引导页
//    if (DataStore.isFirstTime) {
//      return WelcomePage();
//    }
    if (DataStore.isSignedIn) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
