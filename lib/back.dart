import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '/login.dart';
//import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class back extends StatefulWidget {
  const back({Key? key}) : super(key: key);
  @override
  _backPathState createState() => _backPathState();
}

Future<bool> Encryption(var _paths) async {
  print("File in encryption mode");
  // print(result!.files.first.path.toString());
  print("path is ..");
  print(_paths['filepath']);
  print(_paths['text']);
  print(_paths['file_name']);
  print(_paths['Encryp_path']);
  String sp='';
  try {
    if(_paths['file_name'][0].compareTo('.')==0)
    {
       
       List<String>s=_paths['file_name'].split('.');
       sp=s[1]+"."+s[2]; 
       _paths['file_name']=sp;  
    }
    print(_paths);
    print("7");
    // Directory? dir;
    File image = new File(_paths['filepath']);
    print("1");
    var b = image.readAsBytesSync();
    var bytes_gb = Uint8List(b.length + 1);

    var bytespass = utf8.encode(_paths['text']);

    int passsum = 0;

    for (int i = 0; i < bytespass.length; i++) {
      passsum = passsum + bytespass[i];
    }

    int j;
    for (j = 0; j < b.length; j++) {
      bytes_gb[j] = b[j] ^ passsum;
    }
    print("Password in integer is $passsum");
    bytes_gb[j] = passsum;
    print("Password in bytes is ${bytes_gb[j]}");
    print("Loas...");
    // EasyLoading.show(status: 'Uploading');

    print("File in saved file");

    var newPath = _paths['Encryp_path'] +
        "/" +
        "Encrypted_Files" +
        "/" +
        _paths['file_name'] +
        ".N!";

    File f = new File(newPath);

    if (!await f.exists()) {
      await f.create(recursive: true);
    }
    f.writeAsBytesSync(bytes_gb);
    print("Successfull");
    FilePicker.platform.clearTemporaryFiles();
   // await image.delete();
  } catch (e) {
    print(e);
    EasyLoading.dismiss();
    Fluttertoast.showToast(
              msg: "File Is Encrypted Unsuccessfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 18.0);
  }

  return true;
}

var arr = new Map();
bool isLoading = false;

class _backPathState extends State<back> {
  Timer? _timer;
  var _textEditing = TextEditingController();
  
  void map() async {
    WidgetsFlutterBinding.ensureInitialized();
    arr['filepath'] = file_path;
    arr['text'] = _textEditing.text;
    arr['file_name'] = filename;
    arr['Encryp_path'] = Encrypt_path;
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  Directory? dir;

  bool is_obsecure = true;
  @override
  Widget build(BuildContext context) {
    final f=MediaQuery.of(context).copyWith(textScaleFactor: 1.0);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            height: 306,
            width: 340,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/encyrpt.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 52, right: 34, bottom: 8),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      // textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      cursorHeight: 22,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the password.';
                        } else {
                          return null;
                        }
                      },
                      controller: _textEditing,
                      autofocus: true,
                      style: 
                      TextStyle(
                        color: Colors.white,
                        fontSize: 15.6.sp,
                      ),
                
                      obscureText: is_obsecure,
                      maxLength: 8,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            // padding: EdgeInsets.all(10.00),
                            onTap: () {
                              setState(() {
                                is_obsecure = !is_obsecure;
                              });
                            },
                            child: Icon(is_obsecure
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 215, 195, 136),
                              fontSize: 13.8,
                              
                              ),
                              
                          border: InputBorder.none),
                          
                    ),
                    
                  ),
                ),
        
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false, // set to false
                            pageBuilder: (_, __, ___) => Password_Gen(),
                          ),
                        );
                        //  result=null;
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 190.5, right: 1, bottom: 2.5),
                        child: Container(
                          width: 68,
                          height: 46,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/cancel.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          EasyLoading.show(status: "Encrypting the file...");
                          print("Text is ");
                          print(_textEditing.text);
                          map();
                          File s=new File(file_path);
                          var sum = await compute(Encryption, arr);

                          if (sum == true) {
                            print(newPath);
                            await s.delete();
                            EasyLoading.dismiss();

                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false, // set to false
                                pageBuilder: (_, __, ___) => Password_Gen(),
                              ),
                            );
                            // result=null;
                            result = null;
                            print("Initial State");
                            setState(() {
                              print("I am in set state");
                              check_file = 'Select a File.';
                              //print();
                            });
                            Fluttertoast.showToast(
                                msg: "File Encrypted Successfully.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Fluttertoast.showToast(
                                msg:
                                    "Please! Share The Encrypted Files As Document🗄️.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 15.8);
                          }
                        }
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 12.3, right: 0, bottom: 6),
                        child: Container(
                          width: 42,
                          height: 47,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/ok.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
