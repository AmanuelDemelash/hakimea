import 'package:flutter/material.dart';
import 'package:hakimea/utils/constants.dart';

ThemeData dark = ThemeData(
  fontFamily:"myfont",
  primaryColor: Constants.primcolor,
  brightness: Brightness.dark,
  useMaterial3: true,
  //highlightColor: Color(0xFF252525),
  hintColor: const Color(0xFF252525),
  textTheme:const TextTheme(),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
