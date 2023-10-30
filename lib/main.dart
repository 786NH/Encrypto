import 'package:flutter/material.dart';
import 'package:Encrypto/AuthPath.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/AuthPath.dart';
import '/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());

  configLoading();
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
     // designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Encrypto',
      theme: ThemeData(
       textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
        primarySwatch: Colors.grey,
      ),
      home: AuthPath(),
     builder: EasyLoading.init(),
     
    );
      },
      );  
  }
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
   // textScaleFactor: 1.0;
}
