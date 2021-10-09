import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leland/Screens/AddWorkHistory.dart';
import 'package:leland/Screens/HistoryDetails.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/Round_Corner_Image.dart';

class ViewHistory extends StatefulWidget {
  final String title, name, email, profilepic, jobId;
  final int id, workId;
  ViewHistory({this.title, this.name, this.email, this.workId, this.profilepic, this.id, this.jobId});

  @override
  _ViewHistoryState createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  Response response;
  Dio dio = Dio();
  var jsonData;
  String userToken;

  Future<List> workData;

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      // print(userToken);
    });
    workData = getWorkData();
  }

  Future<List> getWorkData() async {
    try {
      response = await dio.post(
        GET_WORK_DATA,
        data: {'id': widget.id, 'job_id': widget.jobId},
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

  timeHrFormat(String time) {
    String convertedTime = new DateFormat("h").format(DateTime.parse("2000-00-00 $time"));
    return convertedTime;
  }

  timeFormat(String time) {
    String convertedTime = new DateFormat("h:MM a").format(DateTime.parse(time));
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
        title: Text(widget.title, style: kTextStyleBlackHeader),
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
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: RoundCornerImage(
                  height: 110,
                  width: 110,
                  image: widget.profilepic,
                  circular: 100,
                  placeholder: 'ic_profile_placeholder.png',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.name,
                  style: kTextTitle,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.email,
                  style: kTextDescription,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Work History',
                  style: kTextTitle,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: workData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return HistoryTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryDetails(
                                  title: widget.title,
                                  jobId: snapshot.data[index]['job_id'] ?? '',
                                  workDate: dateFormat(snapshot.data[index]['work_date'] ?? ''),
                                  startTime: timeFormat(snapshot.data[index]['start_time']),
                                  stopTime: timeFormat(snapshot.data[index]['end_time']),
                                  description: snapshot.data[index]['discription'] ?? '',
                                ),
                              ),
                            );
                          },
                          date: dateFormat(snapshot.data[index]['work_date'] ?? '') ?? '',
                          discription: snapshot.data[index]['discription'] ?? '',
                          job: widget.title,
                          jobId: 'Job ID: ${snapshot.data[index]['job_id'] ?? ''}',
                          totalHours: 'Total ${timeHrFormat(snapshot.data[index]['total_time']) ?? ''} Hours',
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
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final String job, jobId, date, totalHours, discription;
  final Function onTap;

  HistoryTile({this.job, this.jobId, this.date, this.totalHours, this.discription, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job,
                            style: kTextBig,
                            maxLines: 1,
                          ),
                          Text(
                            jobId,
                            style: kTextsmall,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          date,
                          style: kTextsmall,
                        ),
                        Text(
                          totalHours,
                          style: kTextsmall,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  discription,
                  style: kTextsmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
