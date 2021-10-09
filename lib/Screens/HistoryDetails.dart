import 'package:flutter/material.dart';
import 'package:leland/Utils/AnimatedInputField.dart';
import 'package:leland/Utils/Constant.dart';

class HistoryDetails extends StatefulWidget {
  final String title, workDate, startTime, stopTime, description;
  final int jobId;

  HistoryDetails({this.title, this.workDate, this.startTime, this.stopTime, this.description, this.jobId});

  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  TextEditingController job = new TextEditingController();
  TextEditingController jobId = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController startTime = new TextEditingController();
  TextEditingController stopTime = new TextEditingController();
  TextEditingController description = new TextEditingController();

  @override
  void initState() {
    super.initState();
    job.text = widget.title;
    jobId.text = widget.jobId.toString();
    date.text = widget.workDate;
    startTime.text = widget.startTime;
    stopTime.text = widget.stopTime;
    description.text = widget.description;
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
              AnimatedInputField(
                controller: job,
                hintText: 'Job',
                readOnly: true,
              ),
              AnimatedInputField(
                controller: jobId,
                hintText: 'Job ID',
                readOnly: true,
              ),
              AnimatedInputField(
                controller: date,
                hintText: 'Date',
                readOnly: true,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: AnimatedInputField(
                      controller: startTime,
                      hintText: 'Start Time',
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: AnimatedInputField(
                      controller: stopTime,
                      hintText: 'Stop Time',
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 7, top: 5),
                child: Text(
                  'Description',
                  style: kTextTitle1,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 170,
                padding: EdgeInsets.only(right: 5, top: 2),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFF7286A1), width: 1)),
                child: TextFormField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: Color(0xFF7286A1),
                  style: kTextRole,
                  readOnly: true,
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
    );
  }
}
