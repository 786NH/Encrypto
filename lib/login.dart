import 'dart:io';
import 'dart:ffi';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:Encrypto/file_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter/widgets.dart' hide Intent;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/widgets.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Password_Gen extends StatefulWidget {
  const Password_Gen({Key? key}) : super(key: key);

  @override
  _Password_gen createState() => _Password_gen();
}

RegExp r = new RegExp("\\.N!");

final Uri _url = Uri.parse("https://docs.google.com/forms/d/e/1FAIpQLSdXKh5i70OHtkA7IARFWx0VXZORUC7TMt1NEzhgcRuB3oSx1Q/viewform?usp=sf_link");
final Uri url = Uri.parse("https://youtu.be/bvpolNbxxvg");
Future<void> _launchUrl() async {
  if (!await launchUrl(_url,
  mode: LaunchMode.externalApplication,)) {
    throw Exception('Could not launch $_url');
  }
}
Future<void> ulaunchUrl() async {
  if (!await launchUrl(url,
  mode: LaunchMode.externalApplication,)) {
    throw Exception('Could not launch $_url');
  }
}
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'navedhasanmbd12@gmail.com',
     query: encodeQueryParameters(<String, String>{
      'subject': 'Contact Us',
    }),
  );
  String ?ver;
Future<bool> _request_per(Permission permission) async {

  print("I am in request permission");
  try {
     
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    print("1");
    
    ver=build.version.sdkInt.toString();
    print(ver);
   // int s=int.parse(ver??'');
    if ((build.version.sdkInt) >=30) {
      var re = await Permission.manageExternalStorage.request();
      print(re);
      //var s= await Permission.storage.request();
      if (re.isGranted) {
        print("true");
        return true;
      } else {
        print("False");
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
      }
    }
  } catch (e) {
    print(e);
  }
  return true;
}

String newPath = "";

Future<bool> save_file() async {
  newPath = "";
  print("I am in save file");
  try {
    Directory? dir;
    if (await _request_per(Permission.storage)) {
      dir = await getExternalStorageDirectory();
      print("Directory is $dir");
      List<String> folders = dir!.path.split("/");
      for (int x = 1; x < folders.length; x++) {
        String folder = folders[x];
        if (folder != "Android") {
          newPath = newPath + "/" + folder;
        } else {
          newPath = newPath + "/";
          break;
        }
      }
      newPath = newPath + "Encrypto";
      print("New path is $newPath");
      dir = Directory(newPath);

      if (!await dir.exists()) {
        await dir.create(recursive: true);
        print(newPath);
        print("Directory created successfully...");
      } else {
        return true;
      }
    }
    
  } catch (e) {
    print(e);
  }
  // print("Directory created successfully...");
  return true;
}

String Encrypt_path = newPath;
String filename = '';
FilePickerResult? result;
PlatformFile? pickedfile;
String file_path = '';
String check_file = "Select a File.";

String int_check = "initial";
String prev = 'initial';
List<SharedMediaFile>? _sharedFiles;
String file_name_toast = '';
void setFile(String name) {
    String sub_file = '';
    String sub_file_ext = '';

    if (name.contains(".") && name.length > 20) {
      sub_file = name.substring(0, 20);
      sub_file_ext = name.substring(name.lastIndexOf("."));
      sub_file_ext = ".." + sub_file_ext;
    } else if (filename.length > 20) {
      sub_file = name.substring(0, 20) + "...";
    } else {
      sub_file = name;
    }
    file_name_toast = sub_file + sub_file_ext;
  }


class _Password_gen extends State<Password_Gen> {
  late StreamSubscription _intentDataStreamSubscription;
  
  String? _sharedText;
  @override
  void initState() {
    super.initState();
    save_file();
    
    _init();
  }

  Future<void> _init() async {
    print("_init");

    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        print("test2");
        if (_sharedFiles!.length != 0) {
          print("I am in shared files");
          file_path = _sharedFiles![0].path.toString();
          filename = file_path.substring(file_path.lastIndexOf('/') + 1);
          int_check = filename;
          setFile(filename);
          print('File name is $filename\n path is $file_path');

          if (!(prev.compareTo(int_check) == 0)) {
            print("I am in init state");
            check_file = "File ($file_name_toast) has Loaded.";
            Fluttertoast.showToast(
                msg: "File Is Loaded.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 18.0.sp);
               // textScaleFactor: 1.0;
            prev = int_check;
          }
        }

        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        print("test2");
        if (_sharedFiles!.length != 0) {
          print("i am in shared files");
          file_path = _sharedFiles![0].path.toString();
          filename = file_path.substring(file_path.lastIndexOf('/') + 1);
          int_check = filename;
          setFile(filename);
          print('File name is $filename\n path is $file_path');

          if (!(prev.compareTo(int_check) == 0)) {
            print("I am in init state");
            check_file = "File ($file_name_toast) has Loaded.";
            Fluttertoast.showToast(
                msg: "File Is Loaded.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 18.0);
               // textScaleFactor: 1.0;
            prev = int_check;
          }
        }
        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    });
    print("Test1");

    print("File path from the intent is $int_check");

    print('File name in intent is $filename');

    print('Path in intent is $file_path');
    setState(() {});
  }

  // FilePickerResult? result;

