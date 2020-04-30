import 'package:adira_finance/main.dart';
import 'package:flutter/material.dart';

class SearchDealerCabang extends StatefulWidget {
  @override
  _SearchDealerCabangState createState() => _SearchDealerCabangState();
}

class _SearchDealerCabangState extends State<SearchDealerCabang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: new InputDecoration(
              labelText: 'Cari sekarang',
              labelStyle: TextStyle(fontFamily: "NunitoSans",color: Colors.black),
              suffixIcon: Icon(Icons.search)
          ),
        ),
        backgroundColor: myPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
