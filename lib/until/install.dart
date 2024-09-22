import 'dart:io';

import 'package:flutter/services.dart';
import 'package:process_run/shell.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
class InitBeforeLaunch{
  platformInit(){
    if(Platform.isMacOS){
      macosLinuxInit();
    }else if(Platform.isWindows){
      windowsInit();
    }else if(Platform.isLinux){
      macosLinuxInit();
    }
  }
  macosLinuxInit() async {
    try {
      var bytesBin1 = await rootBundle.load("assets/bin/ostrich-net");
      var bytesBin2 = await rootBundle.load("assets/bin/main.json");
      // var bytesJson = await rootBundle.load("assets/data/tun_auto.json");
      Map<String, String> envVars = Platform.environment;
      var home = envVars['HOME'].toString();
      //没有文件夹则创建文件夹
      Directory dir = Directory(home+"/.ostrichConfig");
      await dir.create(recursive: true);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("configDir", dir.path);
      //写入ostrich
      await  File(dir.path+"/ostrich-net").writeAsBytes(bytesBin1.buffer.asUint8List(bytesBin1.offsetInBytes,bytesBin1.lengthInBytes));
      await  File(dir.path+"/main.json").writeAsBytes(bytesBin2.buffer.asUint8List(bytesBin2.offsetInBytes,bytesBin2.lengthInBytes));
      //写入geo.mmdb
      // await  File(dir.path+"/geo.mmdb").writeAsBytes(bytesGeo.buffer.asUint8List(bytesGeo.offsetInBytes,bytesGeo.lengthInBytes));
      //写入site.dat
      // await  File(dir.path+"/site.dat").writeAsBytes(bytesSite.buffer.asUint8List(bytesSite.offsetInBytes,bytesSite.lengthInBytes));
      //写入tun_auto.json
      // await  File(tempDir+"/tun_auto.json").writeAsBytes(bytesJson.buffer.asUint8List(bytesJson.offsetInBytes,bytesJson.lengthInBytes));
      var shell = Shell();
      shell.run(
          '''
      chmod +x ${dir.path+"/ostrich-net"}
      '''
      ).then((value) => {
        print(value[0].stdout),
        print(value[0].exitCode),
        print(value[0].stderr),
      }).onError((error, stackTrace) => {
        print(error)
      });

    } catch (e) {
      print(e);
    }

  }

  windowsInit() async {
    try {
      var bytesBin = await rootBundle.load("assets/bin/apple/ostrich");
      var bytesGeo = await rootBundle.load("assets/data/geo.mmdb");
      var bytesSite = await rootBundle.load("assets/data/site.dat");
      var bytesJson = await rootBundle.load("assets/data/tun_auto.json");
      Map<String, String> envVars = Platform.environment;
      var home = envVars['UserProfile'].toString();
      //没有文件夹则创建文件夹
      Directory dir = Directory(home+"/.ostrichConfig");
      await dir.create(recursive: true);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("configDir", dir.path);
      //写入ostrich
      await  File(dir.path+"/ostrich").writeAsBytes(bytesBin.buffer.asUint8List(bytesBin.offsetInBytes,bytesBin.lengthInBytes));
      //写入geo.mmdb
      await  File(dir.path+"/geo.mmdb").writeAsBytes(bytesGeo.buffer.asUint8List(bytesGeo.offsetInBytes,bytesGeo.lengthInBytes));
      //写入site.dat
      await  File(dir.path+"/site.dat").writeAsBytes(bytesSite.buffer.asUint8List(bytesSite.offsetInBytes,bytesSite.lengthInBytes));
      //写入tun_auto.json
      // await  File(tempDir+"/tun_auto.json").writeAsBytes(bytesJson.buffer.asUint8List(bytesJson.offsetInBytes,bytesJson.lengthInBytes));
      //todo
      var shell = Shell();
      shell.run(
          '''
      chmod +x ${dir.path+"/ostrich"}
      '''
      ).then((value) => {
        print(value[0].stdout),
        print(value[0].exitCode),
        print(value[0].stderr),
      }).onError((error, stackTrace) => {
        print(error)
      });

    } catch (e) {
      print(e);
    }
  }

}