  bool isLoading = false;
  //File? fileToDisplay;
  String? cont;
  var myfile;

  
  void pickfile() async {
    print("Test..");
    String sub_file = '';
    String sub_file_ext = '';
    try {
      setState(() {
        isLoading = true;
      });
     // textScaleFactor: 1.0;
      EasyLoading.show(status: "File is loading...");
      
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null) {
        print("Result is $result");

        pickedfile = result!.files.first;
        filename = result!.files.first.name;
        print("Extension of the file is ....${pickedfile!.extension}");
        setFile(filename);

        EasyLoading.dismiss();
        print('succcess');
        file_path = pickedfile!.path.toString();
        print("File path from the file picker is $file_path");
        print(filename);
        //  print(file_path);
        setState(() {
          print("File test..");
          check_file = "File ($file_name_toast) has Loaded.";
          Fluttertoast.showToast(
              msg: "File Is Loaded.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 18.0.sp);
             // textScaleFactor: 1.0;
        });
      } else if (result == null) {
        EasyLoading.dismiss();
      }

      setState(() {
        isLoading = false;
      });
      print('Success');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
              msg: "File Loaded Unsuccessfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 18.0.sp,
              );
              
      EasyLoading.dismiss();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    var _media = MediaQuery.of(context);
    return Stack(
      children: [
        const background(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: Container(
              color: Color.fromARGB(255, 53, 52, 52),
              child: ListView(
              // Important: Remove any padding from the ListView.
              //  padding: EdgeInsets.zero,

              children: [
                Container(
                  // height: 150,
                  height: 140,
                 // width: 120,
                  // color: Color.fromARGB(255, 105, 131, 145),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 15, 15, 15),
                    ),
                  child: DrawerHeader(
                    
                    child: Row(
                      children: [
                       Padding(padding: EdgeInsets.only(right: 15),
                       child: Image.asset('assets/images/icon.png'),
                       ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              '.',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Encrypto',
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Color.fromARGB(255, 232, 246, 186)),textScaleFactor: 1.0
                            ),
                            Text(
                              'By Naved Hasan',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color.fromARGB(255, 230, 232, 222)),textScaleFactor: 1.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  
                ),
               
                ListTile(
                  leading: Icon(Icons.contact_page,color:Colors.white,size: 26,),
                   title: Text('Contact Us',style: TextStyle(color: Colors.white,fontSize: 15.sp),textScaleFactor: 1.0),
                   onTap: (){
                    print("Contact Us");
                    launchUrl(emailLaunchUri);
                   },
                ),
                ListTile(
                  leading: Icon(Icons.feedback,color: Colors.white,size: 26.sp,),
                  title: Text('Feedback',style: TextStyle(color: Colors.white,fontSize: 15.sp),textScaleFactor: 1.0),
                  onTap: () {
                    _launchUrl();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.youtube_searched_for,color: Colors.white,size: 27,),
                  title: Text('How To Use ',style: TextStyle(color: Colors.white,fontSize: 15.sp),textScaleFactor: 1.0),
                  onTap: () {
                   ulaunchUrl();
                  },
                ),
                 ListTile(
                  leading: Icon(Icons.lightbulb_outline_rounded,color: Colors.white,size: 27,),
                  title: Text('About',style: TextStyle(color: Colors.white,fontSize: 15.sp),textScaleFactor: 1.0),
                  onTap: () {
                    Navigator.pop(context);
                    about(context);
                  },
                ),
                
              ],
            ),
              
              ),
          ),
          appBar: AppBar(
            title: const Text('Encrypto'),
          ),
          body: Column(children: [
            Container(
              height: _media.size.height * 0.16,
              //color: Colors.blue,
            ),
            Container(
              height: _media.size.height * 0.7324,
              alignment: Alignment.center,
              //color: Colors.amber,
              child: Column(mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: InkWell(
                        child: Container(
                          width: 250,
                          height: 137,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/file.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          // showOverlay(context);
                          // save_file();
                          print("testt..");
                          pickfile();
                          print("Result is ..");
                          print(result);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        check_file,
                        style: TextStyle(
                          fontSize: 14.1.sp,
                          background: Paint()
                            ..color = Colors.black
                            ..strokeWidth = 20
                            ..strokeJoin = StrokeJoin.round
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.stroke,
                          color: Colors.white,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: InkWell(
                          child: Container(
                            width: 250,
                            height: 87,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Bu1.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            print("Encryption button");
                            if (!(check_file.compareTo("Select a File.") ==
                                0)) {
                              //showOverlay(context);
                              if (!r.hasMatch(filename)) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false, // set to false
                                    pageBuilder: (_, __, ___) => back(),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: "File Is Already Encrypted.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              print("Choose the file for encryption");
                              Fluttertoast.showToast(
                                  msg:
                                      "Please! Choose the File For Encryption.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: InkWell(
                        child: Container(
                          width: 250,
                          height: 85,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/Bu2.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          print("Decryption button.");
                          if (!(check_file.compareTo("Select a File.") == 0)) {
                            //showOverlay(context);
                            if (r.hasMatch(filename)) {
                              print("Decryption mode is started");
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false, // set to false
                                  pageBuilder: (_, __, ___) => decryption(),
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: "File is not Encrypted",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            print("Choose the file for decryption");
                            Fluttertoast.showToast(
                                msg: "Please! Choose the File For Decryption.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 110),
                      child: InkWell(
                        child: Container(
                          width: 255,
                          height: 85,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/whfile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () async{
                          if(result==null && _sharedFiles!.length == 0)
                              check_file="Select a File.";
                                Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false, // set to false
                                  pageBuilder: (_, __, ___) => file_storage(),
                                ),
                              );

                        },
                      ),
                    )
                  ]),
            ),
          ]),
        )
      ],
    );
  }
  about(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
    child: Container(
    height: 535,
    width: 335,
       // child: Image.asset('assets/images/about.png'), 
        decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/About.png'),
                fit: BoxFit.cover,
              ),
            ),
        
  ),
  
  );
          
      
      },
    );
  }
}
