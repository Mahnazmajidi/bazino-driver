import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:bazinodriver/Model/OrderDetailModel.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class OrderDetailController extends GetxController {
  RxBool loading = true.obs;
  RxList <OrderDetailModel> orderdetail=<OrderDetailModel>[].obs;
  RxInt geted=0.obs;
  RxInt getedNew=0.obs;
  RxString msg="".obs;
  RxString address="".obs;
  RxString status="".obs;
  RxString date="".obs;
  RxString time="".obs;
  RxString paytype="".obs;
  onInit() {
    getOrderDetail();
  }
  getOrderDetail() async {
    geted.value=0;
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'getOrderDetail', 'key': ApiKey,'OrderRef': OrderRef.toString()});
      if (response.statusCode == 200) {
        print(response.body);
        var jsons = convert.jsonDecode(response.body);
        var data=jsons["data"];
        var ok=jsons["ok"];
        if(ok==1){
          geted.value=1;
          address.value=jsons["address"];
          status.value=jsons["status"];
          date.value=jsons["date"];
          time.value=jsons["time"];
          paytype.value=jsons["paytype"];
          data.forEach((element) {
            OrderDetailModel cModel=new OrderDetailModel(element["ID"],element["Name"],element["Price"].toString().toString(),element["Amount"].toString(),element["Sum"].toString());
            orderdetail.add(cModel);
          });
        }
        else{
          geted.value=2;
          msg.value=jsons["msg"];
        }
      } else {
        geted.value=2;
        msg.value="خطا در دریافت اطلاعات";
      }
    }
    else{
      geted.value=4;
      msg.value="اینترنت شما وصل نیست";
    }

  }


}
