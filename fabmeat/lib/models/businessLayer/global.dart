import 'dart:convert';

import 'package:mymeattest/models/appInfoModel.dart';
import 'package:mymeattest/models/appNoticeModel.dart';
import 'package:mymeattest/models/googleMapModel.dart';
import 'package:mymeattest/models/localNotificationModel.dart';
import 'package:mymeattest/models/mapBoxModel.dart';
import 'package:mymeattest/models/mapbyModel.dart';
import 'package:mymeattest/models/nearStoreModel.dart';
import 'package:mymeattest/models/paymentGatewayModel.dart';
import 'package:mymeattest/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

String appDeviceId;
AppInfo appInfo = new AppInfo();
String appName = 'mymeattest';
String appVersion = '1.0';
String baseUrl = 'http://34.131.158.165/mymeattest/api/';
String currentLocation = '';
CurrentUser currentUser = new CurrentUser();
String defaultImage = 'assets/appicon_180x180.png';
GoogleMapModel googleMap; // 28.9490468,77.0138145
Mapby mapby;
AppNotice appNotice;
String imageUploadMessageKey = 'w0daAWDk81';
bool isChatNotTapped = false;
bool isDarkModeEnable = false;
bool isRTL = false;
String languageCode = 'en';
double lat;
double lng;
LocalNotification localNotificationModel = new LocalNotification();
String locationMessage = '';
MapBoxModel mapBox;
NearStoreModel nearStoreModel = new NearStoreModel();
PaymentGateway paymentGateway = new PaymentGateway();
List<String> rtlLanguageCodeLList = [
  'ar',
  'arc',
  'ckb',
  'dv',
  'fa',
  'ha',
  'he',
  'khw',
  'ks',
  'ps',
  'ur',
  'uz_AF',
  'yi'
];
SharedPreferences sp;
String stripeBaseApi = 'https://api.stripe.com/v1';
Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  Map<String, String> apiHeader = new Map<String, String>();

  if (authorizationRequired) {
    sp = await SharedPreferences.getInstance();
    if (sp.getString("currentUser") != null) {
      CurrentUser currentUser =
          CurrentUser.fromJson(json.decode(sp.getString("currentUser")));
      print("Token  == Bearer " +
          currentUser.token +
          'id -- ' +
          currentUser.id.toString());
      apiHeader.addAll({"Authorization": "Bearer " + currentUser.token});
    }
  }
  apiHeader.addAll({"Content-Type": "application/json"});
  apiHeader.addAll({"Accept": "application/json"});
  return apiHeader;
}
