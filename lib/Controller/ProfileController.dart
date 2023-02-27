import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:bazinodriver/utils/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ProfileController extends GetxController {
  // RxBool loading = true.obs;
  RxInt code=0.obs;
  RxInt geted=0.obs;
  RxInt getedsignup=0.obs;
  RxInt showmsg=0.obs;
  RxString signmsg="".obs;
  RxString msg="".obs;
  late Timer _timer;
  RxInt start = 120.obs;
  sendsms(String Mobile) async {
    geted.value=1;
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'sendsms','Mobile': Mobile, 'key': ApiKey}).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        var jsons = convert.jsonDecode(response.body);
        print(jsons);
        if(jsons["ok"]==1){
          code.value=jsons["code"];
          geted.value=2;
          start.value = 120;
          showmsg.value=1;
          return 1;
        }
        else {
          geted.value=3;
          print("ERR ok");
          return 0;
        }
      } else {
        geted.value=3;
        print("ERR statusCode");
        return 3;
      }
    }
    else{
      geted.value=4;
      msg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }
  Future<int> signup(String mobile,String fname,String lname,String email,String code) async {
    getedsignup.value=1;
    bool connect = await InternetConnectionChecker().hasConnection;
    if (connect) {
      var response = await http.post(Uri.parse(Api),
          body: {'action': 'signup','mobile': mobile,'fname': fname,'lname': lname,'email': email,'code': code,'AppVersion': AppVersion, 'key': ApiKey}).timeout(const Duration(seconds: 4));;
      if (response.statusCode == 200) {
        var jsons = convert.jsonDecode(response.body);
        print(jsons);
        if(jsons["ok"]==1){
          getedsignup.value=2;
          signmsg.value=jsons["msg"];
          return 1;
        }
        else {
          getedsignup.value=3;
          signmsg.value=jsons["msg"];
          print("ERR ok");
          return 0;
        }
      } else {
        getedsignup.value=3;
        signmsg.value="خطا در دریافت اطلاعات";
        print("ERR statusCode");
        return 0;
      }
    }
    else{
      getedsignup.value=4;
      signmsg.value="اینترنت شما وصل نیست";
      return 0;
    }

  }
  void startTimer() {
    start.value = 120;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          start.value=start.value-1;
        }
      },
    );
  }
}
