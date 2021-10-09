import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leland/Screens/EditMaterials.dart';
import 'package:leland/Utils/AnimatedInputField.dart';
import 'package:leland/Utils/Constant.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class MaterialDetailScreen extends StatefulWidget {
  final String title;
  final int materialId;
  MaterialDetailScreen({this.title, this.materialId});

  @override
  _MaterialDetailScreenState createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
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
  bool _loading = false;

  var getMatData;
  String jobtoMaterial,
      wholesaleCost,
      shCp,
      materialAssociated,
      quantity,
      retailprice,
      wholesaleExPrice,
      tAX,
      wholesaleTotalTax,
      retailExPriceTax,
      retailExPrice,
      userToken;
  int materialid;

  Future getMaterialData() async {
    var data = {'material_id': widget.materialId};

    var user_token = await getPrefData(key: 'user_token');
    setState(() {
      _loading = true;
      userToken = user_token;
    });

    response = await dio.post(
      EDIT_MATERIAL,
      data: jsonEncode(data),
      options: Options(
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $userToken',
        },
      ),
    );

    if (response != null) {
      setState(() {
        _loading = false;
        getMatData = json.decode(response.data);
      });
      if (getMatData['status'] == 1) {
        print(getMatData['data']);
        setState(() {
          jobtoMaterial = getMatData['data']['job_associated_to_the_material'];
          wholesaleCost = getMatData['data']['wholesale_cost'];
          shCp = getMatData['data']['sh_cp'];
          materialAssociated = getMatData['data']['material_associated'];
          quantity = getMatData['data']['quantity'];
          retailprice = getMatData['data']['retail_price'];
          wholesaleExPrice = getMatData['data']['wholesale_extend_price'];
          tAX = getMatData['data']['tax'];
          wholesaleTotalTax = getMatData['data']['wholesale_total_with_tex'];
          retailExPriceTax = getMatData['data']['retail_ext_price_with_tex'];
          retailExPrice = getMatData['data']['retail_extend_price'];
          materialid = widget.materialId;

          materials = TextEditingController(text: jobtoMaterial ?? '');
          wholesale = TextEditingController(text: wholesaleCost ?? '');
          sh = TextEditingController(text: shCp ?? '');
          mas = TextEditingController(text: materialAssociated ?? '');
          qty = TextEditingController(text: quantity ?? '');
          retailPrice = TextEditingController(text: retailprice ?? '');
          wep = TextEditingController(text: wholesaleExPrice ?? '');
          tax = TextEditingController(text: tAX ?? '');
          wtwTax = TextEditingController(text: wholesaleTotalTax ?? '');
          repwTax = TextEditingController(text: retailExPriceTax ?? '');
          rep = TextEditingController(text: retailExPrice ?? '');
        });
        // print('Get Data Successfully');
      } else {
        method.showtoast(getMatData['message'], context);
      }
    }
  }

  FutureOr onGoBack(dynamic value) {
    getMaterialData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMaterialData();
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
        title: Text(jobtoMaterial ?? '', style: kTextStyleBlackHeader),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/ic_back.png', height: 25, width: 25, color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditMaterials(materialId: widget.materialId))).then((onGoBack));
              },
              child: Icon(Icons.edit, size: 19.0, color: Colors.white),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedInputField(controller: materials, hintText: 'Job Associated To The Materials', readOnly: true),
                AnimatedInputField(controller: wholesale, hintText: 'Wholesale Cost', readOnly: true),
                AnimatedInputField(controller: sh, hintText: 'SH C&P', readOnly: true),
                AnimatedInputField(controller: mas, hintText: 'Material Associated', readOnly: true),
                AnimatedInputField(controller: qty, hintText: 'Quantity', readOnly: true),
                AnimatedInputField(controller: retailPrice, hintText: 'Retail Price', readOnly: true),
                AnimatedInputField(controller: wep, hintText: 'Wholesale Extended Price', readOnly: true),
                AnimatedInputField(controller: tax, hintText: 'Tax', readOnly: true),
                AnimatedInputField(controller: wtwTax, hintText: 'Wholesale Total With Tax', readOnly: true),
                AnimatedInputField(controller: repwTax, hintText: 'Retail Ext. Price With Tax', readOnly: true),
                AnimatedInputField(controller: rep, hintText: 'Retail Extended Price', readOnly: true),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
