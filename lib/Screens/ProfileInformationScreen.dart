import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leland/Screens/EditProfileInformation.dart';
import 'package:leland/Utils/AnimatedInputField.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/Round_Corner_Image.dart';

class ProfileInformationScreen extends StatefulWidget {
  final int id;

  ProfileInformationScreen({this.id});
  @override
  _ProfileInformationScreenState createState() => _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  TextEditingController role = new TextEditingController();
  TextEditingController pNumber = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController description = new TextEditingController();

  Response response;
  Dio dio = Dio();
  var jsonData;
  var getProfileData;
  String name, hourlyrate, jobid, email, profilepic, userToken, rolename, phonenumber, addRess, password;
  int id;

  Future getMemberProfile() async {
    var data = {'id': widget.id};

    var user_token = await getPrefData(key: 'user_token');
    setState(() {
      // _loading = true;
      userToken = user_token;
    });

    response = await dio.post(
      EDIT_MEMBER,
      data: jsonEncode(data),
      options: Options(
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $userToken',
        },
      ),
    );

    if (response != null) {
      setState(() {
        // _loading = false;
        getProfileData = json.decode(response.data);
      });
      if (getProfileData['status'] == 1) {
        setState(() {
          profilepic = getProfileData['data']['profile_pic'];
          name = getProfileData['data']['name'];
          email = getProfileData['data']['email'];
          hourlyrate = getProfileData['data']['hourly_rate'];
          jobid = getProfileData['data']['job_id'];
          rolename = getProfileData['data']['user_role'];
          phonenumber = getProfileData['data']['phone_number'];
          addRess = getProfileData['data']['address'];
          password = getProfileData['data']['m_password'];
          id = widget.id;

          role = TextEditingController(text: rolename ?? '');
          pNumber = TextEditingController(text: phonenumber ?? '');
          address = TextEditingController(text: addRess ?? '');
        });
        print('Get Data Successfully');
      } else {
        method.showtoast(getProfileData['message'], context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getMemberProfile();
  }

  FutureOr onGoBack(dynamic value) {
    getMemberProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0.0,
        backgroundColor: kPrimaryColor,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Employee', style: kTextStyleBlackHeader),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/ic_back.png', height: 25, width: 25, color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileInformation(id: id))).then((onGoBack));
              },
              child: Icon(Icons.edit, size: 19.0, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: RoundCornerImage(
                      height: 110,
                      width: 110,
                      image: 'http://143.198.104.228/leland_team/$profilepic',
                      circular: 100,
                      placeholder: 'ic_profile_placeholder.png',
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(alignment: Alignment.center, child: Text(name ?? '', style: kTextTitle)),
                  Container(alignment: Alignment.center, child: Text(email ?? '', style: kTextDescription)),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Hourly Rate', style: kTextSmallProfile),
                        Text('${hourlyrate ?? ''}\$ Per hour', style: kTextDescription1),
                      ],
                    ),
                  ),
                  VerticalDivider(color: Colors.grey),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Job ID', style: kTextSmallProfile),
                        Text(jobid ?? '', style: kTextDescription1),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 5.0),
            AnimatedInputField(controller: role, hintText: 'Role', readOnly: true),
            AnimatedInputField(controller: pNumber, hintText: 'Phone Number', readOnly: true),
            AnimatedInputField(controller: address, hintText: 'Address', readOnly: true),
            /*Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                maxLines: 5,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.text,
                style: kTextRole,
                controller: description,
                autofocus: false,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Color(0xff999999), fontSize: 12.0),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffb8b2b2))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffdedede))),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
