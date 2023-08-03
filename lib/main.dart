import 'package:flutter/material.dart';
import 'package:pass_gen/AuthPath.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/AuthPath.dart';
import '/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 57
    ..textStyle = TextStyle(
      // color: Colors.white,
      fontSize: 15,
      // fontWeight: FontWeight.bold,
      //backgroundColor: Colors.black,
      background: Paint()
        ..color = Color.fromARGB(255, 235, 224, 192)
        ..strokeWidth = 18
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
      // color: Colors.white,
    )
    ..textColor = Colors.black
    ..radius = 17
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.white
    ..indicatorColor = Colors.white
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[]
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Encrypto',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: Password_Gen(),
      builder: EasyLoading.init(),
    );
  }
}
