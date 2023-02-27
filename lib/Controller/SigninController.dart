import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SigninController extends GetxController {
  // RxBool loading = true.obs;
  RxInt code=0.obs;
  RxInt geted=0.obs;
  RxInt getedsignup=0.obs;
  RxInt showmsg=0.obs;
  RxString msg="".obs;
  RxString signmsg="".obs;
  late Timer _timer;
  RxInt start = 120.obs;
  final LocalStorage storage = new LocalStorage('app');
  sendsms(String Mobile) async {
    geted.value=1;
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'sendsms','mobile': Mobile, 'key': ApiKey}).timeout(const Duration(seconds: 15),
        onTimeout: () {
          geted.value=3;
          msg.value="خطا در دریافت اطلاعات";
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 408); // Request Timeout response status code
        },);
      if (response.statusCode == 200) {
        var jsons = convert.jsonDecode(response.body);
        print(jsons);
        if(jsons["ok"]==1){

          code.value=jsons["code"];
          geted.value=2;
          start.value = 120;
          showmsg.value=1;
          return 1;
        }
        else {
          Get.snackbar("..", "..",
              titleText: Text("خطا",textAlign: TextAlign.right,style: TextStyle(color:Colors.white,fontFamily: 'yekan'),),
              messageText: Text(jsons["msg"],textAlign: TextAlign.right,style: TextStyle(color:Colors.white,fontFamily: 'yekan',fontSize: 16),),
              backgroundColor:Colors.black,
              icon: Icon(Icons.error,color: Colors.red,textDirection: TextDirection.rtl,),
              duration: Duration(seconds: 3),
              // snackPosition: SnackPosition.BOTTOM,
              overlayColor: Colors.grey.withOpacity(0.5 ),
              dismissDirection: DismissDirection.horizontal,
              overlayBlur: 1,
              colorText: Colors.white);
          geted.value=3;
          print("ERR ok");
          return 0;
        }
      } else {
        geted.value=3;
        print("ERR statusCode");
        return 3;
      }
    }
    else{
      geted.value=4;
      msg.value="اینترنت شما وصل نیست";
    }
  }
  Future<int> signin(String mobile,String code) async {
    getedsignup.value=1;
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'signin','mobile': mobile,'code': code,'AppVersion': AppVersion, 'key': ApiKey}).timeout(const Duration(seconds: 4));;
      if (response.statusCode == 200) {
        var jsons = convert.jsonDecode(response.body);
        print(jsons);
        if(jsons["ok"]==1){
          getedsignup.value=2;
          signmsg.value=jsons["msg"];

          // int counter = (prefs.getInt('counter') ?? 0) + 1;
          storage.setItem('UserRef', jsons["UserRef"]);
          storage.setItem('FName', jsons["FName"].toString());
          storage.setItem('LName', jsons["LName"].toString());
          storage.setItem('Mobile', jsons["Mobile"].toString());
          return 1;
        }
        else {
          getedsignup.value=3;
          signmsg.value=jsons["msg"];
          print("ERR ok");
          return 0;
        }
      } else {
        getedsignup.value=3;
        signmsg.value="خطا در دریافت اطلاعات";
        print("ERR statusCode");
        return 0;
      }
    }
    else{
      geted.value=4;
      signmsg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }
  void startTimer() {
    start.value = 120;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          start.value=start.value-1;
        }
      },
    );
  }
}
