import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leland/Screens/AddMaterialScreen.dart';
import 'package:leland/Screens/AddWorkHistory.dart';
import 'package:leland/Screens/EmployeeScreen.dart';
import 'package:leland/Screens/MaterialDetailScreen.dart';
import 'package:leland/Utils/Constant.dart';

import 'EditMaterials.dart';
import 'JobDetails.dart';

class MaterialScreen extends StatefulWidget {
  final String title;
  final int materialType;
  MaterialScreen({this.title, this.materialType});
  @override
  _MaterialScreenState createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  List Listname = [];

  @override
  void initState() {
    super.initState();
    getData();
    Listname.add('Material1');
    Listname.add('Material2');
    Listname.add('Material3');
  }

  dateFormat(String date) {
    String convertedDate = new DateFormat("dd MMMM, yyyy").format(DateTime.parse(date));
    return convertedDate;
  }

  Response response;
  Dio dio = Dio();
  var jsonData;
  String userToken;

  Future<List> materialList;

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      // print(userToken);
    });
    materialList = getMaterialList();
  }

  Future<List> getMaterialList() async {
    try {
      response = await dio.post(
        GET_MATERIAL_DATA,
        data: {'material_type': widget.materialType},
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
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
        title: Text(widget.title, style: kTextStyleBlackHeader),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/ic_back.png', height: 25, width: 25, color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMaterialScreen(title: widget.title),
                          ),
                        ).then((onGoBack));
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
                            Text('Add New Material', style: kTextTitle),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder(
                  future: materialList,
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
                                return JobTiles(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MaterialDetailScreen(
                                          title: snapshot.data[index]['job_associated_to_the_material'] ?? '',
                                          materialId: snapshot.data[index]['material_id'],
                                        ),
                                      ),
                                    ).then((onGoBack));
                                  },
                                  index: index,
                                  title: snapshot.data[index]['job_associated_to_the_material'] ?? '',
                                  date: dateFormat(snapshot.data[index]['created_at']),
                                  jobId: snapshot.data[index]['job_id'],
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
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JobTiles extends StatelessWidget {
  final Function onTap;
  final String title, date, jobId;

  final int index;

  JobTiles({this.onTap, this.title, this.index, this.date, this.jobId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 90,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Card(
            elevation: 1,
            color: Color(0xFFE8F4FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title, style: kTextTitle, maxLines: 1),
                            Text(date, style: kTextTitle),
                          ],
                        ),
                        Text('Job ID: $jobId', style: kTextTitle, maxLines: 2),
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
