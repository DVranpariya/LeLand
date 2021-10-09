import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leland/Screens/ViewHistory.dart';
import 'package:leland/Utils/Color_Shadow_Button.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/Round_Corner_Image.dart';

class JobDetails extends StatefulWidget {
  final String title, address, description;
  final int jobId;
  JobDetails({this.title, this.jobId, this.address, this.description});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  Response response;
  Dio dio = Dio();
  var jsonData;
  String userToken;

  Future<List> jobData;

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      // print(userToken);
    });
    jobData = getJobData();
  }

  Future<List> getJobData() async {
    try {
      response = await dio.post(
        GET_JOB_DATA,
        data: {'job_id': widget.jobId},
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
          print(jsonData['data'][0]['job_user_data']);
          return jsonData['data'][0]['job_user_data'];
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

  // timeFormat(String time) {
  //   String convertedTime = new DateFormat("h").format(DateTime.parse("2000-00-00 $time"));
  //   return convertedTime;
  // }

  timeHrFormat(String time) {
    String convertedTime = new DateFormat("h").format(DateTime.parse("2021-01-01 $time"));
    print(convertedTime);
    return convertedTime;
  }

  @override
  void initState() {
    getData();
    super.initState();
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
          widget.title,
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
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title ?? '', style: kJobBlack),
              SizedBox(height: 5),
              Text('Job ID: ${widget.jobId ?? ''}', style: kTextId),
              SizedBox(height: 5),
              Text(widget.address ?? '', style: kTextId),
              SizedBox(height: 10),
              Text(widget.description ?? '', style: kTextDescription),
              SizedBox(height: 10),
              Text('Employee who work in this job', style: kJobBlack),
              SizedBox(height: 10),
              FutureBuilder(
                  future: jobData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return EmployeeTiles(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewHistory(
                                    id: snapshot.data[index]['user_id'] ?? '',
                                    title: widget.title ?? '',
                                    profilepic: 'http://143.198.104.228/leland_team/${snapshot.data[index]['profile_pic'] ?? ''}',
                                    name: snapshot.data[index]['name'] ?? '',
                                    email: snapshot.data[index]['email'] ?? '',
                                    jobId: snapshot.data[index]['job_id'] ?? '',
                                    workId: snapshot.data[index]['work_id'] ?? '',
                                  ),
                                ),
                              );
                            },
                            index: index,
                            title: snapshot.data[index]['name'] ?? '',
                            role: /*widget.title*/ 'Role ${index + 1}',
                            image: 'http://143.198.104.228/leland_team/${snapshot.data[index]['profile_pic']}',
                            totalTime: 'Total ${timeHrFormat(snapshot.data[index]['total_time'])} Hours',
                          );
                        },
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
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor)),
                    );
                  }),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeTiles extends StatelessWidget {
  final String title, role, image, totalTime;
  final int index;
  final Function onTap;

  EmployeeTiles({this.title, this.index, this.onTap, this.role, this.image, this.totalTime});

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: kTextTitle,
                  ),
                  Text(
                    role,
                    style: kTextRole,
                  ),
                  Text(
                    totalTime,
                    style: kTextRole,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
