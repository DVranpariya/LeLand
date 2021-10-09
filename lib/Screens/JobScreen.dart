import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leland/Screens/AddWorkHistory.dart';
import 'package:leland/Screens/EmployeeScreen.dart';
import 'package:leland/Utils/Constant.dart';

import 'JobDetails.dart';

class JobScreen extends StatefulWidget {
  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  List Listname = [];

  @override
  void initState() {
    super.initState();
    getData();
    Listname.add('Flutter Developer');
    Listname.add('Android Developer');
    Listname.add('Designer');
    Listname.add('IOS Developer');
  }

  FutureOr onGoBack(dynamic value) {
    getData();
    setState(() {});
  }

  Response response;
  Dio dio = Dio();
  var jsonData;
  String userToken;

  Future<List> jobList;

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      print(userToken);
    });
    jobList = getJobList();
    print(jobList);
  }

  Future<List> getJobList() async {
    try {
      response = await dio.post(
        SERVICE_ID_TO_DATA,
        data: {'service_type': 2},
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

  dateFormat(String date) {
    String convertedDate = new DateFormat("dd MMMM, yyyy").format(DateTime.parse(date));
    return convertedDate;
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
          'Jobs',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddWorkHistory())).then((onGoBack));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => AddWorkHistory()),
                        // );
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
                            Text('Add New Job', style: kTextTitle),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder(
                  future: jobList,
                  builder: (context, snapshot) {
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
                                        builder: (context) => JobDetails(
                                          title: snapshot.data[index]['job_name'],
                                          jobId: snapshot.data[index]['job_id'],
                                          address: snapshot.data[index]['job_address'],
                                          description: snapshot.data[index]['job_dicscription'],
                                        ),
                                      ),
                                    );
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => JobDetails(),
                                    //   ),
                                    // );
                                  },
                                  index: index,
                                  title: snapshot.data[index]['job_name'],
                                  jobId: snapshot.data[index]['job_id'],
                                  date: dateFormat(snapshot.data[index]['created_at']),
                                );
                              },
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height - 214,
                              alignment: Alignment.center,
                              child: Text('No Data Found'),
                            );
                    }
                    if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
                      return Container(
                        height: MediaQuery.of(context).size.height - 214,
                        alignment: Alignment.center,
                        child: Text('No Data Found'),
                      );
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height - 214,
                      alignment: Alignment.center,
                      child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor))),
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
  final String title;
  final int index;
  final int jobId;
  final String date;

  JobTiles({this.onTap, this.title, this.index, this.jobId, this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: kTextTitle, maxLines: 1),
                        Text('Job ID: $jobId', style: kTextTitle, maxLines: 2),
                      ],
                    ),
                  ),
                  Text(date, style: kTextTitle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
