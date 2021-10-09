import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leland/Screens/HomeScreen.dart';
import 'package:leland/Utils/Color_Shadow_Button.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/InitialData.dart';
import 'package:leland/Utils/InnputFieldPassword.dart';
import 'package:leland/Utils/InnputFildLogin.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Response response;
  Dio dio = Dio();
  double latitude, longitude;
  var deviceID, jsonData;
  int deviceType;
  String deviceToken;
  bool _loading = false;

  getDeviceData() async {
    InitialData deviceInfo = InitialData();
    await deviceInfo.getDeviceTypeId();
    deviceType = deviceInfo.deviceType;
    deviceID = deviceInfo.deviceID;

    InitialData token = InitialData();
    token.getDeviceToken();
    deviceToken = token.deviceToken;
    print('dID: $deviceID <<>> dTYPE: $deviceType <<>> dToken: $deviceToken');
  }

  void loginUser() async {
    setState(() {
      _loading = true;
    });
    try {
      response = await dio.post(
        LOGIN,
        data: {
          'email': email.text,
          'password': password.text,
          'device_id': deviceID,
          'device_token': deviceToken,
          'device_type': deviceType,
          'user_role': 1,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setUserData();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
          method.showtoast(jsonData['message'], context);
        }
        if (jsonData['status'] == 0) {
          method.showtoast(jsonData['message'], context);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future setUserData() async {
    await setPrefData(key: 'user_token', value: jsonData['data']['user_token'].toString());
  }

  @override
  void initState() {
    getDeviceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/ic_bg.png'), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Leland T&M',
                    style: kLogo,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: kLogo,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 7, top: 10),
                          child: Text(
                            'Email',
                            style: kTextTitleWhite,
                          ),
                        ),
                        InputFieldLogin(
                          height: 50,
                          controller: email,
                          hintText: 'Email',
                          prefix: '',
                          type: TextInputType.emailAddress,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 7, top: 10),
                          child: Text(
                            'Password',
                            style: kTextTitleWhite,
                          ),
                        ),
                        InputFieldPassword(
                          height: 50,
                          controller: password,
                          hintText: 'Password',
                          prefix: '',
                          type: TextInputType.text,
                          obscureText: true,
                        ),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: ColorShadowButton(
                              width: MediaQuery.of(context).size.width * 0.9,
                              onTap: () {
                                loginUser();
                              },
                              height: 55,
                              text: 'Login',
                              textStyle: kButtonStyleBlue,
                              buttonColor: Colors.white,
                              shadowColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
