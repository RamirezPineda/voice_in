import 'package:flutter/material.dart';

import 'package:voice_in/screens/screens.dart';

class Routes {
  static const String home = 'home';
  // static const String record = 'record';
  static const String card = 'card/card';

  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      home: (BuildContext context) => const HomeScreen(),
      // record: (BuildContext context) => const RecordScreen(),
    };
  }
}
