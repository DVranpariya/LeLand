import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leland/Screens/EmployeeScreen.dart';
import 'package:leland/Screens/InvoiceScreen.dart';
import 'package:leland/Screens/JobScreen.dart';
import 'package:leland/Screens/MaterialScreen.dart';
import 'package:leland/Utils/Constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List Listname = new List();

  @override
  void initState() {
    super.initState();
    Listname.add('Employee');
    Listname.add('Jobs');
    Listname.add('Invoice');
    Listname.add('Material-1');
    Listname.add('Material-2');
    Listname.add('Material-3');
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
          'Leland T&M',
          style: kTextStyleBlackHeader,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 17),
            child: ListView.builder(
              itemCount: Listname.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return HomeTile(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmployeeScreen()),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JobScreen()),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InvoiceScreen()),
                      );
                    } else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MaterialScreen(title: Listname[index], materialType: 1)),
                      );
                    } else if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MaterialScreen(title: Listname[index], materialType: 2)),
                      );
                    } else if (index == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MaterialScreen(title: Listname[index], materialType: 3)),
                      );
                    }
                  },
                  index: index,
                  title: Listname[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final int index;

  HomeTile({this.onTap, this.title, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Card(
            elevation: 1,
            color: Color(0xFFE8F4FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    title,
                    style: kTextTitle,
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/ic_next.png',
                  height: 13,
                  width: 13,
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
