import 'package:flutter/material.dart';
import 'package:hblgdx/utils/data_store.dart';
import 'package:oktoast/oktoast.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() async {
  await DataStore.init();
  runApp(MyApp());
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
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => DataStore.isSignedIn ? HomePage() : LoginPage(),
          '/login': (context) => LoginPage(),
        },
      ),
    );
  }
}
