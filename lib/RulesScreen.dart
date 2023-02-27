import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'package:bazinodriver/View/BottomNav.dart';
import 'package:localstorage/localstorage.dart';
import 'Controller/RulesController.dart';
import 'View/ApppBar.dart';
import 'View/Loading.dart';
import 'View/MsgBox.dart';
import 'View/MyDrawer.dart';
final LocalStorage storage = new LocalStorage('app');
class RulesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    RulesController rulesController = Get.put(RulesController());
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed("/RequestScreen");
        return false;
      },
      child: Obx((){
        return  Scaffold(
          endDrawer:MyDrawer(),
          // backgroundColor: Colors.white,
          body: Container(

            child: Column(
              children: [
                ApppBar(title: "قوانین", back: "/RequestScreen"),
                rulesController.geted.value==1?Loading():
                rulesController.geted.value==3?MsgBox(title: "خطا",content:rulesController.msg.value ,):
                rulesController.geted.value==4?MsgBox(type: "internet",):
                Expanded(
                  flex: 1,
                  child:   Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 25),

                    // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(20.0))),
                      elevation: 4,
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                            child: Image(
                              image: AssetImage('assets/images/rules.png'),
                              height: 180,
                              // fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin:EdgeInsets.fromLTRB(0,0,0,50),
                            padding:EdgeInsets.fromLTRB(15,0,15,0),
                            child:Text(rulesController.content.value,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'yekan',
                                )),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                Get.offAllNamed("/RequestScreen");
                              },
                              child: Container(
                                // color:BaseColor,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 45),
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: BaseColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child:Text("بازگشت", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'yekan'),),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ) ,

          bottomNavigationBar: BottomNav(),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Get.offAllNamed("/RequestScreen");
            },
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
            backgroundColor: BaseColor,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      })
     ,
    );
  }

}
