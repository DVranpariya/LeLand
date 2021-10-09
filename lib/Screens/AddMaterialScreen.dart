import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leland/Screens/EditMaterials.dart';
import 'package:leland/Utils/AnimatedInputField.dart';
import 'package:leland/Utils/Color_Shadow_Button.dart';
import 'package:leland/Utils/Constant.dart';

class AddMaterialScreen extends StatefulWidget {
  final String title;
  AddMaterialScreen({this.title});

  @override
  _AddMaterialScreenState createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  TextEditingController materials = new TextEditingController();
  TextEditingController wholesale = new TextEditingController();
  TextEditingController sh = new TextEditingController();
  TextEditingController mas = new TextEditingController();
  TextEditingController qty = new TextEditingController();
  TextEditingController retailPrice = new TextEditingController();
  TextEditingController wep = new TextEditingController();
  TextEditingController tax = new TextEditingController();
  TextEditingController wtwTax = new TextEditingController();
  TextEditingController repwTax = new TextEditingController();
  TextEditingController rep = new TextEditingController();

  Response response;
  Dio dio = Dio();
  var jsonData;
  String userToken;
  bool _loading = false;

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      print(userToken);
    });
  }

  void addMaterial() async {
    setState(() {
      _loading = true;
    });

    try {
      response = await dio.post(
        ADD_MATERIAL,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
        data: {
          'material_type': 1,
          'job_id': 123456,
          'job_associated_to_the_material': materials.text,
          'wholesale_cost': wholesale.text,
          'sh_cp': sh.text,
          'material_associated': mas.text,
          'quantity': qty.text,
          'retail_price': retailPrice.text,
          'wholesale_extend_price': wep.text,
          'tax': tax.text,
          'wholesale_total_with_tex': wtwTax.text,
          'retail_ext_price_with_tex': repwTax.text,
          'retail_extend_price': rep.text,
        },
      );
      print(response);
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
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedInputField(controller: materials, hintText: 'Job Associated To The Materials', readOnly: false),
              AnimatedInputField(controller: wholesale, hintText: 'Wholesale Cost', readOnly: false),
              AnimatedInputField(controller: sh, hintText: 'SH C&P', readOnly: false),
              AnimatedInputField(controller: mas, hintText: 'Material Associated', readOnly: false),
              AnimatedInputField(controller: qty, hintText: 'Quantity', readOnly: false),
              AnimatedInputField(controller: qty, hintText: 'Retail Price', readOnly: false),
              AnimatedInputField(controller: wep, hintText: 'Wholesale Extended Price', readOnly: false),
              AnimatedInputField(controller: wtwTax, hintText: 'Wholesale Total With Tax', readOnly: false),
              AnimatedInputField(controller: repwTax, hintText: 'Retail Ext. Price With Tax', readOnly: false),
              AnimatedInputField(controller: rep, hintText: 'Retail Extended Price', readOnly: false),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ColorShadowButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    onTap: () {
                      addMaterial();
                    },
                    height: 55,
                    text: 'Save',
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
