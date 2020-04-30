import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/main.dart';
import 'package:flutter/material.dart';

class FirstStepperWidget extends StatefulWidget {
  final VoidCallback onStepContinue,onStepCancel;
  const FirstStepperWidget({Key key, this.onStepContinue, this.onStepCancel}) : super(key: key);
  @override
  FirstStepperWidgetState createState() => FirstStepperWidgetState();
}

class FirstStepperWidgetState extends State<FirstStepperWidget> {
  var _autoValidate = false;
  final _controllerDealerCabang = new TextEditingController();
  final _key = new GlobalKey<FormState>();

  var dealerCabang;
  Screen size;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      widget.onStepContinue();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("Data Kendaraan",style: TextStyle(fontFamily: "NunitoSans")),
          ),
          SizedBox(height: size.hp(1)),
          TextFormField(
            autovalidate: _autoValidate,
            controller: _controllerDealerCabang,
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
            onSaved: (e) => dealerCabang = e,
          ),
          SizedBox(height: size.hp(1),),
        ],
      ),
    );
  }
}
