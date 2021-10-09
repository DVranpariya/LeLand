import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leland/Screens/EmployeeScreen.dart';
import 'package:leland/Screens/ProfileInformationScreen.dart';
import 'package:leland/Utils/Color_Shadow_Button.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/InnputFildRound.dart';
import 'package:leland/Utils/Round_Corner_Image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfileInformation extends StatefulWidget {
  // final String name, email, pass, role, hrRate, phoneNumber, address, profilepic;
  final int id;

  EditProfileInformation({
    this.id,
  });
  @override
  _EditProfileInformationState createState() => _EditProfileInformationState();
}

class _EditProfileInformationState extends State<EditProfileInformation> {
  File _image;
  String profileImage;
  String fileName = '';
  Response response;
  Dio dio = Dio();
  String userToken;

  TextEditingController fullName = new TextEditingController();
  TextEditingController eMail = new TextEditingController();
  TextEditingController passWord = new TextEditingController();
  TextEditingController roleName = new TextEditingController();
  TextEditingController hrRate = new TextEditingController();
  TextEditingController phNumber = new TextEditingController();
  TextEditingController addRess = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      fileName = _image.path.split('/').last;
    });
  }

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      // print(userToken);
    });
  }

  var getProfileData;
  String name, email, pass, role, hRate, phoneNumber, address, profilepic;

  Future getProfile() async {
    var user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
    });

    response = await dio.post(
      EDIT_MEMBER,
      data: {'id': widget.id},
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
        getProfileData = json.decode(response.data);
      });
      if (getProfileData['status'] == 1) {
        setState(() {
          name = getProfileData['data']['name'];
          email = getProfileData['data']['email'];
          pass = getProfileData['data']['m_password'];
          role = getProfileData['data']['user_role'];
          hRate = getProfileData['data']['hourly_rate'];
          phoneNumber = getProfileData['data']['phone_number'];
          address = getProfileData['data']['address'];
          profilepic = getProfileData['data']['profile_pic'];

          fullName = TextEditingController(text: name);
          eMail = TextEditingController(text: email);
          passWord = TextEditingController(text: pass);
          roleName = TextEditingController(text: role);
          hrRate = TextEditingController(text: hRate);
          phNumber = TextEditingController(text: phoneNumber);
          addRess = TextEditingController(text: address);
        });
      } else {
        method.showtoast(getProfileData['message'], context);
      }
    }
  }

  @override
  void initState() {
    getData();
    getProfile();
    super.initState();
  }

  var jsonData;
  bool _loading = false;

  Future onGoBack(dynamic value) {
    setState(() {});
  }

  void editMember() async {
    setState(() {
      _loading = true;
    });
    var data;
    _image == null
        ? data = {
            'id': widget.id,
            'name': fullName.text,
            'email': eMail.text,
            'm_password': passWord.text,
            'hourly_rate': hrRate.text,
            'address': addRess.text,
            'phone_number': phNumber.text,
            'user_role': roleName.text,
          }
        : data = FormData.fromMap({
            'id': widget.id,
            'profile_pic': _image == null ? '' : await MultipartFile.fromFile(_image.path, filename: fileName ?? ''),
            'name': fullName.text,
            'email': eMail.text,
            'm_password': passWord.text,
            'hourly_rate': hrRate.text,
            'address': addRess.text,
            'phone_number': phNumber.text,
            'user_role': roleName.text,
          });

    try {
      response = await dio.post(
        EDIT_MEMBER,
        data: data,
      );
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          Navigator.pop(context);
          method.showtoast(jsonData['message'], context);
        } else {
          method.showtoast(jsonData['message'], context);
        }
      } else {
        method.showtoast(jsonData['message'], context);
      }
    } catch (e) {
      print('Exception Detected >>> ${e.toString()} <<<');
    }
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
        title: Text('Edit Employee', style: kTextStyleBlackHeader),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/ic_back.png', height: 25, width: 25, color: Colors.white),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(height: 110, width: 110),
                        profilepic == null || profilepic == 'null' || profilepic == '' || _image != null
                            ? RoundCornerImage(
                                height: 110,
                                width: 110,
                                image: _image != null ? '' : '',
                                circular: 100,
                                placeholder: 'ic_profile_placeholder.png',
                                fileImage: _image != null ? _image : null,
                              )
                            : Container(
                                child: RoundCornerImage(
                                  height: 110,
                                  width: 110,
                                  image: _image != null ? '' : 'http://143.198.104.228/leland_team/$profilepic',
                                  circular: 100,
                                  placeholder: 'ic_profile_placeholder.png',
                                  fileImage: _image != null ? _image : null,
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset('assets/ic_camera.png', height: 35, width: 35),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Name', style: kTextTitle1)),
                    InputFieldRound(height: 50, controller: fullName, hintText: 'Name', prefix: '', type: TextInputType.text),
                    Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Email', style: kTextTitle1)),
                    InputFieldRound(height: 50, controller: eMail, hintText: 'Email', prefix: '', type: TextInputType.emailAddress),
                    // Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Password', style: kTextTitle1)),
                    // InputFieldRound(height: 50, controller: passWord, hintText: 'Password', prefix: '', type: TextInputType.text),
                    Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Role', style: kTextTitle1)),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        items: ["Role 1", "Role 2", "Role 3"],
                        onChanged: print,
                        maxHeight: 140,
                        dropdownSearchDecoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0xFF7286A1))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0xFF7286A1))),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0xFF7286A1))),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          labelText: 'Role ${roleName.text}' ?? "Select Role",
                          labelStyle: kTextTitle1,
                        ),
                      ),
                    ),
                    Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Hourly Rate', style: kTextTitle1)),
                    InputFieldRound(height: 50, controller: hrRate, hintText: 'Hourly Rate', prefix: '', type: TextInputType.number),
                    Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Phone Number', style: kTextTitle1)),
                    InputFieldRound(height: 50, controller: phNumber, hintText: 'Phone Number', prefix: '', type: TextInputType.phone),
                    Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Address', style: kTextTitle1)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 120,
                      padding: EdgeInsets.only(right: 5, top: 2),
                      decoration:
                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFF7286A1), width: 1)),
                      child: TextFormField(
                        controller: addRess,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        cursorColor: Color(0xFF7286A1),
                        style: kTextTitle,
                        decoration: InputDecoration(
                          hintText: 'Address',
                          contentPadding: EdgeInsets.only(left: 10, bottom: 11, top: 11, right: 10),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintStyle: kTextTitleWhite1,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: ColorShadowButton(
                          width: MediaQuery.of(context).size.width * 0.9,
                          onTap: () {
                            editMember();
                          },
                          height: 55,
                          text: 'Save',
                          textStyle: kButtonStyleWhiteBold,
                          buttonColor: kPrimaryColor,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
