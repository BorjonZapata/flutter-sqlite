import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'pantallas/app.dart';

void main() {

  if(Platform.isWindows || Platform.isLinux || Platform.isMacOS || Platform.isAndroid){
    sqfliteFfiInit();
  } else{
    if(kIsWeb){
      databaseFactory = databaseFactoryFfiWeb;
    }
  }

  databaseFactory = databaseFactoryFfi;
  runApp(const App());
}

