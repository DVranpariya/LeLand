import 'package:flutter/material.dart';
import 'package:leland/Screens/InvoiceDetails.dart';
import 'package:leland/Utils/Constant.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List Listname = new List();

  @override
  void initState() {
    super.initState();
    Listname.add('Flutter Developer');
    Listname.add('Android Developer');
    Listname.add('IOS Developer');
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
          'Invoice',
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
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: ListView.builder(
            itemCount: Listname.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InvoiceTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InvoiceDetails(title: Listname[index].toString(),)),
                  );
                },
                index: index,
                title: Listname[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class InvoiceTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final int index;

  InvoiceTile({this.onTap, this.title, this.index});

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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: kTextTitle,
                      ),
                      Text(
                        '2134, Justine Court Xyz, Address',
                        style: kTextRole,
                      ),
                      Text(
                        'Job ID: LA 1234',
                        style: kTextRole,
                      ),
                    ],
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
