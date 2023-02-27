import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../Model/DetailModel.dart';
import '../Model/RequestModel.dart';

class RequestController extends GetxController {
  // RxBool loading = true.obs;
  RxBool gps=false.obs;
  RxBool connection=false.obs;
  RxBool active=false.obs;

  RxList <RequestModel> request=<RequestModel>[].obs;
  RxInt geted=0.obs;
  RxInt getedDetail=0.obs;
  RxInt tabid=1.obs;
  RxString msg="".obs;

  RxInt ID=0.obs;
  RxString Price="".obs;
  RxString Weight="".obs;
  RxString Address="".obs;
  RxString Date="".obs;
  RxDouble UserLat=0.0.obs;
  RxDouble UserLong=0.0.obs;

  RxDouble CurrentLat=0.0.obs;
  RxDouble CurrentLong=0.0.obs;


  RxString UserMobile="".obs;
  RxList <DetailModel> detail=<DetailModel>[].obs;
  RxInt Accepted=0.obs;
  RxInt getedCancel=0.obs;
  final LocalStorage storage = new LocalStorage('app');
  Future<int> setRequest(int accepted) async {
    request.clear();
    Accepted.value=accepted;
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }
    print(UserRef.toString()+"aaaa");
    geted.value=1;
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'getRequests', 'key': ApiKey,'driver_ref': UserRef.toString(),'accepted': accepted.toString()}).timeout(const Duration(seconds: 5),
        onTimeout: () {
          geted.value=3;
          msg.value="خطا در دریافت اطلاعات";
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 408); // Request Timeout response status code
        },);
      if (response.statusCode == 200) {
        print(response.body);
        var jsons = convert.jsonDecode(response.body);
        var data=jsons["data"];
        var ok=jsons["ok"];
        if(ok==1){
          Credit=jsons["credit"];
          geted.value=2;
          if(data==null){
            print("ISNULL");
          }
          else{
            data.forEach((element) {
              RequestModel cModel=new RequestModel(element["ID"],element["Weight"],element["Price"],element["Date"],element["Address"]);
              request.add(cModel);
            });
          }

          return 1;
        }
        else{
          geted.value=3;
          msg.value=jsons["msg"];
          return 0;
        }
        // print(data);

        // print(category.length);

      } else {
        geted.value=3;
        msg.value="خطا در دریافت اطلاعات";
        return 0;
      }
    }
    else{
      geted.value=4;
      msg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }

  Future<int> getDetail() async {
    detail.clear();
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }
    getedDetail.value=1;
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'getDetail', 'key': ApiKey, 'driver_ref': UserRef.toString(), 'request_ref': RequestRef.toString()}).timeout(const Duration(seconds: 5),
        onTimeout: () {
          getedDetail.value=3;
          msg.value="خطا در دریافت اطلاعات";
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 408); // Request Timeout response status code
        },);
      if (response.statusCode == 200) {
        print(response.body);
        var jsons = convert.jsonDecode(response.body);
        print(jsons.toString());
        var ok=jsons["ok"];
        if(ok==1){
          var data=jsons["data"];
          getedDetail.value=2;
          ID.value=jsons["ID"];
          Price.value=jsons["Price"];
          Weight.value=jsons["Weight"];
          Address.value=jsons["Address"];
          Date.value=jsons["Date"];
          UserLat.value=jsons["UserLat"];
          UserLong.value=jsons["UserLong"];
          UserMobile.value=jsons["UserMobile"];
          data.forEach((element) {
            DetailModel dModel=new DetailModel(element["ID"],element["Name"],element["Price"],element["Amount"],element["Sum"]);
            detail.add(dModel);
          });
          return 1;
        }
        else{
          getedDetail.value=3;
          msg.value=jsons["msg"];
          return 0;
        }
        // print(data);

        // print(category.length);

      } else {
        getedDetail.value=3;
        msg.value="خطا در دریافت اطلاعات";
        return 0;
      }
    }
    else{
      getedDetail.value=4;
      msg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }
  Future<int> acceptRequest(int requestRef) async {
    // request.clear();
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'acceptRequest', 'key': ApiKey,'driver_ref': UserRef.toString(),'requestRef': requestRef.toString()}).timeout(const Duration(seconds: 5),
        onTimeout: () {
          msg.value="خطا در دریافت اطلاعات";
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 408); // Request Timeout response status code
        },);
      if (response.statusCode == 200) {
        print(response.body);
        var jsons = convert.jsonDecode(response.body);
        var ok=jsons["ok"];
        if(ok==1){
          return 1;
        }
        else{
          msg.value=jsons["msg"];
          return 0;
        }
        // print(data);

        // print(category.length);

      } else {
        msg.value="خطا در دریافت اطلاعات";
        return 0;
      }
    }
    else{
      msg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }
  Future<int> cancel_request_driver(int requestRef) async {
    // request.clear();
    getedCancel.value=1;
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'cancel_request_driver', 'key': ApiKey,'driver_ref': UserRef.toString(),'requestRef': requestRef.toString()}).timeout(const Duration(seconds: 5),
        onTimeout: () {
          msg.value="خطا در دریافت اطلاعات";
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 408); // Request Timeout response status code
        },);
      if (response.statusCode == 200) {
        print(response.body);
        var jsons = convert.jsonDecode(response.body);
        var ok=jsons["ok"];
        if(ok==1){
          getedCancel.value=0;
          return 1;

        }
        else{
          getedCancel.value=0;
          msg.value=jsons["msg"];
          return 0;
        }
        // print(data);

        // print(category.length);

      } else {
        getedCancel.value=0;
        msg.value="خطا در دریافت اطلاعات";
        return 0;
      }
    }
    else{
      getedCancel.value=0;
      msg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }  Future<int> complete_request(int requestRef,String pay_to_user) async {
    // request.clear();
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'complete_request_driver', 'key': ApiKey,'driver_ref': UserRef.toString(),'pay_to_user': pay_to_user.toString(),'requestRef': requestRef.toString()}).timeout(const Duration(seconds: 5),
        onTimeout: () {
          msg.value="خطا در دریافت اطلاعات";
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 408); // Request Timeout response status code
        },);
      if (response.statusCode == 200) {
        print(response.body);
        var jsons = convert.jsonDecode(response.body);
        var ok=jsons["ok"];
        if(ok==1){
          return 1;
        }
        else{
          msg.value=jsons["msg"];
          return 0;
        }
        // print(data);

        // print(category.length);

      } else {
        msg.value="خطا در دریافت اطلاعات";
        return 0;
      }
    }
    else{
      msg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }
}
