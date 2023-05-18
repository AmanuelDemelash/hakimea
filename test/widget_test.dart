// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/controllers/user_controllers/logincontroller.dart';
import 'package:hakimea/screens/auth/login.dart';

void main() {
  testWidgets("login test", (widgetTester)async{
    Get.put(LoginController());
  await widgetTester.pumpWidget(GetMaterialApp(
      home: Login(),
    ),
  );

    final ctr=find.text("Continue as guest");

    expect(ctr, findsNothing);


    // await  widgetTester.enterText(email_textfiled, "amanueldemelash@gmail.com");
    //  await widgetTester.enterText(password_textfiled, "aman1234");
    //  //await widgetTester.tap(login_button);
    //  await widgetTester.pump();

    // cheek output
    // expect(find.text("amanueldemelash@gmail.com"), findsOneWidget);
    // expect(find.text("aman1234"), findsOneWidget);
    


  });
}
