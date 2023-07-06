import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices{
  FirebaseMessaging message = FirebaseMessaging.instance;

  void requestNotificationPermission()async{
    NotificationSettings settings = await message.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print("Permission Granetd");
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("Provisional Permission");
    }else{
      AppSettings.openNotificationSettings();
      print("permission Denied");
    }
  }

  Future<String> getToken()async {
    String? token1 = await  message.getToken();
    return token1!;
  }
  void isTokenRefresh(){
    message.onTokenRefresh.listen((event) {
      print(event);
    });
  }

}