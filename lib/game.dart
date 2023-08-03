import 'package:flutter/material.dart';
import 'dart:math';


class game extends StatelessWidget{
  const game({Key ? key}) : super(key: key);

  String get_ran()
  {
     Random rn = new Random();
     var arr=['assets/images/icon.png','assets/images/Bu2.png','assets/images/Bu1.png','assets/images/Button_background.png'];
     return arr[rn.nextInt(4)];
  }
  

@override
 Widget build(BuildContext)
 {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
    
    alignment: Alignment.center,
    height: 600,
    width: 600,
    color: Colors.black,
    child: Image.asset(get_ran()),
    ),
    );
 }

}