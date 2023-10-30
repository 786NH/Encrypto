import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info_plus/device_info_plus.dart';
class file_storage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final FileManagerController controller = FileManagerController();

class _MyAppState extends State<file_storage> {
 
  @override
  void initState()
  {
    super.initState();
    
    print("InitSatte");
   // build(context);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        if (controller.getCurrentPath
                .toString()
                .compareTo('/storage/emulated/0/Encrypto') ==
            0) {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => Password_Gen())));
        } 
        else{
        await controller.goToParentDirectory();
        
        }
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Encrypto',
        home: HomePage(),
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
      ),
    );
  }
}

Future<File> changeFileNameOnly(File file, String newFileName, String ext) {
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName + "." + ext;
  return file.rename(newPath);
}

class HomePage extends StatelessWidget {
  String s = '';
  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child:
          AppBar(
            toolbarHeight: 142,
            backgroundColor: Color.fromARGB(255, 29, 29, 29),
            actions: [
              IconButton(
                onPressed: () {
                  
                   sort(context);
                },
                icon: Icon(
                  Icons.sort_rounded,
                  color: Colors.white,
                ),
              ),
            ],
            title: ValueListenableBuilder<String>(
              valueListenable: controller.titleNotifier,
              builder: (context, title, _) => 
            Text(
              "___________________________________\n\nNote : If you want to share or rename the files, \n📂       Go to the path,\n📁       Device Storage(File Manager) / Encrypto\n📁       Please! Share the Files As Document.\n\n                                Mode : => ${title} ✨",
              style: TextStyle(color: Colors.white, fontSize: 11.4.sp),textScaleFactor: 1.0
            ),
          ),
          ),
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            child: FileManager(
              controller: controller,
              builder: (context, snapshot) {
                final List<FileSystemEntity> entities = snapshot;
                return ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    FileSystemEntity entity = entities[index];
                    return Card(
                      color: Color.fromARGB(255, 61, 59, 59),
                      child: ListTile(
                        leading: FileManager.isFile(entity)
                            ? 
                               ( (controller.getCurrentPath.toString().compareTo('/storage/emulated/0/Encrypto/Decrypted_Files') == 0) ? Image.asset('assets/images/dec_icon.png',scale: 6.2,):Image.asset('assets/images/enc_icon.png',scale: 11.5,)) 
                              
                            : Icon(Icons.folder, color: Colors.blue, size: 40),
                            
                        title: Text(
                          FileManager.basename(entity, true),
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: subtitle(entity),
                        onLongPress: () async{
                          if (FileManager.isFile(entity))
                          await createFolder1(context, entity);
                          else {
                            Fluttertoast.showToast(
                                msg: "Please! Long Pressed on the File.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16);
                          }
                        },
                       
                        onTap: () async {
                          if (FileManager.isDirectory(entity)) {
                            // open the folder

                            controller.openDirectory(entity);

                            // delete a folder
                            // await entity.delete(recursive: true);

                            // rename a folder
                            // await entity.rename("newPath");

                            // Check weather folder exists
                            // entity.exists();

                            // get date of file
                            // DateTime date = (await entity.stat()).modified;
                          } else {
                            // delete a file
                            // await entity.delete();
                           // print(controller.getCurrentPath);
                           int s=int.parse(ver??'');
                           
                            if(s>=33){
                             try{
                            if (controller.getCurrentPath.toString().compareTo(
                                    '/storage/emulated/0/Encrypto/Decrypted_Files') ==
                                0) {
                             // OpenFile.open(entity.path.toString());//To open the file
                              Fluttertoast.showToast(
                                msg: "Please! Go to the path\nDevice storage / Encrypto / Decrypted_Files.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 14);
                            } else if (controller.getCurrentPath
                                    .toString()
                                    .compareTo(
                                        '/storage/emulated/0/Encrypto/Encrypted_Files') ==
                                0) {
                                openLoad(context, entity);  
                              
                            }
                           }catch(e)
                           {
                            print(e);
                           }



                            }
                            else{
                              try{
                            if (controller.getCurrentPath.toString().compareTo(
                                    '/storage/emulated/0/Encrypto/Decrypted_Files') ==
                                0) {
                              OpenFile.open(entity.path.toString());//To open the file
                              
                            } else if (controller.getCurrentPath
                                    .toString()
                                    .compareTo(
                                        '/storage/emulated/0/Encrypto/Encrypted_Files') ==
                                0) {
                                openLoad(context, entity);  
                              
                            }
                           }catch(e)
                           {
                            print(e);
                           }
                           
                            // rename a file
                            // await entity.rename("newPath");

                            // Check weather file exists
                            // entity.exists();

                            // get date of file
                            // DateTime date = (await entity.stat()).modified;

                            // get the size of the file
                            // int size = (await entity.stat()).size;
                            }
                        }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              "${FileManager.formatBytes(size)}",
              style: TextStyle(color: Colors.white),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
            style: TextStyle(color: Colors.white),
          );
        } else {
          return Text("");
        }
      },
    );
  }

  selectStorage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageList
                        .map((e) => ListTile(
                              title: Text(
                                "${FileManager.basename(e)}",
                              ),
                              onTap: () {
                                controller.openDirectory(e);
                                Navigator.pop(context);
                              },
                            ))
                        .toList()),
              );
            }
            return Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          color: Color.fromARGB(255, 50, 50, 50),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text(
                    "Sort By",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                   
                  }),
              ListTile(
                  title: Text(
                    "Name",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Size", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("Date", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text("type", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  createFolder1(BuildContext context, FileSystemEntity entity1) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          //backgroundColor: Colors.grey,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 60,
            color: Color.fromARGB(255, 50, 50, 50),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Do you want to delete the file',
                  style: TextStyle(color: Colors.white, fontSize: 17.2),
                ),
                SizedBox(
                  height: 8.4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            EasyLoading.show(status: 'Deleting the file...');
                            await entity1.delete();
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: "File Deleted Successfully.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16);
                          } catch (e) {
                             EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: "File Deleted Unsuccessfully.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16);
                          }

                         Navigator.pop(context);
                        controller.goToParentDirectory();
                        },
                        child: Text('Yes'),
                      ),
                    ),
                    SizedBox(
                  width: 8.4,
                ),
                    ElevatedButton(
                      onPressed: () async {
                        print("create ..");
                        Navigator.pop(context);
                       // await createFolder(context, entity1);
                        // controller.goToParentDirectory();
                      },
                      child: Text('No'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  openLoad(BuildContext context, FileSystemEntity entity1) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          //backgroundColor: Colors.grey,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 50,
            color: Color.fromARGB(255, 50, 50, 50),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose the option',
                  style: TextStyle(color: Colors.white, fontSize: 17.2),
                ),
                SizedBox(
                  height: 8.4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                           int v=int.parse(ver??'');
                           if(v>=33){
                            Fluttertoast.showToast(
                                msg: "Please! Go to the path\nDevice storage / Encrypto / Encrypted_Files.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 14);
                                Navigator.pop(context);
                           }
                           else{
                          OpenFile.open(entity1.path.toString());
                          Navigator.pop(context);
                           }
                          } catch (e) {
                            print(e);
                          }
                        
                         
                        },
                        child: Text('Open'),
                      ),
                    ),
                    SizedBox(width: 8,),
                    ElevatedButton(
                      onPressed: () async {
                        print("create ..");

                        file_path = entity1.path.toString();
                        filename = FileManager.basename(entity1, true);
                        setFile(filename);
                              check_file =
                                  "File ($file_name_toast) has Loaded.";
                             
                              result = null;
                              await controller.goToParentDirectory();
                                 Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => Password_Gen())));
                                       Fluttertoast.showToast(
                                  msg: "File Is Loaded.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16);
                                 
                        
                       // await createFolder(context, entity1);
                        // controller.goToParentDirectory();
                      },
                      child: Text('Load'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
