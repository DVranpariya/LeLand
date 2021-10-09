import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leland/Screens/JobScreen.dart';
import 'package:leland/Utils/Color_Shadow_Button.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/InnputFildRound.dart';
import 'package:leland/Utils/TimePiker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddWorkHistory extends StatefulWidget {
  @override
  _AddWorkHistoryState createState() => _AddWorkHistoryState();
}

String selectedTime;

class _AddWorkHistoryState extends State<AddWorkHistory> {
  TextEditingController job = new TextEditingController();
  TextEditingController jobId = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController description = new TextEditingController();
  var date1;
  DateTime selectedDate = DateTime.now();

  String selectedTimeText;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date.text = reformatDate(date: selectedDate.toString());
      });
  }

  Response response;
  Dio dio = Dio();
  var jsonData;
  bool _loading = false;
  String userToken;

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      print(userToken);
    });
  }

  void addJob() async {
    setState(() {
      _loading = true;
    });
    try {
      response = await dio.post(
        ADD_JOB,
        options: Options(
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $userToken',
          },
        ),
        data: {
          'job_name': job.text,
          'job_dicscription': description.text,
          'service_id': 6,
          'job_id': jobId.text,
          'job_address': address.text,
        },
      );

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
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    selectedTime = null;
    selectedDate = null;
    // TODO: implement dispose
    super.dispose();
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
        title: Text(
          'Add Job',
          style: kTextStyleBlackHeader,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'assets/ic_back.png',
            height: 25,
            width: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 7, top: 10),
                        child: Text(
                          'Job',
                          style: kTextTitle1,
                        ),
                      ),
                      InputFieldRound(
                        height: 50,
                        controller: job,
                        hintText: 'Job',
                        prefix: '',
                        type: TextInputType.text,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7, top: 10),
                        child: Text(
                          'Job ID',
                          style: kTextTitle1,
                        ),
                      ),
                      InputFieldRound(
                        height: 50,
                        controller: jobId,
                        hintText: 'Job Id',
                        prefix: '',
                        type: TextInputType.text,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7, top: 10),
                        child: Text(
                          'Address',
                          style: kTextTitle1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 100,
                        padding: EdgeInsets.only(right: 5, top: 2),
                        decoration:
                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFF7286A1), width: 1)),
                        child: TextFormField(
                          controller: address,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          cursorColor: Color(0xFF7286A1),
                          style: kTextTitle,
                          decoration: InputDecoration(
                            hintText: 'Address',
                            hintStyle: kTextTitleWhite1,
                            contentPadding: EdgeInsets.only(
                                left: 10,
                                /*bottom: 11, top: 11,*/
                                right: 10),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7, top: 10),
                        child: Text(
                          'Description',
                          style: kTextTitle1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 100,
                        padding: EdgeInsets.only(right: 5, top: 2),
                        decoration:
                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFF7286A1), width: 1)),
                        child: TextFormField(
                          controller: description,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          cursorColor: Color(0xFF7286A1),
                          style: kTextTitle,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: kTextTitleWhite1,
                            contentPadding: EdgeInsets.only(
                                left: 10,
                                /*bottom: 11, top: 11,*/
                                right: 10),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ColorShadowButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    onTap: () {
                      addJob();
                    },
                    height: 55,
                    text: 'Done',
                    textStyle: kButtonStyleWhiteBold,
                    buttonColor: kPrimaryColor,
                    shadowColor: Colors.transparent,
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

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({
    Key key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(padding: mediaQuery.viewInsets, duration: const Duration(milliseconds: 300), child: child);
  }
}
