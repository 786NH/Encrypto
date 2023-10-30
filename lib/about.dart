
import 'package:flutter/material.dart';

class about extends StatelessWidget{
  const about({
    Key,key
  }) : super(key: key);
 
 @override
  Widget build(BuildContext context){
    var _media = MediaQuery.of(context);
  return Center(
    child: Container(
    height: 560,
    width: 350,
       // child: Image.asset('assets/images/about.png'), 
        decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/About.png'),
                fit: BoxFit.cover,
              ),
            ),
  ),
  );
  }
}