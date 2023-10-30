import 'package:flutter/material.dart';
import '/login.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
//import 'dart:ffi';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui';

class decryption extends StatefulWidget {
  const decryption({Key? key}) : super(key: key);
  @override
  _decPathState createState() => _decPathState();
}

Future<bool> Decryption(var _paths) async {
  print("File in decryption mode");
  print("path is ..");
  print(_paths['filepath']);
  print(_paths['text']);
  print(_paths['file_name']);
  print(_paths['Encryp_path']);

  String decy_file_name = '';
  decy_file_name =
      _paths['file_name'].substring(0, _paths['file_name'].lastIndexOf("."));
  print("File name is $decy_file_name");

  try {
    print(_paths);
    print("7");
    // Directory? dir;
    File image = new File(_paths['filepath']);
    print("1");

    var bytes = image.readAsBytesSync();

    var bytespass = utf8.encode(_paths['text']);

    int passsum = 0;

    for (int i = 0; i < bytespass.length; i++) {
      passsum = passsum + bytespass[i];
    }
    print("Password in integer is $passsum");
    bytespass[0] = passsum;
    print("Password in bytes is ${bytespass[0]}");

    if (bytes[bytes.length - 1] == bytespass[0]) {
      var bytes_f = Uint8List(bytes.length - 1);

      for (int i = 0; i < bytes_f.length; i++) {
        bytes_f[i] = bytes[i] ^ passsum;
      }
      var newPath =
          _paths['Encryp_path'] + "/" + "Decrypted_Files" + "/" + decy_file_name;
      File f = new File(newPath);
      if (!await f.exists()) {
        await f.create(recursive: true);
      }
      f.writeAsBytesSync(bytes_f);
      print("Successfull");
      print("Decryption is done...");
      FilePicker.platform.clearTemporaryFiles();
    } else {
      print("Wrong password");
      return false;
    }
  } catch (e) {
    print(e);
    EasyLoading.dismiss();
    Fluttertoast.showToast(
              msg: "File Is Decrypted Unsuccessfully.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 18.0);
  }

  return true;
}

var drr = new Map();

class _decPathState extends State<decryption> {
  var _textEditing = TextEditingController();
  bool is_obsecure = true;
  final _formKey = GlobalKey<FormState>();
  void map() async {
    WidgetsFlutterBinding.ensureInitialized();
    drr['filepath'] = file_path;
    drr['text'] = _textEditing.text;
    drr['file_name'] = filename;
    drr['Encryp_path'] = Encrypt_path;
  }

  @override
  Widget build(BuildContext context) {
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
                image: AssetImage('assets/images/decrypt.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 52, right: 34, bottom: 13),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.6,
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
                          hintStyle: new TextStyle(
                              color: Color.fromARGB(255, 215, 195, 136),
                              fontSize: 13.3),
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
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 192.6, right: 1, bottom: 3.8),
                        child: Container(
                          width: 64,
                          height: 43,
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
                          EasyLoading.show(status: "Decrypting the file...");
                          print("Text is ");
                          print(_textEditing.text);
                          map();
                          var sum = await compute(Decryption, drr);

                          if (sum == true) {
                            print(newPath);

                            EasyLoading.dismiss();

                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false, // set to false
                                pageBuilder: (_, __, ___) => Password_Gen(),
                              ),
                            );
                            // result=null;

                            print("Initial State");
                            setState(() {
                              print("I am in set state");
                              check_file = 'Select a File.';
                              print(check_file);
                            });

                            Fluttertoast.showToast(
                                msg: "File Decrypted Successfully.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
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
                          } else {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: "Password Is Incorrect.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            _textEditing.clear();
                            
                          }
                        }
                      },

                      // result=null;

                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 15, right: 6, bottom: 6),
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
