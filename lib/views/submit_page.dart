import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/main.dart';
import 'package:adira_finance/model/submit_order_model.dart';
import 'package:adira_finance/resources/get_data_tracking_api_provider.dart';
import 'package:adira_finance/views/form_transaksional_page.dart';
import 'package:flutter/material.dart';

import 'detail_data_transaksional.dart';
import 'dialog_redeem_voucher.dart';

class SubmitPage extends StatefulWidget {
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {

  Screen size;
  TextEditingController editingController = TextEditingController();
  String filter;
  var _listSubmitOrderList = [];
  List<ResultSubmitOrder> _dataSUbmitOrder = [];
  GetDataTrackingApiProvider _getDataTrackingApiProvider;
  var _loadData = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _status;

  @override
  void initState() {
    super.initState();
//    prosesData();
    _getDataTrackingApiProvider = GetDataTrackingApiProvider();
    _getListDataSubmitOrder();
  }

  _getListDataSubmitOrder() async{
    setState(() {
      _loadData = true;
      _dataSUbmitOrder.clear();
    });
    try{
      var _result = await _getDataTrackingApiProvider.getAllListDataSubmitOrder();
      for(int i=0; i <_result.listResultSumbitOrder.length; i++){
        _dataSUbmitOrder.add(_result.listResultSumbitOrder[i]);
      }
      setState(() {
        _loadData = false;
      });
    }
    catch(e){
      setState(() {
        _loadData = false;
      });
      _showSnackBar(e.toString());
    }
  }

  _getListDataSUbmitOrderBySearch(String query) async{
    setState(() {
      _loadData = true;
      _dataSUbmitOrder.clear();
    });
    try{
      var _result = await _getDataTrackingApiProvider.getListDataSubmitOrderBySearch(query);
      for(int i=0; i <_result.listResultSumbitOrder.length; i++){
        _dataSUbmitOrder.add(_result.listResultSumbitOrder[i]);
      }
      setState(() {
        _loadData = false;
      });
    }
    catch(e){
      setState(() {
        _loadData = false;
      });
      _showSnackBar(e.toString());
    }
  }


  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(
        SnackBar(content: new Text(text,style: TextStyle(
            fontFamily: "NunitoSans",color: Colors.white)),
          behavior: SnackBarBehavior.floating,backgroundColor: Colors.black,));
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Theme(
        data:ThemeData(primaryColor: Colors.black),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: size.hp(1.5),horizontal: size.wp(2)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: size.wp(1.5),right: size.wp(1.5)),
                child: TextFormField(
                  decoration: new InputDecoration(
                      labelText: 'Cari sekarang',
                      labelStyle: TextStyle(fontFamily: "NunitoSans",color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: Icon(Icons.search)
                  ),
                  controller: editingController,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (e){
                    _getListDataSUbmitOrderBySearch(e);
                  },
                ),
              ),
              Expanded(
                  child:
                  _loadData
                      ?
                  Center(child: CircularProgressIndicator())
                      :
                  ListView.builder(
                    itemBuilder: (context,index){
                      print(" cek status ${_dataSUbmitOrder[index].Status}");
                      if(_dataSUbmitOrder[index].Status != null){
                        _status = _dataSUbmitOrder[index].Status;
                      }
                      else{
                        _status = "";
                      }
                      return
                        InkWell(
                          onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  DetailTransaksional(resultSubmitOrder: _dataSUbmitOrder[index])));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.hp(1)),
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex:2,
                                        child:
                                        _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "002"||
                                            _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "004"
                                            ?
                                        Image.asset("img/motorcycle.webp")
                                            :
                                        _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "001"||
                                            _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "003"
                                            ?
                                        Image.asset("img/car.webp")
                                            :
                                        Image.asset("img/smartphone.webp")
                                    ),
                                    Expanded(child: SizedBox(width: 6),flex: 0,),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              _dataSUbmitOrder[index].lastName,
                                              style: TextStyle(fontFamily: 'NunitoSansBold')
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                              _dataSUbmitOrder[index].Jenis_Kendaraan_ID != null
                                                  ?
                                              _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "001"|| _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "003"
                                                  ?
                                              "Mobil"
                                                  :
                                              _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "002"|| _dataSUbmitOrder[index].Jenis_Kendaraan_ID == "004"
                                                  ?
                                              "Motor"
                                                  :
                                              "Durable"
                                                  :
                                              "",
                                              style: TextStyle(fontFamily: 'NunitoSans')
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                              _dataSUbmitOrder[index].Type_kendaraan != null ? _dataSUbmitOrder[index].Type_kendaraan:"",
                                              style: TextStyle(fontFamily: 'NunitoSans')
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: <Widget>[
                                              Text("${_dataSUbmitOrder[index].Tenor}",
                                                  style: TextStyle(fontFamily: 'NunitoSansBold',color: Color(0xff56cf00))
                                              ),
                                              SizedBox(width: 4),
                                              Text("Bulan",style: TextStyle(fontFamily: "NunitoSansBold",color: Color(0xff56cf00)))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 30,
                                        width: MediaQuery.of(context).size.width/5,
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: _status == "NVER" ? myPrimaryColor : Color(0xff80eb34),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Center(
                                          child: Text(_dataSUbmitOrder[index].Remark != null ? _dataSUbmitOrder[index].Remark:""),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                    },
                    itemCount: _dataSUbmitOrder.length,
                    padding: EdgeInsets.only(top: size.hp(2),left: size.wp(2),right: size.wp(2)),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

