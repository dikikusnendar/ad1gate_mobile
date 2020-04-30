import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'form_transaksional_page.dart';

enum DismissDialogRedeemVoucher{
  cancel,
  discard,
  save,
}

class DialogRedeemVoucher extends StatefulWidget {
  @override
  _DialogRedeemVoucherState createState() => _DialogRedeemVoucherState();
}

class _DialogRedeemVoucherState extends State<DialogRedeemVoucher> {
  var _ktp,_voucher;
  var _autoValidate = false;
  final _controllerKTP = TextEditingController();
  final _controllerVoucher = TextEditingController();
  final _key = new GlobalKey<FormState>();
  final FocusNode _focusNodeKtp = FocusNode();
  final FocusNode _focusNodeRedeem = FocusNode();
  Screen size;
  var _processCheck = false;
  var _showCard = false;
  var _isValid = false;

  var _dummyKTP = ["123456789","987654321","147258369","369258147","9517538462"];
  var _dataNasabah = {
    "ktp": "123456789",
    "nama_lengkap": "Rangga Muslim",
    "nama_panggilan": "Rangga",
    "tempat_lahir": "Jakarta",
    "tanggal_lahir" : "22-02-1991",
    "status_pernikahan": "1",
    "alamat_survei": "Jalan Kapasari no 47",
    "rt":"009",
    "rw":"010",
    "kecamatan":"Simokerto",
    "kelurahan":"Tambakrejo",
    "kode_pos":"60142"
  };

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Redeem Voucher",style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
        backgroundColor: myPrimaryColor,
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormTransaksionalPage()
            ),
          ).then((val)=>val?_backToHomePage() : null);
        }),
      ),
      body:
      Theme(
        data: ThemeData(primaryColor: Colors.black),
        child: Form(
            key: _key,
            child:
            ListView(
              padding: EdgeInsets.only(left: 16,right: 16,top: 16),
              children: <Widget>[
                TextFormField(
                  autovalidate: _autoValidate,
                  controller: _controllerKTP,
                  decoration: new InputDecoration(
                    labelText: 'KTP',
                    labelStyle: TextStyle(fontFamily: "NunitoSans"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Tidak boleh kosong";
                    }else{
                      return null;
                    }},
                  onSaved: (e) => _ktp = e,
                  focusNode: _focusNodeKtp,
                  onFieldSubmitted: (term){
                    _fieldFocusChange(context, _focusNodeKtp, _focusNodeRedeem);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  autovalidate: _autoValidate,
                  controller: _controllerVoucher,
                  decoration: new InputDecoration(
                    labelText: 'Voucher',
                    labelStyle: TextStyle(fontFamily: "NunitoSans"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusNodeRedeem,
                  onFieldSubmitted: (term){
                    _focusNodeRedeem.unfocus();
                  },
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Tidak boleh kosong";
                    }else{
                      return null;
                    }},
                  onSaved: (e) => _voucher = e,
                ),
                SizedBox(height: 16),
                _processCheck
                    ?
                Center(child: CircularProgressIndicator())
                    :
                SizedBox(height: 0.0,width: 0.0),
                _showCard
                    ?
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Card(
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    color: _isValid ?  Color(0xffb0ffcc) : Color(0xffffa1a1),
                    child: Container(
                      height: 35,
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 16),
                              child:
                              _isValid
                                  ?
                              Text("Valid voucher",style: TextStyle(
                                  fontFamily: "NunitoSansSemiBold",color: Colors.black)
                              )
                                  :
                              Text("Invalid voucher",style: TextStyle(
                                  fontFamily: "NunitoSansSemiBold",color: Colors.black)
                              ))
                        ],
                      ),
                    ),
                  ),
                )
                    :
                SizedBox(height: 0.0,width: 0.0),
              ],
            ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: size.wp(2.5),right: size.wp(2.5),
              bottom: size.hp(1),top: size.hp(1)),
          child: RaisedButton(
              padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: myPrimaryColor,
              onPressed:(){
                _check();
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Redeem",style: TextStyle(fontFamily: "NunitoSansBold",color: Colors.black)),
                ],
              )
          ),
        ),
      ),
    );
  }
  _backToHomePage(){
    Navigator.pop(context);
  }

  _check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _searchKtp();
    }else{
      _autoValidate = true;
    }
  }

  _searchKtp(){
    setState(() {
      _processCheck = true;
    });
    if(_dummyKTP.contains(_ktp)){
      setState(() {
        _processCheck = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormTransaksionalPage()
        ),
      ).then((val)=>val?_backToHomePage() : null);
    }
    else{
      setState(() {
        _showCard = true;
        _isValid = false;
        _processCheck = false;
      });
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);}
}
