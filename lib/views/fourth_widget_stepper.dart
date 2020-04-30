import 'package:flutter/material.dart';

class FourthWidgetStepper extends StatefulWidget {
  @override
  _FourthWidgetStepperState createState() => _FourthWidgetStepperState();
}

class _FourthWidgetStepperState extends State<FourthWidgetStepper> {
  var _autoValidate = false;
  final _controllerNamaLengkapPasangan = new TextEditingController();

  var namaLengkapPasangan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text("Data Pendukung",style: TextStyle(fontFamily: "NunitoSans")),
            ),
            TextFormField(
              autovalidate: _autoValidate,
              controller: _controllerNamaLengkapPasangan,
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
              onSaved: (e) => namaLengkapPasangan = e,
            ),
          ],
        ),
      ),
    );
  }
}
