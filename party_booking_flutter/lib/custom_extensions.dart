import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

//
//import 'dart:io';
//
//extension FileExtention on FileSystemEntity{
//  String get name {
//    return this?.path?.split("/")?.last;
//  }
//}
extension FileExtension on File{

  Future<String> getFileExtension() async {
    if(await this.exists()){
      //return file with file extension
      return path.basename(this.path);
    }else{
      return null;
    }
  }
}

extension CustomExtension on int {

  String toPrice() {
    final currencyFormat =
    new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
    return currencyFormat.format(this);
  }
}