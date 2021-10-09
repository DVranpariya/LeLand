import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

/// API
const BASE_URL = 'http://143.198.104.228/leland_team/api';
const LOGIN = '$BASE_URL/login';
const SERVICE_LIST = '$BASE_URL/get_leland_service';
const SERVICE_ID_TO_DATA = '$BASE_URL/get_leland_service_id_to_data';
const ADD_MEMBER = '$BASE_URL/add_member';
const EDIT_MEMBER = '$BASE_URL/edit_member';
const ADD_JOB = '$BASE_URL/add_jobs';
const GET_JOB_DATA = '$BASE_URL/get_job_history';
const GET_WORK_DATA = '$BASE_URL/get_work_history_by_id';
const GET_MATERIAL_DATA = '$BASE_URL/get_materia_data_by_type';
const ADD_MATERIAL = '$BASE_URL/add_material';
const EDIT_MATERIAL = '$BASE_URL/edit_material';

Future setPrefData({String key, String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future getPrefData({String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString(key);
  return data;
}

Future clearSharedData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

dynamic Option() async {
  dynamic option = Options(
    headers: await getheaderdatamultipart(),
    method: 'Post',
    responseType: ResponseType.json,
  );
  return option;
}

dynamic getheaderdatamultipart({String key}) async {
/*
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString('token');
  dynamic headerdata = {
    HttpHeaders.authorizationHeader: 'Bearer' + ' ' + '$data',
    'Accept': 'application/json',
  };
  return headerdata;
*/
}

//Sep 17,2020, 12 PM

String reformatdate1({String date}) {
  DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
  String formattedDate = DateFormat('MMM dd,yyyy hh a').format(tempDate);
  return formattedDate;
}

String betweenDate({String date, String date2}) {
  DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
  DateTime tempDate1 = new DateFormat("yyyy-MM-dd").parse(date2);
  String formattedDate = DateFormat('dd-').format(tempDate);
  String formattedDate1 = DateFormat('dd MMM yyyy').format(tempDate1);
  return formattedDate + formattedDate1;
}

final kPrimaryColor = Color(0xFF2291FF);
final kDarkPrimaryColor = Color(0xFFE2291FF);
final kTotalDiscount = Color(0xFF2291FF);
final kBlueColor = Color(0xFF2672ca);
final kBlueColorCard = Color(0xFF5277CD);
final kRedColor = Color(0xFFfd3951);
final kLightGreyColor = Color(0xFFbebebe);
final kDarkGreenColor = Color(0xFFbebebe);
final kLightBlackColor = Color(0xFF3a3a3a);
final kLightSilverColor = Color(0xFFb4bbc1);
final kLightGreenColor = Color(0xFF54db6b);
final kCardColor = Color(0xFFF6F6F6);
final kGreyColor = Color(0xFFc6c6c6);
final kDarkGreyColor = Color(0xFFa4a4a4);
final kDarkGrey1 = Color(0xFFe1e1e1);
final kLightPurpleColor = Color(0xFF42425B);
final kGreyTextColor = Color(0xFF6f6f6f);
final kSelectedGreyColor = Color(0xFFf4f4f4);
final kDashedColor = Color(0xFF707070);
final kDarkRedColor = Color(0xFF9f2414);
final kSkyBlueColor = Color(0xFFf6fbff);
final kSilverColor = Color(0xFF8a98ba);
final kYellowColor = Color(0xFFffcc00);
final kDisableSlideColor = Color(0xFFedeeff);
final kGrayPaymentCard = Color(0xFF6C6C6C);

final kTextTitle = TextStyle(
  fontSize: 14.0,
  color: Color(0xFF7286A1),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextBig = TextStyle(
  fontSize: 16.0,
  color: Color(0xFF7286A1),
  fontWeight: FontWeight.w200,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextsmall = TextStyle(
  fontSize: 12.0,
  color: Color(0xFF7286A1),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextRole = TextStyle(
  fontSize: 12.0,
  color: Color(0xFF7286A1),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kButtonStyleWhiteBold = TextStyle(
  fontSize: 14.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kButtonStyleBlue = TextStyle(
  fontSize: 14.0,
  color: kPrimaryColor,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextTitle1 = TextStyle(
  fontSize: 14.0,
  color: Color(0xFF7286A1),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextTitleWhite = TextStyle(
  fontSize: 14.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextTitleWhite1 = TextStyle(
  fontSize: 14.0,
  color: Color(0xD0D4CDCD),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextSmallProfile = TextStyle(
  fontSize: 12.0,
  color: Color(0xFF7286A1),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextDelete = TextStyle(
  fontSize: 9.0,
  color: Colors.red,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextStyleBlackHeader = TextStyle(
  fontSize: 16.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kJobBlack = TextStyle(
  fontSize: 16.0,
  color: Color(0xFF526788),
  fontWeight: FontWeight.w900,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextId = TextStyle(
  fontSize: 14.0,
  color: Color(0xFF74859F),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kLogo = TextStyle(
  fontSize: 25.0,
  color: Colors.white,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextDescription = TextStyle(
  fontSize: 13.0,
  color: Color(0xFFC3CAD5),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kTextDescription1 = TextStyle(
  fontSize: 12.0,
  color: Color(0xFFC3CAD5),
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

final kBigWhiteSmall = TextStyle(
  fontSize: 15.0,
  color: Colors.black,
  fontFamily: 'medium',
  decoration: TextDecoration.none,
);

class method {
  static showtoast(String msg, BuildContext context) {
    Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, textColor: Colors.white);
  }

  static textproperty({var FontSize}) {
    return TextStyle(fontSize: FontSize, fontFamily: '', color: Colors.white);
  }

  static String getdeviceId() {
    if (Platform.isIOS) {
      return '1';
    } else if (Platform.isAndroid) {
      return '0';
    }
  }
}

String reformatdate({String date, String currentformat, String reqfromat}) {
  DateTime tempDate = new DateFormat(currentformat).parse(date);
  String formattedDate = DateFormat(reqfromat).format(tempDate);
  return formattedDate;
}

Future getSharedPrefData({String key}) async {
/*
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString(key);
  return data;
*/
}

String reformatDate({String date}) {
  DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
  String formattedDate = DateFormat('dd MMM yyyy').format(tempDate);
  return formattedDate;
}
