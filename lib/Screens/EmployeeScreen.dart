import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:leland/Screens/AddNewEmployee.dart';
import 'package:leland/Screens/ProfileInformationScreen.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/Round_Corner_Image.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  Response response;
  Dio dio = Dio();
  var jsonData;
  String userToken;

  Future<List> employeeList;

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      print(userToken);
    });
    employeeList = getMembersList();
  }

  Future<List> getMembersList() async {
    try {
      response = await dio.post(
        SERVICE_ID_TO_DATA,
        data: {'service_type': 1},
        options: Options(
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $userToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.data);
        });
        if (jsonData['status'] == 1) {
          method.showtoast(jsonData['message'], context);
          print(jsonData['data']);
          return jsonData['data'];
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

  FutureOr onGoBack(dynamic value) {
    getData();
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
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: DottedBorder(
                  color: Color(0xFF526788),
                  strokeWidth: 2,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewEmployee())).then((onGoBack));
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      color: Color(0xFFE8F4FF),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/ic_add.png', height: 14, width: 14),
                          SizedBox(height: 10),
                          Text('Add New Employee', style: kTextTitle),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder(
                  future: employeeList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
                      return Container(
                        height: MediaQuery.of(context).size.height - 214,
                        alignment: Alignment.center,
                        child: Text('No Data Found'),
                      );
                    }
                    if (snapshot.hasData) {
                      return snapshot.data.length != 0
                          ? ListView.builder(
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return EmployeeTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileInformationScreen(id: snapshot.data[index]['id'])))
                                        .then((onGoBack));
                                  },
                                  email: snapshot.data[index]['email'] ?? '',
                                  image: 'http://143.198.104.228/leland_team/${snapshot.data[index]['profile_pic'] ?? ''}',
                                  name: snapshot.data[index]['name'] ?? '',
                                  role: snapshot.data[index]['job_name'] ?? '',
                                );
                              },
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height - 214,
                              alignment: Alignment.center,
                              child: Text('No Data Found'),
                            );
                    }
                    return Container(
                        height: MediaQuery.of(context).size.height - 214,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor)));
                  }),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeTile extends StatelessWidget {
  final String email, image, name, role;
  final Function onTap;

  EmployeeTile({this.email, this.image, this.name, this.role, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: RoundCornerImage(
                    height: 75,
                    width: 75,
                    image: image,
                    circular: 5,
                    placeholder: 'ic_profile_placeholder.png',
                  )),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: kTextTitle,
                      maxLines: 1,
                    ),
                    Text(
                      email,
                      style: kTextRole,
                      maxLines: 1,
                    ),
                    Text(
                      role,
                      style: kTextRole,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
