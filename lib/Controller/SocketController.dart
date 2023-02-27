import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Model/RequestModel.dart';
import 'RequestController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class SocketController extends GetxController {
  RxInt geted=0.obs;
  RxString msg="".obs;
  RxString content="".obs;
  RxBool socketConnect=false.obs;
  late IO.Socket socket;
  final LocalStorage storage = new LocalStorage('app');
  late Timer timer;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  RequestController requestController = Get.put(RequestController());
  onInit() {
    flutterLocalNotificationsPlugin=new FlutterLocalNotificationsPlugin();
    var android=AndroidInitializationSettings("@mipmap/ic_launcher");
    var IOS=IOSInitializationSettings();
    var initSetting=InitializationSettings(android: android,iOS: IOS);
    flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      print(payload);
    });
  }
  void Notify(String title,String body) async {
    var myandroid=AndroidNotificationDetails("mybazinodriver", "nazinodriver",priority:Priority.max,importance: Importance.max);
    var myIOS=IOSNotificationDetails();
    var platform=new NotificationDetails(android: myandroid,iOS: myIOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,payload: "EHSANNN");
  }
  Future onSelectNotification(String payload) async {
    print("payload__ : "+payload);
    // await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //         id: 1,
    //         channelKey: "public_channel",
    //         title: title,
    //         body: body
    //     ));
  }
  void connect(){
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }
  // socket=IO.io("http://185.190.39.86:3000",<String,dynamic>{
   socket=IO.io("http://bazino-app.ir:3000",<String,dynamic>{
      "transports":["websocket"],
      "autoConnect":true,
    });
    if(!socket.connected){
      socket.connect();
      socket.on('connect', (_){
        print('connect:::1: ${socket.id}');
        socketConnect.value=true;
        print("DREF____"+UserRef.toString());
        socket.emit("driverref_socketid",{'DriverRef': UserRef.toString(), 'key': ApiKeySocket});
        Future<int> res=requestController.setRequest(0);
        res.then((int value) {
          if(value!=1){
            Get.defaultDialog(
                title:"خطا در دریافت اطلاعات" ,
                titleStyle: TextStyle(fontFamily: 'yekan',fontSize: 16,),
                titlePadding:EdgeInsets.fromLTRB(0, 10, 0, 10),
                content: Container(
                    width: Get.width,
                    child:Column(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                            child:Text(
                              "مجددا تلاش کنید",
                              style: TextStyle(color: Colors.black87,  fontFamily: 'yekan'),
                              textDirection: TextDirection.rtl,
                            )

                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            decoration: BoxDecoration(
                                color: BaseColor,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.green,)
                            ),
                            child:TextButton(
                                onPressed: () {
                                  Get.back();
                                  requestController.setRequest(0);
                                },
                                child: Container(

                                  alignment: Alignment.center,
                                  child: Text(
                                    "تلاش مجدد",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'yekan'),
                                  ),
                                ))

                        ),
                      ],
                    ))
            );
          }
        },
        );
      });
      socket.on('disconnect', (_){

        print('disconnect:::1: ${socket.id}');
        socketConnect.value=false;
        requestController.request.clear();
      });
      socket.on('reconnect', (_){

        // print('reconnect:::1: ${socket.id}');
      });

      socket.on('driverInfo', (data){
        print('driverInfo: ${data["name"]}');
        Get.offAllNamed("/DriverinfoScreen");
      });
      socket.on('cancel_request', (data){
        socket.dispose();
        print("gETED CANCELLLL");
        // Get.snackbar("..", "..",
        //     titleText: Text("درخواست با موفقیت لغو شد", textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontFamily: 'yekan'),),
        //     // messageText: Text("ثبت نام شما با موفقیت انجام شد", textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontFamily: 'yekan', fontSize: 16),),
        //     backgroundColor: Colors.black,
        //     icon: Icon(Icons.check_circle, color: Colors.green, textDirection: TextDirection.rtl,),
        //     duration: Duration(seconds: 5),
        //     //     snackPosition: SnackPosition.BOTTOM,
        //     overlayColor: Colors.grey.withOpacity(0.5),
        //     dismissDirection:
        //     DismissDirection.horizontal,
        //     overlayBlur: 1,
        //     colorText: Colors.white);
        Get.offAllNamed("/AddressScreen");

      });

      socket.on('cancel_request_user', (data){
        Notify("سفارش لغو شد", "درخواست شما توسط کاربر لغو شد");
        // socket.dispose();
        Get.defaultDialog(
            barrierDismissible: false,
            onWillPop: ()async{
              Get.back();
              Get.back();
              return false;
            },

            title:"سفارش لغو شد" ,
            titleStyle: TextStyle(fontFamily: 'yekan',fontSize: 16,),
            titlePadding:EdgeInsets.fromLTRB(0, 10, 0, 10),
            content: Container(
                width: Get.width,
                child:Column(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                        child:Text(
                          "سفارش توسط کاربر لغو شد",
                          style: TextStyle(color: Colors.black87,  fontFamily: 'yekan',fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        decoration: BoxDecoration(
                            color: BaseColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.green,)
                        ),
                        child:TextButton(
                            onPressed: () {
                              Get.back();
                              Get.back();
                            },
                            child: Container(

                              alignment: Alignment.center,
                              child: Text(
                                "قبول",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'yekan'),
                              ),
                            ))

                    ),
                  ],
                ))
        );
        // Get.offAllNamed("/AddressScreen");

      });
      socket.on('RemoveRequest', (data){
        int iiRemove=0;
        int needRemove1=99999;
        requestController.request.forEach((element) {
          print("ID IS "+element.ID.toString());
          if(element.ID==data["id"]){
            needRemove1=iiRemove;
            print(needRemove1.toString()+"__2__");
          }
          // requestController.request.remove(element);
          iiRemove++;
        });
        if(needRemove1!=99999){
          print(needRemove1.toString()+"__1__");
          requestController.request.remove(requestController.request[needRemove1]);
        }
      });
      socket.on('NewRequest', (data){
        if(TabIdGlob==1){
          var SearchSec=60000;
          if(data["SearchSec"]!=null){
            SearchSec=data["SearchSec"];
          }

          print("NEW_REQQQQQ______");
          RequestModel cModel=new RequestModel(data["id"],"",data["price"].toString(),data["date"],data["address"]);
          requestController.request.add(cModel);
          print(requestController.request.length);
          int ii=0;
          int needRemove=99999;
          requestController.request.forEach((element) {
            print("ID IS "+element.ID.toString());
            if(element.ID==data["id"]){
              // requestController.request.remove(element);
              needRemove=ii;
              print(needRemove.toString()+"__2__");
            }
            // requestController.request.remove(element);
            ii++;
          });
          if(needRemove!=99999){
            print(needRemove.toString()+"____");
            print("Bef Len"+requestController.request.length.toString());
            print("SearchSec IS "+SearchSec.toString()+" NOW");
            Future.delayed(Duration(milliseconds: SearchSec), () {
              print("SearchSec IS "+SearchSec.toString()+" NOW");
              requestController.request.remove(requestController.request[needRemove]);
            });
            print("After Len"+requestController.request.length.toString());
          }
        }


      });
    }

    print(socket.connected.toString());
    print("yesss");
}


}
