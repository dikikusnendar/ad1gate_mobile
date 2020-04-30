import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/db_helper/database_helper.dart';
import 'package:adira_finance/resources/submit_order_api_provider.dart';
import 'package:adira_finance/views/detail_draft.dart';
import 'package:adira_finance/views/form_edit_draft.dart';
import 'package:adira_finance/views/home.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'submit_page.dart';
import 'detail_data_transaksional.dart';

class DraftPage extends StatefulWidget {
//  final VoidCallback showDialog;
//  const DraftPage({this.showDialog});
//  final String title;
//  final Function onMapTap;
//  DraftPage(this.title, this.onMapTap);
  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  Screen size;
  var _newData = [];
  TextEditingController editingController = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  DbHelper _dbHelper = DbHelper();
  var _getDataProcess = false;
  var _listDraftData = [];
  SubmitOrderForm _submitOrderForm = SubmitOrderForm();

  @override
  void initState() {
    super.initState();
    _getDraft();
  }

  onSearchTextChanged(String text) async {
    _newData.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _listDraftData.forEach((dataNasabah) {
      if (dataNasabah['LastName'].toLowerCase().contains(text) || dataNasabah['KTP_No'].toLowerCase().contains(text)){
        setState(() {
          _newData.add(dataNasabah);
        });
      }
    });
  }

