import 'dart:io';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
class AboutController extends GetxController {
  RxInt geted=0.obs;
  RxString msg="".obs;
  RxString content="".obs;
  onInit() {
    getAbout();
  }
  getAbout() async {
    geted.value=1;
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'getAbout', 'key': ApiKey});
      if (response.statusCode == 200) {
        print(response.body);
        var jsons = convert.jsonDecode(response.body);
        var ok=jsons["ok"];
        if(ok==1){
          content.value=jsons["content"];
          geted.value=2;
        }
        else{
          geted.value=3;
          msg.value=jsons["msg"];
        }
      } else {
        geted.value=3;
        msg.value="خطا در دریافت اطلاعات";
        return 0;
      }
    }
    else{
      geted.value=4;
      msg.value="اینترنت شما وصل نیست";
    }

  }

}
