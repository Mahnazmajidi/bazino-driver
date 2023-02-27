import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'package:bazinodriver/View/BottomNav.dart';
import 'View/ApppBar.dart';
import 'package:localstorage/localstorage.dart';

import 'View/MyDrawer.dart';

class ProfileScreen extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  // RxInt UserRef = 0.obs;
  final LocalStorage storage = new LocalStorage('app');
  @override
  Widget build(BuildContext context) {
    var arg = Get.arguments;
    // storage.setItem('UserRef', 1);
    // storage.deleteItem("UserRef");
    int UserRef = storage.getItem('UserRef') ?? 0;
    print(UserRef.toString()+"_____");
    return WillPopScope(
        onWillPop: () async {
          Get.offAndToNamed("/RequestScreen");
          return true;
        },
        child: Scaffold(
          endDrawer:MyDrawer(),
          backgroundColor: Colors.white,
          body: Container(
            child: Column(
              children: [
                ApppBar(
                  IsProfile:true,
                  title: UserRef==0?"ورود / ثبت نام":"اطلاعات حساب",
                  back: "/RequestScreen",
                ),
                UserRef != 0
                    ?
                Expanded(
                  flex: 1,
                  child:
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 30),
                          // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                          child: Card(
                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0))),
                            elevation: 20,
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                     Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                enabled: false,
                                                keyboardType: TextInputType.number,
                                                controller: TextEditingController(text: storage.getItem('FName') ?? 0),
                                                onSaved: (value) {
                                                  // _zayeatT =  double.parse(value!);
                                                },
                                                validator: (value) {
                                                  if (value == "") {
                                                    return null;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                    fontSize: 14, color: BaseColor),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontFamily: 'yekan'),
                                                  alignLabelWithHint: true,
                                                  hintTextDirection:
                                                  TextDirection.rtl,
                                                  filled: true,
                                                  border: OutlineInputBorder(),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: BorderSide(
                                                          color: BaseColor)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    "نام:",
                                                    style: TextStyle(
                                                        fontFamily: 'yekan'),
                                                    textDirection:
                                                    TextDirection.rtl,
                                                  )))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                enabled: false,
                                                keyboardType: TextInputType.number,
                                                controller: TextEditingController(text: storage.getItem('LName') ?? ""),
                                                onSaved: (value) {
                                                  // _zayeatT =  double.parse(value!);
                                                },
                                                validator: (value) {
                                                  if (value == "") {
                                                    return null;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                    fontSize: 14, color: BaseColor),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontFamily: 'yekan'),
                                                  alignLabelWithHint: true,
                                                  hintTextDirection:
                                                  TextDirection.rtl,
                                                  filled: true,
                                                  border: OutlineInputBorder(),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: BorderSide(
                                                          color: BaseColor)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Text("نام خانوادگی:",
                                                    style: TextStyle(fontFamily: 'yekan'), textDirection: TextDirection.rtl,
                                                  )))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                enabled: false,
                                                keyboardType: TextInputType.number,
                                                controller: TextEditingController(text: storage.getItem('Mobile') ?? ""),
                                                onSaved: (value) {
                                                  // _zayeatT =  double.parse(value!);
                                                },
                                                validator: (value) {
                                                  if (value == "") {
                                                    return null;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                    fontSize: 14, color: BaseColor),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontFamily: 'yekan'),
                                                  alignLabelWithHint: true,
                                                  hintTextDirection:
                                                  TextDirection.rtl,
                                                  filled: true,
                                                  border: OutlineInputBorder(),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: BorderSide(
                                                          color: BaseColor)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    "همراه:",
                                                    style: TextStyle(
                                                        fontFamily: 'yekan'),
                                                    textDirection:
                                                    TextDirection.rtl,
                                                  )))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                enabled: false,
                                                keyboardType: TextInputType.number,
                                                controller: TextEditingController(text: storage.getItem('Email') ?? ""),
                                                onSaved: (value) {
                                                  // _zayeatT =  double.parse(value!);
                                                },
                                                validator: (value) {
                                                  if (value == "") {
                                                    return null;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                    fontSize: 14, color: BaseColor),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontFamily: 'yekan'),
                                                  alignLabelWithHint: true,
                                                  hintTextDirection:
                                                  TextDirection.rtl,
                                                  filled: true,
                                                  border: OutlineInputBorder(),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      borderSide: BorderSide(
                                                          color: BaseColor)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    "ایمیل:",
                                                    style: TextStyle(
                                                        fontFamily: 'yekan'),
                                                    textDirection:
                                                    TextDirection.rtl,
                                                  )))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.fromLTRB(10, 50, 10, 30),
                                      child: Row(
                                        children:[
                                          Expanded(
                                            flex:1,
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: SecColor,
                                                ),
                                                onPressed: () {
                                                  // _formKey.currentState!.validate();
                                                  // _formKey.currentState!.save();
                                                  storage.deleteItem("UserRef");
                                                  Get.offAndToNamed("/LoginScreen");
                                                },
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "خروج از حساب",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'yekan'),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            flex:2,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: BaseColor,
                                                  ),
                                                  onPressed: () {
                                                    // _formKey.currentState!.validate();
                                                    // _formKey.currentState!.save();
                                                    Get.offAndToNamed("/RequestScreen");
                                                  },
                                                  child: Container(

                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "بازگشت",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'yekan'),
                                                    ),
                                                  )),
                                            ),
                                          )
                                        ]
                                        ,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        )

                )


                    :  Expanded(
                  flex: 1,
                  child: Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
                          // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                          child: Card(
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0))),
                            elevation: 4,
                            child: Column(
                              children: [
                                Container(
                                  margin:EdgeInsets.fromLTRB(0,50,0,0),
                                  child: Image(
                                    image: AssetImage('assets/images/profile.png'),
                                    width: 200,
                                    // fit: BoxFit.fill,
                                  ),
                                ),
                                arg!=null?Container(
                                  margin:EdgeInsets.fromLTRB(0,50,0,0),
                                  child: Text(arg[0],style: TextStyle(fontFamily: "yekan"),),
                                ):Container(),
                                Expanded(
                                  flex:1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.offAndToNamed("/LoginScreen");
                                          },
                                          child: Container(
                                            // color:BaseColor,
                                            margin: EdgeInsets.fromLTRB(40, 20, 40, 35),
                                            height: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: BaseColor,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                            child:Text("ورود", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'yekan'),),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.offAndToNamed("/SignupScreen");
                                          },
                                          child: Container(
                                            // color:BaseColor,
                                            margin: EdgeInsets.fromLTRB(40, 10, 40, 45),
                                            height: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                // color: ThirdColor,
                                                border: Border.all(
                                                  color: BaseColor,  // red as border color
                                                ),
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                            child:Text("ثبت نام", style: TextStyle(color: BaseColor, fontWeight: FontWeight.bold, fontFamily: 'yekan'),),
                                          ),
                                        ),
                                      ],

                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )

                )
              ],
            ),
            ),
            // bottomNavigationBar: BottomNav(),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: (){
            //     Get.offAndToNamed("/CategoryScreen");
            //   },
            //   child: Icon(Icons.home,color: Colors.white),
            //   backgroundColor: BaseColor,
            // ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
          ),
        );
  }

}