  _getDraft() async{
    setState(() {
      _getDataProcess = true;
    });
    var _result = await _dbHelper.getDraft();
    for(var i=0; i < _result.length; i++){
      _listDraftData.add(_result[i]);
    }
    setState(() {
      _getDataProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Draft",style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        actions: <Widget>[
//          FlatButton(
//              onPressed: (){
//                showMyDialog();
//              },
//              child: Text('Kirim Semua',
//                  style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)
//              )
//          )
        ],
      ),
      body: Theme(
        data:ThemeData(primaryColor: Colors.black),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: size.hp(1.5),horizontal: size.wp(2)),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: new InputDecoration(
                    labelText: 'Cari sekarang',
                    labelStyle: TextStyle(fontFamily: "NunitoSans",color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    suffixIcon: Icon(Icons.search)
                ),
                controller: editingController,
                onChanged: onSearchTextChanged,
              ),
              Expanded(
                  child:
                  _getDataProcess
                      ?
                  Center(
                    child: Text("Tidak ada draft tersimpan",style: TextStyle(fontFamily: "NunitoSansSemiBold",fontSize: 18)),
                  )
                      :
                  _newData != null && _newData.length != 0
                      ?
                  ListView.builder(
                    itemBuilder: (context,index){
                      return
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    FormEditDraft(id: _newData[index]['id'])));
//                            Navigator.of(context).push(
//                                MaterialPageRoute(builder: (context) =>
//                                    DetailDraftPage(listDraftData: _newData[index]))).then((val)=>val?_getDraft() : null);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.hp(2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    _newData[index]['LastName'],
                                    style: TextStyle(fontFamily: 'NunitoSansSemiBold')
                                ),
                                Text(
                                    _newData[index]['KTP_No'],
                                    style: TextStyle(fontFamily: 'NunitoSans')
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                    itemCount: _newData.length,
                    padding: EdgeInsets.only(top: size.hp(2),left: size.wp(3),right: size.wp(3)),
                  )
                      :
                  ListView.builder(
                    itemBuilder: (context,index){
                      return
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    FormEditDraft(id: _listDraftData[index]['id'])));
//                            Navigator.of(context).push(
//                                MaterialPageRoute(builder: (context) =>
//                                    DetailDraftPage(listDraftData: _listDraftData[index]))).then((val)=>val?_getDraft() : null);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.hp(2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    _listDraftData[index]['LastName'],
                                    style: TextStyle(fontFamily: 'NunitoSansSemiBold')
                                ),
                                Text(
                                    _listDraftData[index]['KTP_No'],
                                    style: TextStyle(fontFamily: 'NunitoSans')
                                )
                              ],
                            ),
                          ),
                        );
                    },
                    itemCount: _listDraftData.length,
                    padding: EdgeInsets.only(top: size.hp(2),left: size.wp(3),right: size.wp(3)),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  showMyDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text("Anda yakin untuk mengajukan kredit ini?",style: TextStyle(fontFamily: "NunitoSans")),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    _prosesAndSend();
                    Navigator.pop(context);
                  },
                  child: Text("Lanjutkan",style: TextStyle(fontFamily: "NunitoSansBold",color: yellow))),
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Batal",style: TextStyle(fontFamily: "NunitoSansBold",color: yellow))),
            ],
          );
        }
    );
  }


  _prosesAndSend() async{
    setState(() {
      _getDataProcess = true;
    });
    for(var i=0; i < _listDraftData.length; i++){
      int _id = _listDraftData[i]['id'];
      var _body = {
        "id":_listDraftData[i]['id'],
        "DlcCode": _listDraftData[i]['DlcCode'],
        "BranchID": _listDraftData[i]['BranchID'],
        "KTP_No": _listDraftData[i]['KTP_No'],
        "FirstName": "",
        "LastName": _listDraftData[i]['LastName'],
        "MidName": "",
        "BirthPlace": _listDraftData[i]['BirthPlace'],
        "BirthDate": _listDraftData[i]['BirthDate'],
        "MarriageStatus": _listDraftData[i]['MarriageStatus'],
        "KTP_Address": _listDraftData[i]['KTP_Address'],
        "KTP_RT": _listDraftData[i]['KTP_RT'],
        "KTP_RW": _listDraftData[i]['KTP_RW'],
        "KTP_Kelurahan": _listDraftData[i]['KTP_Kelurahan_Id'],
        "KTP_Kecamatan": _listDraftData[i]['KTP_Kecamatan_Id'],
        "KTP_KabKota": _listDraftData[i]['KTP_Kab_Kota_Id'],
        "KTP_Provinsi": _listDraftData[i]['KTP_Provinsi_Id'],
        "KTP_ZipCode": _listDraftData[i]['KTP_ZipCode'],
        "IsSameLifeAddress": _listDraftData[i]['IsSameLifeAddress'],
        "Address": _listDraftData[i]['Address'],
        "RT": _listDraftData[i]['RT'],
        "RW": _listDraftData[i]['RW'],
        "Kelurahan": _listDraftData[i]['Kelurahan_Id'],
        "Kecamatan": _listDraftData[i]['Kecamatan_Id'],
        "Kab_Kota": _listDraftData[i]['Kab_Kota_Id'],
        "Provinsi": _listDraftData[i]['Provinsi_Id'],
        "ZipCode": _listDraftData[i]['ZipCode'],
        "Survey_Address": _listDraftData[i]['Survey_Address'],
        "Phone_No": _listDraftData[i]['Phone_No'],
        "Spouse_FirstName": "",
        "Spouse_LastName": "",
        "Maiden_FirstName": "",
        "Maiden_LastName": "",
        "Jenis_Kendaraan": _listDraftData[i]['Jenis_Kendaraan_Id'],
        "Merk_Kendaraan": _listDraftData[i]['Merk_Kendaraan_iD'],
        "Type_kendaraan": _listDraftData[i]['Type_kendaraan_iD'],
        "Model_Kendaraan": _listDraftData[i]['Model_Kendaraan_Id'],
        "Tahun_Kendaraan": _listDraftData[i]['Tahun_Kendaraan'],
        "OTR": _listDraftData[i]['OTR'],
        "Tenor": _listDraftData[i]['Tenor'],
        "Gross_DP": _listDraftData[i]['Gross_DP'],
        "NET_DP": _listDraftData[i]['NET_DP'],
        "Installment": _listDraftData[i]['Installment'],
        "SurveyDate": _listDraftData[i]['SurveyDate'],
        "DLC_Note": _listDraftData[i]['DLC_Note'],
        "Gender": _listDraftData[i]['Gender_Id'],
        "HP_No": _listDraftData[i]['HP_No'],
        "Jenis_Angsuran": "",
        "LeaseType": "",
        "Jenis_Pembiayaan": _listDraftData[i]['Jenis_Pembiayaan_Id'],
        "BPKB_Name": _listDraftData[i]['BPKB_Name'],
        "Eff_Rate": 0,
        "Flat_rate": 0,
        "Pekerjaan": _listDraftData[i]['Pekerjaan_Id'],
        "Purpose": "",
        "CreateUserID": _listDraftData[i]['CreateUserID'],
        "Longtitude": _listDraftData[i]['Longtitude'],
        "Latitude": _listDraftData[i]['Latitude'],
        "JenisSurvey": _listDraftData[i]['JenisSurvey_Id'],
      };
      var _result = await _submitOrderForm.submitOrder(_body);
      if(_result['status']){
        _dbHelper.deleteRowDraft(_id);
      }
      else{
        setState(() {
          _getDataProcess = false;
        });
        return;
      }
    }
    setState(() {
      _getDataProcess = false;
    });
    _showSnackBar("All data Send");
  }

//  _navigateAndDisplaySelection(BuildContext context, DataModel listDraft,int idHalaman,int index) async {
//    // Navigator.push returns a Future that completes after calling
//    // Navigator.pop on the Selection Screen.
//    final result = await Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => DetailTransaksional(listDraft,idHalaman,index)),
//    );
//    _showSnackBar("Data berhasil dikirim");
//    clearListIndex(result);
//  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

}
