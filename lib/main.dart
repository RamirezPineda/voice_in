import 'package:flutter/material.dart';

import 'package:voice_in/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoutes(),
      initialRoute: Routes.home,
      theme: ThemeData(useMaterial3: true).copyWith(
        // primaryColor: const Color(0xffc3703e),
        appBarTheme: const AppBarTheme(
            // elevation: 0,
            // backgroundColor: Colors.transparent,
            // titleTextStyle: TextStyle(
            //   color: Colors.black,
            //   fontSize: 20,
            //   fontWeight: FontWeight.w600,
            //   letterSpacing: 1,
            // ),
            // foregroundColor: Colors.black,
            ),
        // scaffoldBackgroundColor: const Color(0xff0c0f14),
      ),
    );
  }
}
