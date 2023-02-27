import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'package:bazinodriver/View/BottomNav.dart';
import 'Controller/OrdersController.dart';
import 'Model/OrdersModel.dart';
import 'View/ApppBar.dart';
import 'View/Loading.dart';
import 'View/MsgBox.dart';
import 'View/MyDrawer.dart';

class OrdersScreen extends StatelessWidget {
  OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed("/OrdersScreen");
        return true;
      },
      child: Scaffold(
        endDrawer:MyDrawer(),
        // backgroundColor: Colors.white,
        body: Obx(() {
          return Container(

            child: Column(
              children: [
                ApppBar(title: "لیست سفارشات", back: "finish"),
                Expanded(
                  flex: 1,
                  child: ordersController.geted.value == 1
                      ? Loading():
                       ordersController.geted.value == 4?MsgBox(type:"internet",screen: "/OrdersScreen",)
                      : ordersController.geted.value == 3
                          ? Container(child: Text(ordersController.msg.value,style: TextStyle(
                           color: Colors.black87,
                           fontFamily: "yekan",
                           fontSize: 14
                       ),))
                          : Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
                                    // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                                    child: ListView.builder(
                                      itemCount: ordersController.order.length,
                                      itemBuilder: (context, position) {
                                        return genItem(
                                            ordersController.order[position],
                                            position);
                                      },
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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

  InkWell genItem(OrdersModel order, int position) {
    return InkWell(
      // splashColor: Colors.white,
      onTap: () {
        OrderRef=order.ID;
        Get.toNamed("/OrderDetailScreen");
        // print(order.ID);
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        elevation: 4,
        child: Container(
          height: 150,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,

                  // color: Colors.cyan,
                  child: Row(
                    children: [
                      Expanded(
                        flex:4,
                        child: Container(
                          alignment:Alignment.centerRight,
                          child: Text( "تاریخ : "+order.Date,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "yekan",
                                  fontSize: 14)),
                        ),
                      ),
                      Expanded(
                        flex:1,
                        child: Container(
                            alignment:Alignment.centerLeft,
                            child: Icon(Icons.date_range_sharp,color: BaseColor, textDirection: TextDirection.rtl)),
                      ),
                      Expanded(
                        flex:4,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text("شماره سفارش: " + order.ID.toString(),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "yekan",
                                  fontSize: 14)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            alignment:Alignment.centerLeft,
                            child: Icon(Icons.border_color,color: BaseColor,size: 21,)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,

                  // color: Colors.cyan,
                  child: Row(
                    children: [
                      Expanded(
                        flex:4,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                          alignment:Alignment.centerRight,
                          child: Text( order.Status,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "yekan",
                                  fontSize: 14)),
                        ),
                      ),
                      Expanded(
                        flex:1,
                        child: Container(
                            alignment:Alignment.centerLeft,
                            child: Icon(Icons.payments_outlined,color: BaseColor, textDirection: TextDirection.rtl)),
                      ),
                      Expanded(
                        flex:4,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text("مبلغ: " + order.Price.toString()+" تومان",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "yekan",
                                  fontSize: 14)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            alignment:Alignment.centerLeft,
                            child: Icon(Icons.price_change_outlined,color: BaseColor,size: 21,)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,

                  // color: Colors.cyan,
                  child: Row(
                    children: [
                      Expanded(
                        flex:5,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: order.StatusRef==0?Colors.amberAccent:order.StatusRef==1?Colors.cyan:order.StatusRef==2?Colors.green:Colors.redAccent,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          margin:EdgeInsets.fromLTRB(20, 0, 20, 10),

                          alignment: Alignment.center,
                          child: Text(order.Status,style:TextStyle(color:Colors.white,fontFamily:"yekan")),
                        ),
                      ),
                      Expanded(
                        flex:5,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
                          child:Text("وضعیت سفارش: ",style:TextStyle(fontFamily:"yekan"),textDirection: TextDirection.rtl,)
                            )
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
