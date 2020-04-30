import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SecondWidgetStepper extends StatefulWidget {
  final VoidCallback onStepContinue,onStepCancel;

  const SecondWidgetStepper({Key key, this.onStepContinue, this.onStepCancel}) : super(key: key);

  @override
  SecondWidgetStepperState createState() => SecondWidgetStepperState();
}

class SecondWidgetStepperState extends State<SecondWidgetStepper> {
  var _autoValidate = false;
  final _controllerJenisPembayaran = new TextEditingController();
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      widget.onStepContinue();
    } else {
      setState(() {
        _autoValidate = true;
      });
      print("Validation jalan");
    }
  }

  var jenisPembayaran;
  Screen size;
  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("Data Pengajuan Kredit",style: TextStyle(fontFamily: "NunitoSans")),
          ),
          SizedBox(height: size.hp(3)),
          TextFormField(
            autovalidate: _autoValidate,
            controller: _controllerJenisPembayaran,
            decoration: new InputDecoration(
              labelText: 'Jenis Pembiayaan',
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            validator: (e) {
              if (e.isEmpty) {
                return "Tidak boleh kosong";
              }else{
                return null;
              }},
            onSaved: (e) => jenisPembayaran = e,
          ),
        ],
      ),
    );
//      Scaffold(
//      body: Container(
//        child: Column(
//          children: <Widget>[
//            Container(
//              child: Text("Data Pengajuan Kredit",style: TextStyle(fontFamily: "NunitoSans")),
//            ),
//            TextFormField(
//              autovalidate: _autoValidate,
//              controller: _controllerJenisPembayaran,
//              decoration: new InputDecoration(
//                labelText: 'Dealer Cabang Adira',
//                labelStyle: TextStyle(fontFamily: "NunitoSans"),
//                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//              ),
//              keyboardType: TextInputType.text,
//              textCapitalization: TextCapitalization.sentences,
//              validator: (e) {
//                if (e.isEmpty) {
//                  return "Tidak boleh kosong";
//                }else{
//                  return null;
//                }},
//              onSaved: (e) => jenisPembayaran = e,
//            ),
//          ],
//        ),
//      ),
//      bottomNavigationBar: BottomAppBar(
//        child: RaisedButton(
//          padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
//          onPressed: (){
//            widget.onStepContinue();
//          },
//          shape: RoundedRectangleBorder(
//            borderRadius: new BorderRadius.circular(25.0),),
//          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text('Selanjutnya',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black))
//            ],
//          ),color: myPrimaryColor,
//        ),
//      ),
//    );
  }
}
