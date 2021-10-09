import 'package:flutter/material.dart';
import 'package:leland/Utils/AnimatedInputField.dart';
import 'package:leland/Utils/Color_Shadow_Button.dart';
import 'package:leland/Utils/Constant.dart';

class InvoiceDetails extends StatefulWidget {
  final String title;

  InvoiceDetails({this.title});

  @override
  _InvoiceDetailsState createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  TextEditingController jobId = new TextEditingController();
  TextEditingController address = new TextEditingController();

  @override
  void initState() {
    super.initState();
    jobId.text='JOB ID 1234';
    address.text='1234, Dummy, Address Text';
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
                controller: jobId,
                hintText: 'Job ID',
                readOnly:true,
              ),
              AnimatedInputField(
                controller: address,
                hintText: 'Addres',
                readOnly:true,
              ),
              SizedBox(height: 5,),
              Text(
                'Description',
                style: kTextId,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown  Lorem ipsum, or lipsum as it is sometimes known, is dummyLorem ipsum, or lipsum as it is sometimes known, is dummyLorem ipsum, or lipsum as it is sometimes known, is dummyLorem ipsum, or lipsum as it is sometimes known, is dummy',
                style: kTextRole,
              ),
              SizedBox(height: 15,),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      child: Text(
                        'Total Job Cost',
                        style: kJobBlack,
                      ),
                    ),
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InvoicePriceTile(
                          title: 'Labor_1',
                          price: '\$100',
                        );
                      },
                    ),
                    SizedBox(height: 5,),
                    Divider(color: Colors.grey,
                      indent: 7.7,
                      endIndent: 7.7,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Job Cost',
                            style: kJobBlack,
                          ),
                          Text(
                            '\$500',
                            style: kJobBlack,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: ColorShadowButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    onTap: () {
                      Navigator.pop(context);
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

class InvoicePriceTile extends StatelessWidget {

  final String title,price;
  InvoicePriceTile({this.title,this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kTextRole,
          ),
          Text(
            price,
            style: kTextRole,
          ),
        ],
      ),
    );
  }
}
