import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pass_gen/login.dart';
//import 'login.dart';

class AuthPath extends StatefulWidget{
  const AuthPath({Key ? key}) : super(key: key);

  @override
  _AuthPathState createState() => _AuthPathState();
}

class _AuthPathState extends State<AuthPath> {

  String g='';
  bool? _hasBioMetric;
  LocalAuthentication authentication = LocalAuthentication();

  Future<void> _checkbio() async{
    try{
      _hasBioMetric=  await authentication.isDeviceSupported();
      print(_hasBioMetric);
      if(_hasBioMetric!){
      _getAuth();
      }
      else{
       Navigator.push(context,MaterialPageRoute(builder: ((context) => Password_Gen()))); 
      }
    } on PlatformException catch(e)
    {
      print(e);
    }
  }

  Future<void> _getAuth() async{
    bool isAuth=false;
    try{
      g=authentication.hashCode.toString();
      print(authentication.hashCode.toInt());
      isAuth= await authentication.authenticate(
        localizedReason: 'Scan your finger print to access the app',
        options: const AuthenticationOptions(
       useErrorDialogs :true, 
       stickyAuth : true,
        ),
      ); 
    if(isAuth){
      Navigator.push(context,MaterialPageRoute(builder: ((context) => Password_Gen())));
    }
       

    }on PlatformException catch(e){
      print(e);
    }
  }

@override
void initState(){
 super.initState();
 _checkbio();
}

  @override
   Widget build(BuildContext context){
    return Scaffold(
      body:Container(
        color: Colors.black,
        alignment: Alignment(0,-0.7),
      child: InkWell(child: Image.asset('assets/images/icon.png'),
      onTap: (){
        _checkbio();
      },),
  ),

    );
  }
}