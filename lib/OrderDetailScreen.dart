import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'package:bazinodriver/View/BottomNav.dart';
import 'package:lottie/lottie.dart';
import 'Controller/OrderDetailController.dart';
import 'Model/OrderDetailModel.dart';
import 'View/ApppBar.dart';
import 'View/Loading.dart';
import 'View/MyDrawer.dart';

class OrderDetailScreen extends StatelessWidget {
  var _address = "";
  var _formKey = GlobalKey<FormState>();
  RxInt payType = 1.obs;

  @override
  Widget build(BuildContext context) {
    // basketGlob[5] = 2;
    // basketGlob[6] = 3;
    OrderDetailController orderdetailController = Get.put(OrderDetailController());
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        endDrawer:MyDrawer(),
        // backgroundColor: Colors.white,
        body: Obx(() {
          return Container(
            child: Column(
              children: [
                ApppBar(title: "جزئیات سفارش "+OrderRef.toString()),
                Expanded(
                  flex: 1,
                  child: orderdetailController.geted.value == 0
                      ? Loading()
                      : orderdetailController.geted.value == 2
                          ? Container(child: Text(orderdetailController.msg.value))
                          : Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
                                    // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                                    child: Card(
                                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      elevation: 4,
                                      child: ListView.builder(
                                        itemCount:
                                        orderdetailController.orderdetail.length,
                                        itemBuilder: (context, position) {
                                          return genItem(orderdetailController.orderdetail[position], position, orderdetailController.orderdetail.length,orderdetailController);
                                        },
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      ),
                                    ),
                                  )

                )
              ],
            ),
          );
        }),
        bottomNavigationBar: BottomNav(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Get.offAllNamed("/HomeScreen");
          },
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
          backgroundColor: BaseColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Container genItem(OrderDetailModel orderdetail, int position, int lenth,orderdetailController) {
    double TopRadius = 0.0;
    double ButtomRadius = 0;
    var rowColor = Colors.white;
    var textColor = Colors.black;
    if ((position + 1) % 2 == 0) {
      rowColor = Colors.black12;
    } else {
      rowColor = Colors.black26;
    }

    if (position == 0) {
      textColor = Colors.white;
      TopRadius = 20.0;
      rowColor = BaseColor;
    }
    if (position + 1 == lenth) {
      textColor = Colors.white;
      ButtomRadius = 20.0;
      TopRadius = 0.0;
      rowColor = BaseColor;
    }

    return position + 1 == lenth
        ? Container(
            child: Form(
                key: _formKey,
                child: Obx(() {
                  return Column(children: [
                    Container(
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
                                child: Text(orderdetail.Sum,
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
                                child: Text("",
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
                                child: Text(orderdetail.Amount,
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
                                child: Text(orderdetail.Name,
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
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(0, 40, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: Get.width-290, //This helps the text widget know what the maximum width is again! You may also opt to use an Expanded widget instead of a Container widget, if you want to use all remaining space.
                            child: Center( //I added this widget to show that the width limiting widget doesn't need to be a direct parent.
                              child: Text(
                                orderdetailController.address.value,
                                style: TextStyle(fontFamily: "yekan",),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                              child: Text(
                                "آدرس تحویل سفارش:",
                                style: TextStyle(
                                  fontFamily: "yekan",
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),

                          Icon(Icons.location_history_rounded,color:BaseColor),
                        ],

                      ),
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              orderdetailController.status.value,
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Text(
                              "وضعیت سفارش: ",
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Icon(Icons.info,color:BaseColor),

                        ],

                      ),
                    ), Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(0, 30, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              orderdetailController.paytype.value,
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Text(
                              "نحوه پرداخت: ",
                              textDirection:TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                            ),
                          ),
                          Icon(Icons.payments_outlined,color:BaseColor),

                        ],

                      ),
                    ),Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(0, 30, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              orderdetailController.date.value,
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Text(
                              "تاریخ ثبت سفارش: ",
                              textDirection:TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                            ),
                          ),
                          Icon(Icons.date_range_rounded,color:BaseColor),

                        ],

                      ),
                    ),Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(0, 30, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              orderdetailController.time.value,
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Container(
                            margin:EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Text(
                              "ساعت ثبت سفارش: ",
                              textDirection:TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: "yekan",
                              ),
                            ),
                          ),
                          Icon(Icons.access_time_outlined,color:BaseColor),

                        ],

                      ),
                    ),

                  ]);
                })))
        : Container(
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
                        child: Text(orderdetail.Sum,
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
                        child: Text(orderdetail.Price,
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
                        child: Text(orderdetail.Amount,
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
                        child: Text(orderdetail.Name,
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
}
