import 'dart:async';
import 'dart:io';
import 'package:bazinodriver/Controller/RequestController.dart';
import 'package:bazinodriver/Controller/SocketController.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'package:bazinodriver/View/BottomNavHome.dart';
import 'package:gps_connectivity/gps_connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';

import 'Model/RequestModel.dart';
import 'View/ApppBar.dart';
import 'View/ApppBarHome.dart';
import 'View/Loading.dart';
import 'View/MsgBox.dart';
import 'View/MyDrawer.dart';
import 'package:permission_handler/permission_handler.dart';
final LocalStorage storage = new LocalStorage('app');
class RequestScreen extends StatelessWidget {
  late StreamSubscription subscription;
  int _eventKey = 0;
  late DateTime currentBackPressTime;
  late Timer timer=Timer.periodic(Duration(seconds: 15), (Timer t) => print("strat"));

  @override
  Widget build(BuildContext context) {
    print(UserRefHelper.toString()+"aaaa");
    RequestController requestController = Get.put(RequestController());
    SocketController socketController = Get.put(SocketController());
    // Future<int> res=requestController.setRequest();
    // res.then((int value) {
    //   if(value!=1){
    //     Get.defaultDialog(
    //         title:"خطا در دریافت اطلاعات" ,
    //         titleStyle: TextStyle(fontFamily: 'yekan',fontSize: 16,),
    //         titlePadding:EdgeInsets.fromLTRB(0, 10, 0, 10),
    //         content: Container(
    //             width: Get.width,
    //             child:Column(
    //               children: [
    //                 Container(
    //                     margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
    //                     child:Text(
    //                       "مجددا تلاش کنید",
    //                       style: TextStyle(color: Colors.black87,  fontFamily: 'yekan'),
    //                       textDirection: TextDirection.rtl,
    //                     )
    //
    //                 ),
    //                 Container(
    //                     margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
    //                     decoration: BoxDecoration(
    //                         color: BaseColor,
    //                         borderRadius: BorderRadius.all(Radius.circular(10)),
    //                         border: Border.all(color: Colors.green,)
    //                     ),
    //                     child:TextButton(
    //                         onPressed: () {
    //                           Get.back();
    //                           requestController.setRequest();
    //                         },
    //                         child: Container(
    //
    //                           alignment: Alignment.center,
    //                           child: Text(
    //                             "تلاش مجدد",
    //                             style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.bold,
    //                                 fontFamily: 'yekan'),
    //                           ),
    //                         ))
    //
    //                 ),
    //               ],
    //             ))
    //     );
    //   }
    // },
    // );
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }
    timer.cancel();
    if(StartTimer==0){
      StartTimer=1;
      timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getDriverLoc(socketController,requestController,UserRef));
    }


    subscription = GpsConnectivity().onGpsConnectivityChanged.listen((bool result) {
      requestController.gps.value=result;
    });

    return Scaffold(
        endDrawer:MyDrawer(),
        // backgroundColor: Colors.white,
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text("جهت خروج از برنامه یک مرتبه دیگر گزینه بازگشت را انتخاب کنید",
                style: TextStyle(color: Colors.white, fontFamily: "yekan")),
          ),
          child: Container(
              child: Column(
                children: [
                  ApppBarHome(requestController,socketController,title: "ثبت نام", back: "/ProfileScreen"),
                  // Container(
                  //   child: InkWell(
                  //       onTap: (){
                  //         // socketController.socket.emit("NEWREC","NEWREC");
                  //         socketController.Notify("test","body");
                  //       },
                  //       child: Text("AAA")),
                  // ),
                  Expanded(
                        flex: 1,
                        child:
                        Obx((){
                          requestController.gps.value==true?print("ok"):print("no");
                          return   Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
                            // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                            child:
                            requestController.active.value==false?
                            Center(
                                child:Text("جهت مشاهده درخواست ها وضعیت خود را فعال کنید",
                                  style: TextStyle(
                                      color: Colors.redAccent, fontFamily: "iransans",fontSize: 14),textDirection: TextDirection.rtl,)
                            ):
                            requestController.geted.value==1?Center(child: CircularProgressIndicator(color: Colors.black87,))
                            :requestController.request.isEmpty?
                            Container(
                                child:
                                requestController.Accepted.value==1?
                                Center(
                                    child:Text("هیچ درخواستی یافت نشد",
                                    style: TextStyle(
                                    color: Colors.black87, fontFamily: "iransans",fontSize: 14),textDirection: TextDirection.rtl,)
                                )
                                : Center(
                                child:
                                Text("تا پیدا شدن درخواست جدید منتظر بمانید...",
                                style: TextStyle(
                                    color: Colors.black87, fontFamily: "iransans",fontSize: 14),textDirection: TextDirection.rtl)
                                )
                              ):ListView.builder(
                              itemCount:
                              requestController.request.length,
                              itemBuilder: (context, position) {
                                if(requestController.Accepted.value==1){
                                  return genItemAccepted(
                                      requestController.request[position],
                                      position,
                                      socketController);
                                }
                                else{
                                  return genItem(
                                      requestController.request[position], position, socketController,requestController,UserRef);
                                }
                              },
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            ),
                          );
                        })
                    )

                ],
              ),
            ),
        )

    ,

        bottomNavigationBar: BottomNavHome(requestController),

      );
  }

  void getDriverLoc(SocketController socketController,RequestController requestController,int userref) async {
    // _eventKey++;
    print("1111");
    if(requestController.active.value && requestController.connection.value && requestController.gps.value){
      var location = Location();
      try {
        print("2222");
        var currentLocation = await location.getLocation();
        socketController.socket.emit("driver_location",{'DriverRef': userref.toString(),'lati': currentLocation.latitude.toString(),'longi': currentLocation.longitude.toString(), 'key': ApiKeySocket});
      } catch (e) {
        print(e.toString());
      }
    }

  }
  InkWell genItem(RequestModel request, int position,SocketController socketController,RequestController requestController,int UserRef) {
    return InkWell(
      // splashColor: Colors.white,
      onTap: () {
        print("QQQQQ");
        // RequestRef=request.ID;
        // Get.toNamed("/DetailScreen");
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        elevation: 4,
        child: Row(
          children: [

            Expanded(
                child: Container(
                  height: 150,
                  // alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex:3,
                          child: Row(
                            children: [
                              Expanded(
                                flex:1,
                                  child:Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    // color: Colors.cyan,
                                    child: Text(request.Date,
                                        style: TextStyle(
                                            color: Colors.black87, fontFamily: "iransans",fontSize: 14)),
                                  )
                              ),
                              Expanded(
                                flex:1,
                                  child:Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    // color: Colors.cyan,
                                    child: Text(request.Price+" تومان",
                                      textDirection:TextDirection.rtl,
                                        style: TextStyle(
                                            color: Colors.black, fontFamily: "iransans",fontSize: 18,)),
                                  )
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex:2,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 15, 10),
                            alignment: Alignment.centerRight,
                            child: Text(request.Address,
                                textDirection:TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.black87, fontFamily: "yekan")),
                          ),
                        ),
                       Expanded(
                          flex:2,
                          child: Obx((){
                            return InkWell(
                              onTap: (){
                                print("THISSSS");
                                print(request.ID);
                                request.getedd.value=1;
                                Future<int> res=requestController.acceptRequest(request.ID);
                                res.then((int value) {
                                  if(value!=1){
                                    print("CANT GET");
                                    request.getedd.value=0;
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
                                                      requestController.msg.value,
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
                                  }
                                  else{
                                    requestController.tabid.value=2;
                                    Future<int> res=requestController.setRequest(1);
                                    res.then((int value) {
                                      if(value==1){ // success
                                        print("accept_request "+request.ID.toString());
                                        socketController.socket.emit("accept_request",{'DriverRef': UserRef.toString(),'OrderRef': request.ID.toString(), 'key': ApiKeySocket});
                                      }
                                      else{
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
                                                              requestController.setRequest(1);
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
                                    });
                                    request.getedd.value=0;
                                  }
                                },
                                );
                                // RequestRef=request.ID;
                                // Get.toNamed("/DetailScreen",arguments: [socketController]);
                              },
                              child: Container(
                                alignment:Alignment.center,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                  color: BaseColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),

                                ),
                                child: request.getedd.value==0?Text("قبول درخواست",
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: "yekan"))
                                    :CircularProgressIndicator(color: Colors.white),
                              ),
                            );
                          }),
                        ),
                      ]),
                ),
                flex: 6),
          ],
        ),
      ),
    );
  }
  InkWell genItemAccepted(RequestModel request, int position,SocketController socketController) {
    return InkWell(
      // splashColor: Colors.white,
      onTap: () {
        print("QQQQQ");
        // RequestRef=request.ID;
        // Get.toNamed("/DetailScreen");
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        elevation: 4,
        child: Row(
          children: [

            Expanded(
                child: Container(
                  height: 150,
                  // alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex:3,
                          child: Row(
                            children: [
                              Expanded(
                                  flex:1,
                                  child:Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    // color: Colors.cyan,
                                    child: Text(request.Date,
                                        style: TextStyle(
                                            color: Colors.black87, fontFamily: "iransans",fontSize: 14)),
                                  )
                              ),
                              Expanded(
                                  flex:1,
                                  child:Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    // color: Colors.cyan,
                                    child: Text(request.Price+" تومان",
                                        textDirection:TextDirection.rtl,
                                        style: TextStyle(
                                          color: Colors.black, fontFamily: "iransans",fontSize: 18,)),
                                  )
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex:2,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 15, 10),
                            alignment: Alignment.centerRight,
                            child: Text(request.Address,
                                textDirection:TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.black87, fontFamily: "yekan")),
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: InkWell(
                            onTap: (){
                              // print("Accepted");
                              // print(request.ID);
                              RequestRef=request.ID;
                              Get.toNamed("/DetailScreen",arguments: [socketController]);
                            },
                            child: Container(


                              alignment:Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(Radius.circular(10)),

                              ),
                              child: Text("مشاهده جزئیات",
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: "yekan")),
                            ),
                          ),
                        ),
                      ]),
                ),
                flex: 6),
          ],
        ),
      ),
    );
  }

}
