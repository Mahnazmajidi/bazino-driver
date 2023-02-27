import 'dart:async';
import 'dart:io';
import 'package:bazinodriver/Controller/RequestController.dart';
import 'package:bazinodriver/Controller/SocketController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'package:bazinodriver/View/BottomNavHome.dart';
import 'package:gps_connectivity/gps_connectivity.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Model/DetailModel.dart';
import 'Model/RequestModel.dart';
import 'View/ApppBar.dart';
import 'View/ApppBarHome.dart';
import 'View/Loading.dart';
import 'View/MsgBox.dart';
import 'View/MyDrawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart' as latLng;

final LocalStorage storage = new LocalStorage('app');
class DetailScreen extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  var _pay_to_user = "";
  late StreamSubscription subscription;
  late final MapController mapController=MapController();
  late Timer timer=Timer.periodic(Duration(seconds: 15), (Timer t) => print("strat"));
  @override
  Widget build(BuildContext context) {
    RxInt getedComplete=0.obs;
    RequestController requestController = Get.put(RequestController());
    timer.cancel();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getDriverLoc(requestController));
    var arg=Get.arguments;
    SocketController socketController=arg[0];
    Future<int> res=requestController.getDetail();
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
                              requestController.getDetail();
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
    int UserRef = storage.getItem('UserRef') ?? 0;
    if(UserRef==0){
      UserRef=UserRefHelper;
    }

    subscription = GpsConnectivity().onGpsConnectivityChanged.listen((bool result) {
      requestController.gps.value=result;
    });

   return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        endDrawer:MyDrawer(),
        // backgroundColor: Colors.white,
        body: Container(
            child: Column(
              children: [
                // ApppBarHome(requestController,socketController,title: "جزئیات درخواست", back: ""),
                Expanded(
                      flex: 1,
                      child:
                      Obx((){
                        return
                          // requestController.gps.value==true?Container():
                        requestController.getedDetail.value==1?Loading():
                        requestController.getedDetail.value==3 || requestController.getedDetail.value==4 ?MsgBox(title: "خطا در دریافت اطلاعات",content: requestController.msg.value,screen: "/DetailScreen",):
                        requestController.getedDetail.value==2?
                        Container(
                            color: Colors.blue,
                            // margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:FlutterMap(

                              mapController: mapController,
                              options: MapOptions(
                                  interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                                  center: latLng.LatLng(requestController.UserLat.value,requestController.UserLong.value),
                                  zoom: 15.0,
                                  maxZoom: 18
                              ),

                              layers: [

                                TileLayerOptions(
                                  // urlTemplate: "http://map.netnegar.ir/hot/{z}/{x}/{y}.png",
                                  urlTemplate: "http://mt0.google.com/vt/lyrs=m&hl=fa&x={x}&y={y}&z={z}",
                                  // subdomains: ['a', 'b', 'c'],
                                  attributionBuilder: (_) {
                                    return Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        // alignment: Alignment.bottomLeft,
                                        child:Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            Container(
                                                alignment: Alignment.topCenter,
                                                // margin: EdgeInsets.fromLTRB(0, 0, (Get.width/5)*4, 0),
                                                height: 60,
                                                child: InkWell(
                                                  onTap: (){
                                                    Get.back();
                                                  },
                                                  child: Row(

                                                    children: [
                                                       Container(
                                                         margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                         child: Card(
                                                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                              color: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(25.0))),
                                                              elevation: 6,
                                                              child: Container(

                                                                padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                                                child:  Icon(Icons.arrow_back,color: Colors.black87,),
                                                              )
                                                          ),
                                                       ),

                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          margin: EdgeInsets.fromLTRB(0, 0, 10,0),
                                                          child: Card(
                                                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                              color: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(12.0))),
                                                              elevation: 6,
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                                child:  Text(requestController.Address.value,style: TextStyle(fontFamily: 'yekan',fontSize: 14),textDirection: TextDirection.rtl,),
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                    ],

                                                  ),
                                                )
                                            ),
                                            Container(
                                              // color: Colors.black87,
                                              alignment: Alignment.topCenter,
                                              height: Get.height-350,
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 0, 10,0),
                                              height: 100,
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                children: [
                                                  Expanded(flex: 1,
                                                    child: InkWell(
                                                      onTap: (){
                                                        print("OKaa");
                                                        // mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng.LatLng(requestController.UserLat.value, requestController.UserLong.value), 14));
                                                        mapController.move(latLng.LatLng(requestController.UserLat.value, requestController.UserLong.value), 16);
                                                      },
                                                      child: Container(
                                                          margin: EdgeInsets.fromLTRB(0, 0, 0,5),
                                                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                          decoration: new BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.all( Radius.circular(30)),
                                                          ),
                                                          child: Icon(Icons.location_history,size: 28,color:Colors.blue)
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(flex: 1,
                                                    child: InkWell(
                                                      onTap: (){
                                                        mapController.move(latLng.LatLng(requestController.CurrentLat.value, requestController.CurrentLong.value), 16);
                                                      },
                                                      child: Container(
                                                          margin: EdgeInsets.fromLTRB(0, 5, 0,0),
                                                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                          decoration: new BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.all( Radius.circular(30)),
                                                          ),
                                                          child: Icon(Icons.my_location,size: 28,color:Colors.blue)
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 180,
                                              alignment: Alignment.bottomCenter,
                                              margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                              child: Card(
                                                semanticContainer: true,
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                // margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20.0))),
                                                elevation: 6,
                                                child: Container(

                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        margin: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                                        child: Row(
                                                          children: [
                                                          Expanded(
                                                          flex: 1,
                                                              child:InkWell(
                                                                onTap: (){
                                                                  if(requestController.UserMobile.value!="" && requestController.UserMobile.value!=null){
                                                                    print(requestController.UserMobile.value);
                                                                    _makePhoneCall(requestController.UserMobile.value);
                                                                  }
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: Container(
                                                                        alignment: Alignment.centerRight,
                                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                        child: Text("تماس با کاربر",style: TextStyle(fontFamily: 'yekan',fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black87),textDirection: TextDirection.rtl,),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                          child: Icon(Icons.call,color: BaseColor,)
                                                                        // Image(image: NetworkImage(Url + "/images/driver/test.jpg" +DriverImage),),
                                                                        // NetworkImage(Url + "/images/cat/" + category.Pic)
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                            VerticalDivider(color: Colors.black54),
                                                            Expanded(
                                                            flex: 1,
                                                            child:InkWell(
                                                              onTap: (){
                                                                Get.defaultDialog(
                                                                    title:"جزئیات بازیافت" ,
                                                                    titleStyle: TextStyle(fontFamily: 'yekan',fontSize: 16,),
                                                                    titlePadding:EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                    content: Container(
                                                                      color: Colors.transparent,
                                                                      height: Get.height-250,
                                                                      width: Get.width,
                                                                      child:
                                                                      ListView.builder(
                                                                        itemCount:
                                                                        requestController.detail.length,
                                                                        itemBuilder: (context, position) {
                                                                          return genItem(
                                                                              requestController.detail[position],
                                                                              position,requestController.detail.length);
                                                                        },
                                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                      ),
                                                                    )
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: Container(
                                                                      alignment: Alignment.centerRight,
                                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                      child: Text("جزئیات بازیافت",style: TextStyle(fontFamily: 'yekan',fontWeight: FontWeight.bold,fontSize: 15),textDirection: TextDirection.rtl,),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        margin: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                                        child: Icon(Icons.featured_play_list_outlined,color: BaseColor,)
                                                                      // Image(image: NetworkImage(Url + "/images/driver/test.jpg" +DriverImage),),
                                                                      // NetworkImage(Url + "/images/cat/" + category.Pic)
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ),


                                                          ],
                                                        ),
                                                      ),
                                                       Row(
                                                           children: [
                                                             Expanded(
                                                                 flex:1,
                                                               child:Container(
                                                                   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                   child:Divider(color: Colors.black54,)
                                                               )
                                                             ),
                                                             Expanded(
                                                                 flex:1,
                                                               child:Container(
                                                                   margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                                                   child:Divider(color: Colors.black54,)
                                                               )
                                                             ),
                                                           ],
                                                       )
                                                      ,
                                                      Container(

                                                        height: 50,
                                                        margin: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child:InkWell(
                                                                  onTap: (){
                                                                    Get.bottomSheet(
                                                                      Container(
                                                                          decoration: new BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: new BorderRadius.only(
                                                                                  topLeft: const Radius.circular(20.0),
                                                                                  topRight: const Radius.circular(20.0))),
                                                                          height: 200,
                                                                          child:Column(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap:(){
                                                                                  Get.defaultDialog(
                                                                                      title:"تکمیل سفارش" ,
                                                                                      titleStyle: TextStyle(fontFamily: 'yekan',fontSize: 16,),
                                                                                      titlePadding:EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                                      content: Form(
                                                                                        key: _formKey,
                                                                                        child: Container(
                                                                                            width: Get.width,
                                                                                            child:Column(
                                                                                              children: [
                                                                                                Container(
                                                                                                    margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                                                                                                    child:Text(
                                                                                                      "مبلغ پرداختی به کاربر را به (تومان) وارد کنید",
                                                                                                      style: TextStyle(color: Colors.black87,  fontFamily: 'yekan'),
                                                                                                      textDirection: TextDirection.rtl,
                                                                                                    )

                                                                                                ),
                                                                                                Container(
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                                                                  child: Directionality(
                                                                                                    textDirection: TextDirection.ltr,
                                                                                                    child: TextFormField(
                                                                                                      keyboardType: TextInputType.number,
                                                                                                      onSaved: (value) {
                                                                                                        _pay_to_user = value!;
                                                                                                      },
                                                                                                      validator: (value) {
                                                                                                        if (value == null) {
                                                                                                          return 'مبلغ پرداختی به کاربر را به تومان وارد کنید';
                                                                                                        }
                                                                                                        else if (!isNumeric(value)) {
                                                                                                          return 'مبلغ معتبر نیست';
                                                                                                        }
                                                                                                        else {
                                                                                                          return null;
                                                                                                        }
                                                                                                      },
                                                                                                      style:
                                                                                                      TextStyle(fontSize: 14, color: Colors.black),
                                                                                                      textAlign: TextAlign.left,
                                                                                                      decoration: InputDecoration(
                                                                                                        labelStyle: TextStyle(fontFamily: 'yekan'),
                                                                                                        alignLabelWithHint: true,
                                                                                                        hintTextDirection: TextDirection.rtl,
                                                                                                        filled: true,
                                                                                                        border: OutlineInputBorder(),
                                                                                                        enabledBorder: OutlineInputBorder(
                                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                                          borderSide: BorderSide.none,
                                                                                                        ),
                                                                                                        focusedBorder: OutlineInputBorder(
                                                                                                            borderRadius: BorderRadius.circular(
                                                                                                                10),
                                                                                                            borderSide: BorderSide(color: Colors.black54)),

                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.black12,
                                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),

                                                                                                    ),
                                                                                                    child:TextButton(
                                                                                                        onPressed: () {
                                                                                                          _formKey.currentState!.save();
                                                                                                          if(_pay_to_user==""){
                                                                                                            Get.snackbar("..", "..",
                                                                                                                titleText: Text("خطا",textAlign: TextAlign.right,style: TextStyle(color:Colors.white,fontFamily: 'yekan'),),
                                                                                                                messageText: Text("مبلغ پرداختی به کاربر وارد نشده است",textAlign: TextAlign.right,style: TextStyle(color:Colors.white,fontFamily: 'yekan',fontSize: 16),),
                                                                                                                backgroundColor:Colors.black,
                                                                                                                icon: Icon(Icons.error,color: Colors.red,textDirection: TextDirection.rtl,),
                                                                                                                duration: Duration(seconds: 3),
                                                                                                                //     snackPosition: SnackPosition.BOTTOM,
                                                                                                                overlayColor: Colors.grey.withOpacity(0.5 ),
                                                                                                                dismissDirection: DismissDirection.horizontal,
                                                                                                                overlayBlur: 1,
                                                                                                                colorText: Colors.white);
                                                                                                          }
                                                                                                          else{
                                                                                                            Get.back();
                                                                                                            if(getedComplete.value==0){
                                                                                                              getedComplete.value=1;
                                                                                                              Future<int> res=requestController.complete_request(RequestRef,_pay_to_user);
                                                                                                              res.then((int value) {
                                                                                                                if(value==1){
                                                                                                                  Get.defaultDialog(
                                                                                                                      title:"موفقیت آمیز" ,
                                                                                                                      titleStyle: TextStyle(fontFamily: 'yekan',fontSize: 16,),
                                                                                                                      titlePadding:EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                                                                      onWillPop: ()async{
                                                                                                                        Get.back();
                                                                                                                        Get.back();
                                                                                                                        Get.back();
                                                                                                                        return false;
                                                                                                                      },
                                                                                                                      barrierDismissible: false,
                                                                                                                      content: Container(
                                                                                                                          width: Get.width,
                                                                                                                          child:Column(
                                                                                                                            children: [
                                                                                                                              Container(
                                                                                                                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                                                                                                                                  child:Text(
                                                                                                                                    "سفارش با موفقیت تکمیل شد",
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
                                                                                                                  requestController.tabid.value=1;
                                                                                                                  getedComplete.value=0;
                                                                                                                  socketController.socket.emit("complete_request_driver",{'DriverRef': UserRef.toString(),'OrderRef': RequestRef.toString(), 'key': ApiKeySocket});
                                                                                                                }
                                                                                                                else{
                                                                                                                  print("CANT GET");
                                                                                                                  getedComplete.value=0;
                                                                                                                  Get.defaultDialog(
                                                                                                                      title:"خطا در تکمیل درخواست" ,
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
                                                                                                              },
                                                                                                              );
                                                                                                            }
                                                                                                          }


                                                                                                          // socketController.socket.emit("cancel_request_driver");                                                                                                        // DO CANCEL
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          child: getedComplete.value==1?
                                                                                                          CircularProgressIndicator(color: Colors.black,)
                                                                                                              :Text(
                                                                                                            "تکمیل سفارش",
                                                                                                            style: TextStyle(
                                                                                                                color: Colors.black,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                fontFamily: 'yekan'),
                                                                                                          ),
                                                                                                        ))

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
                                                                                                            "انصراف",
                                                                                                            style: TextStyle(
                                                                                                                color: Colors.white,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                fontFamily: 'yekan'),
                                                                                                          ),
                                                                                                        ))

                                                                                                ),
                                                                                              ],
                                                                                            )),
                                                                                      )
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                                                                                    alignment: Alignment.center,
                                                                                    child:Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text("تکمیل سفارش",style: TextStyle(fontFamily: 'yekan',fontWeight: FontWeight.bold,fontSize: 15,color: Colors.green),textDirection: TextDirection.rtl,),
                                                                                        Container(
                                                                                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                                            child: Icon(Icons.check_circle,color: Colors.green,))
                                                                                      ],
                                                                                    )
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                                  child: Divider(color: Colors.black54,)),
                                                                              InkWell(
                                                                                onTap:(){
                                                                                  Get.back();
                                                                                  Get.defaultDialog(
                                                                                      title:"از لغو سفارش اطمینان دارید؟" ,
                                                                                      titleStyle: TextStyle(fontFamily: 'yekan',fontSize: 16,),
                                                                                      titlePadding:EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                                      content: Container(
                                                                                          width: Get.width,
                                                                                          child:Column(
                                                                                            children: [
                                                                                              Container(
                                                                                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                                                                                                  child:Text(
                                                                                                    "با لغو سفارش شما امتیاز منفی دریافت می کنید",
                                                                                                    style: TextStyle(color: Colors.black87,  fontFamily: 'yekan',fontWeight: FontWeight.bold),
                                                                                                    textDirection: TextDirection.rtl,
                                                                                                  )

                                                                                              ),
                                                                                              Container(
                                                                                                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                                                                                  decoration: BoxDecoration(
                                                                                                      color: Colors.black12,
                                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),

                                                                                                  ),
                                                                                                  child:TextButton(
                                                                                                      onPressed: () {
                                                                                                        Get.back();
                                                                                                        if(requestController.getedCancel.value==0){
                                                                                                          requestController.getedCancel.value=1;
                                                                                                          Future<int> res=requestController.cancel_request_driver(RequestRef);
                                                                                                          res.then((int value) {
                                                                                                            if(value==1){
                                                                                                              requestController.tabid.value=1;
                                                                                                              requestController.getedCancel.value=0;
                                                                                                              socketController.socket.emit("cancel_request_driver",{'DriverRef': UserRef.toString(),'OrderRef': RequestRef.toString(), 'key': ApiKeySocket});
                                                                                                              Get.back();
                                                                                                            }
                                                                                                            else{
                                                                                                              print("CANT GET");
                                                                                                              requestController.getedCancel.value=0;
                                                                                                              Get.defaultDialog(
                                                                                                                  title:"خطا در لغو درخواست" ,
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
                                                                                                          },
                                                                                                          );
                                                                                                        }

                                                                                                        // socketController.socket.emit("cancel_request_driver");                                                                                                        // DO CANCEL
                                                                                                      },
                                                                                                      child: Container(

                                                                                                        alignment: Alignment.center,
                                                                                                        child: requestController.getedCancel.value==1?
                                                                                                        CircularProgressIndicator(color: Colors.black,)
                                                                                                            :Text(
                                                                                                          "لغو سفارش",
                                                                                                          style: TextStyle(
                                                                                                              color: Colors.black54,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                              fontFamily: 'yekan'),
                                                                                                        ),
                                                                                                      ))

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
                                                                                                          "انصراف",
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
                                                                                },
                                                                                child: Container(
                                                                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                                    alignment: Alignment.center,
                                                                                    child:Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text("لغو سفارش",style: TextStyle(fontFamily: 'yekan',fontWeight: FontWeight.bold,fontSize: 15,color: Colors.redAccent),textDirection: TextDirection.rtl,),
                                                                                        Container(
                                                                                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                                            child: Icon(Icons.clear,color: Colors.redAccent,))
                                                                                      ],
                                                                                    )
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                                  child: Divider(color: Colors.black54,)),
                                                                              InkWell(
                                                                                onTap:(){
                                                                                  Get.back();
                                                                                },
                                                                                child: Container(
                                                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                                                                    alignment: Alignment.center,
                                                                                    child:Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text("انصراف ",style: TextStyle(fontFamily: 'yekan',fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black87),textDirection: TextDirection.rtl,),
                                                                                        Container(
                                                                                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                                            child: Icon(Icons.backspace,color: Colors.black87,))
                                                                                      ],
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                      ),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(30.0),
                                                                      ),
                                                                      // barrierColor: Colors.red[50],
                                                                      isDismissible: true,
                                                                      enableDrag: false,

                                                                    );
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child: Container(
                                                                          alignment: Alignment.centerRight,
                                                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                          child: Text("عملیات",style: TextStyle(fontFamily: 'yekan',fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black87),textDirection: TextDirection.rtl,),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child: Container(
                                                                            alignment: Alignment.centerLeft,
                                                                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                            child: Icon(Icons.add_circle,color: Colors.redAccent,)
                                                                          // Image(image: NetworkImage(Url + "/images/driver/test.jpg" +DriverImage),),
                                                                          // NetworkImage(Url + "/images/cat/" + category.Pic)
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            ),
                                                            VerticalDivider(color: Colors.black54),
                                                            Expanded(
                                                                flex: 1,
                                                                child:InkWell(
                                                                  onTap: (){
                                                                    MapsLauncher.launchCoordinates(37.4220041, -122.0862462);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 4,
                                                                        child: Container(
                                                                          alignment: Alignment.centerRight,
                                                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                          child: Text("مسیریابی",style: TextStyle(fontFamily: 'yekan',fontWeight: FontWeight.bold,fontSize: 15,color:Colors.black87),textDirection: TextDirection.rtl,),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child: Container(
                                                                            alignment: Alignment.centerLeft,
                                                                            margin: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                                                            child: Icon(Icons.directions,color:Colors.blue)
                                                                          // Image(image: NetworkImage(Url + "/images/driver/test.jpg" +DriverImage),),
                                                                          // NetworkImage(Url + "/images/cat/" + category.Pic)
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            ),


                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),


                                          ],
                                        )
                                    );
                                  },
                                ),
                                MarkerLayerOptions(
                                  markers: [

                                    Marker(

                                      anchorPos: AnchorPos.align(AnchorAlign.top),
                                      // width: 30.0,
                                      // height: 30.0,
                                      point: latLng.LatLng(requestController.UserLat.value,requestController.UserLong.value),
                                      builder: (ctx) =>
                                          Container(
                                            child: Icon(Icons.location_history,color: Colors.blue,size: 48,),
                                          ),
                                    ),
                                    Marker(
                                      anchorPos: AnchorPos.align(AnchorAlign.top),
                                      // width: 30.0,
                                      // height: 30.0,
                                      point: latLng.LatLng(requestController.CurrentLat.value,requestController.CurrentLong.value),
                                      builder: (ctx) =>
                                          Container(
                                            child:  Icon(Icons.my_location,size: 28,color:Colors.blue),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ):Container();

                      })
                  )

              ],
            ),
          )

    ,

        // bottomNavigationBar: BottomNavHome(requestController),

      ),
    );
  }

  void getDriverLoc(RequestController requestController) async {
    // _eventKey++;
    print("--444--");
    if(requestController.active.value && requestController.connection.value && requestController.gps.value){
      var location = Location();
      try {
        print("33333");
        var currentLocation = await location.getLocation();
        requestController.CurrentLat.value=currentLocation.latitude!;
        requestController.CurrentLong.value=currentLocation.longitude!;
      } catch (e) {
        print(e.toString());
      }
    }

  }
  Container genItem(DetailModel detail, int position, int lenth) {
    double TopRadius = 0.0;
    double ButtomRadius = 0;
    var rowColor = Colors.white;
    var textColor = Colors.black;
    if ((position + 1) % 2 == 0) {
      rowColor = BackgroundColor;
    } else {
      rowColor = Colors.white;
    }

    if (position == 0) {
      textColor = Colors.white;
      TopRadius = 15.0;
      rowColor = BaseColor;
    }
    if (position + 1 == lenth) {
      textColor = Colors.white;
      ButtomRadius = 15.0;
      TopRadius = 0.0;
      rowColor = BaseColor;
    }

    return  Container(
      // splashColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            color: rowColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TopRadius),
                topRight: Radius.circular(TopRadius),
                bottomLeft: Radius.circular(ButtomRadius),
                bottomRight: Radius.circular(ButtomRadius))),
        child: Row(
          children: [
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(detail.Sum,
                      style: TextStyle(
                          color: textColor,
                          fontFamily: "yekan",
                          fontSize: 14)),
                  // alignment: Alignment.center,
                ),
                flex: 4),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(detail.Price,
                      style: TextStyle(
                          color: textColor,
                          fontFamily: "yekan",
                          fontSize: 14)),
                  // alignment: Alignment.center,
                ),
                flex: 4),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(detail.Amount,
                      style: TextStyle(
                          color: textColor,
                          fontFamily: "yekan",
                          fontSize: 14)),
                  // alignment: Alignment.center,
                ),
                flex: 3),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(detail.Name,
                      style: TextStyle(
                          color: textColor,
                          fontFamily: "yekan",
                          fontSize: 14)),
                  // alignment: Alignment.center,
                ),
                flex: 4),
          ],
        ),
      ),
    );
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}

// onTap: () async{
// var status = await Permission.photos.status;
// if (status.isGranted) {
// print("STATUS GENERATED");
// } else if (status.isDenied) {
// print("STATUS NOT GEN");
// } else {
// showDialog(
// context: context,
// builder: (BuildContext context) => CupertinoAlertDialog(
// title: Text('Camera Permission'),
// content: Text(
// 'This app needs camera access to take pictures for upload user profile photo'),
// actions: <Widget>[
// CupertinoDialogAction(
// child: Text('Deny'),
// onPressed: () => Navigator.of(context).pop(),
// ),
// CupertinoDialogAction(
// child: Text('Settings'),
// onPressed: () => openAppSettings(),
// ),
// ],
// ));
// }
