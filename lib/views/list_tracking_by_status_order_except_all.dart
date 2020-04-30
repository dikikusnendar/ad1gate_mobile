import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/resources/get_data_tracking_api_provider.dart';
import 'package:adira_finance/views/detail_tracking.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ListTrackingByCategory extends StatefulWidget {
  final String statusOrder,branchId,startDate,endDate,trackingId;
  const ListTrackingByCategory({Key key, this.statusOrder, this.branchId, this.startDate, this.endDate, this.trackingId}) : super(key: key);
  @override
  _ListTrackingByCategoryState createState() => _ListTrackingByCategoryState();
}

class _ListTrackingByCategoryState extends State<ListTrackingByCategory> {

  TextEditingController editingController = TextEditingController();
  GetDataTrackingApiProvider _getDataTrackingApiProvider;

  var _listDataTrackingExceptStatusOrderAll = [];
  var _loadDataTrackingExceptStatusOrderAll = false;

  List _newData = [];
  Screen size;

  onSearchTextChanged(String text) async {
    _newData.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _listDataTrackingExceptStatusOrderAll.forEach((dataNasabah) {
      if (dataNasabah['SZCUSTNAME'].toLowerCase().contains(text) || dataNasabah['SZAPPL_NO'].toLowerCase().contains(text)){
        setState(() {
          _newData.add(dataNasabah);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataTrackingApiProvider = GetDataTrackingApiProvider();
    _getDataTrackingByExceptStatusOrderAll();
  }

  _getDataTrackingByExceptStatusOrderAll() async{
    setState(() {
      _loadDataTrackingExceptStatusOrderAll = true;
    });
    var _result = await _getDataTrackingApiProvider.getTrackingByExceptStatusOrderAll(
        widget.statusOrder, widget.branchId, widget.startDate, widget.endDate,
        widget.trackingId);

    if(_result['status']){
      for(var i=0; i<_result["listDataTrackingByCategory"].length; i++){
        _listDataTrackingExceptStatusOrderAll.add(_result['listDataTrackingByCategory'][i]);
      }
      setState(() {
        _loadDataTrackingExceptStatusOrderAll = false;
      });
    }
    else{
      print(_result['Message']);
      setState(() {
        _loadDataTrackingExceptStatusOrderAll = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
        Text(
            "Tracking Order All Status",
            style: TextStyle(
                fontFamily: "NunitoSans",color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        leading:
        IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black),
            onPressed: ()
            {
              Navigator.pop(context);
            }
        ),
      ),
      body: Theme(
        data:ThemeData(primaryColor: Colors.black),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: size.hp(1.5),horizontal: size.wp(2)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: size.wp(1.5),right: size.wp(1.5)),
                child: TextField(
                  decoration: new InputDecoration(
                      labelText: 'Cari sekarang',
                      labelStyle: TextStyle(fontFamily: "NunitoSans",color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: Icon(Icons.search)
                  ),
                  controller: editingController,
                  onChanged: onSearchTextChanged,
                ),
              ),
              Expanded(
                child:
                _newData != null && _newData.length != 0
                    ?
                ListView.builder(
                  padding: EdgeInsets.only(top: 16,left: size.wp(1.5),right: size.wp(1.5)),
                    itemBuilder: (context,index){
                    var _dateTime = DateTime.parse(_newData[index]['SZORDERDATE']);
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailTracking(
                               branchId: widget.branchId,nomorApplication: _newData[index]['SZAPPL_NO'],
                              ))
                          );
                        },
                        child: Card(
                          elevation: 5.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: size.wp(2),vertical: size.hp(1.5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(child: Text("Tanggal Order",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                    Expanded(child: Text(":",style: TextStyle(fontFamily: "NunitoSans")),flex: 1,),
                                    Expanded(child: Text(_newData[index]['SZORDERDATE'],style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: Text("Nomor Aplikasi",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                    Expanded(child: Text(":",style: TextStyle(fontFamily: "NunitoSans")),flex: 1,),
                                    Expanded(child: Text(_newData[index]['SZAPPL_NO'],style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: Text("Nama Pemohon",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                    Expanded(child: Text(":",style: TextStyle(fontFamily: "NunitoSans")),flex: 1,),
                                    Expanded(child:  Text("${_newData[index]['SZCUSTNAME']}",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },itemCount: _newData.length,
                )
                    :
                _loadDataTrackingExceptStatusOrderAll
                    ?
                Center(
                  child: CircularProgressIndicator(),
                )
                    :
                ListView.builder(
                  padding: EdgeInsets.only(top: 16,left: size.wp(1.5),right: size.wp(1.5)),
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailTracking(
                              branchId: widget.branchId,
                              nomorApplication: _listDataTrackingExceptStatusOrderAll[index]['SZAPPL_NO'],
                            )));
                      },
                      child: Card(
                        elevation: 5.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: size.wp(2),vertical: size.hp(1.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text("Tanggal Order",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                  Expanded(child: Text(":",style: TextStyle(fontFamily: "NunitoSans")),flex: 1,),
                                  Expanded(child: Text(_listDataTrackingExceptStatusOrderAll[index]['SZORDERDATE'],style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text("Nomor Aplikasi",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                  Expanded(child: Text(":",style: TextStyle(fontFamily: "NunitoSans")),flex: 1,),
                                  Expanded(child: Text(_listDataTrackingExceptStatusOrderAll[index]['SZAPPL_NO'],style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text("Nama Pemohon",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                  Expanded(child: Text(":",style: TextStyle(fontFamily: "NunitoSans")),flex: 1,),
                                  Expanded(child:  Text("${_listDataTrackingExceptStatusOrderAll[index]['SZCUSTNAME']}",style: TextStyle(fontFamily: "NunitoSans")),flex: 5,),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },itemCount: _listDataTrackingExceptStatusOrderAll.length,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
