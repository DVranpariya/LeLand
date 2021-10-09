import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leland/Utils/Color_Shadow_Button.dart';
import 'package:leland/Utils/Constant.dart';
import 'package:leland/Utils/InnputFildRound.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditMaterials extends StatefulWidget {
  final int materialId;
  EditMaterials({this.materialId});

  @override
  _EditMaterialsState createState() => _EditMaterialsState();
}

class _EditMaterialsState extends State<EditMaterials> {
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

  bool editIcon = false;

  @override
  void initState() {
    super.initState();
    getData();
    getMaterialData();
  }

  Response response;
  Dio dio = Dio();
  var jsonData;

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
  bool _loading = false;

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

  Future getData() async {
    String user_token = await getPrefData(key: 'user_token');
    setState(() {
      userToken = user_token;
      print(userToken);
    });
  }

  void editMaterial() async {
    setState(() {
      _loading = true;
    });

    try {
      response = await dio.post(
        EDIT_MATERIAL,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
        data: {
          'material_id': widget.materialId,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0.0,
        backgroundColor: kPrimaryColor,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Edit Materials', style: kTextStyleBlackHeader),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/ic_back.png', height: 25, width: 25, color: Colors.white),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Job Associated To The Materials', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: materials, hintText: 'Job Associated To The Materials', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Wholesale Cost', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: wholesale, hintText: 'Wholesale Cost', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('SH C&P', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: sh, hintText: 'SH C&P', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Materials Associated', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: mas, hintText: 'Materials Associated', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Quantity', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: qty, hintText: 'Quantity', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Retail Price', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: retailPrice, hintText: 'Retail Price', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Wholesale Extended Price', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: wep, hintText: 'Wholesale Extended Price', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Tax', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: tax, hintText: 'Tax', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Wholesale Total With Tax', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: wtwTax, hintText: 'Wholesale Total With Tax', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Retail Ext. Price With Tax', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: repwTax, hintText: 'Retail Ext. Price With Tax', prefix: '', type: TextInputType.text),
                Container(margin: EdgeInsets.only(left: 7, top: 10), child: Text('Retail Extended Price', style: kTextTitle1)),
                InputFieldRound(height: 50, controller: rep, hintText: 'Retail Extended Price', prefix: '', type: TextInputType.text),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: ColorShadowButton(
                      width: MediaQuery.of(context).size.width * 0.9,
                      onTap: () {
                        editMaterial();
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
      ),
    );
  }
}
