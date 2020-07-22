import 'dart:io';

import 'package:path/path.dart' as path;

//
//import 'dart:io';
//
//extension FileExtention on FileSystemEntity{
//  String get name {
//    return this?.path?.split("/")?.last;
//  }
//}
class FileExtension {
  static Future<String> getFileNameWithExtension(File file)async{

    if(await file.exists()){
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return path.basename(file.path);
    }else{
      return null;
    }
  }

}