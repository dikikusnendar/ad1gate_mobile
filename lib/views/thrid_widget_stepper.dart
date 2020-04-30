import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ThirdWidgetStepper extends StatefulWidget {
  final VoidCallback onStepContinue,onStepCancel;

  const ThirdWidgetStepper(this.onStepContinue, this.onStepCancel);
  @override
  _ThirdWidgetStepperState createState() => _ThirdWidgetStepperState();
}

class _ThirdWidgetStepperState extends State<ThirdWidgetStepper> {
  var _autoValidate = false;
  final _controllerNomerKTP = new TextEditingController();

  var nomerKTP;
  Screen size;

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text("Data Nasabah",style: TextStyle(fontFamily: "NunitoSans")),
            ),
            TextFormField(
              autovalidate: _autoValidate,
              controller: _controllerNomerKTP,
              decoration: new InputDecoration(
                labelText: 'Dealer Cabang Adira',
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
              onSaved: (e) => nomerKTP = e,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
          onPressed: (){
            widget.onStepContinue();
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25.0),),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Selanjutnya',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black))
            ],
          ),color: myPrimaryColor,
        ),
      ),
    );
  }
}
