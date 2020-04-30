import 'package:flutter/material.dart';

enum DismissDialogTermAndCondition{
  cancel,
  discard,
  save,
}

class DialogTermAndCondition extends StatefulWidget {
  @override
  _DialogTermAndConditionState createState() => _DialogTermAndConditionState();
}

class _DialogTermAndConditionState extends State<DialogTermAndCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms And Conditions",style: TextStyle(fontFamily: "NunitoSans",color: Colors.black),),
      ),
    );
  }
}
