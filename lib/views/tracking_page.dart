import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/resources/get_data_tracking_api_provider.dart';
import 'package:adira_finance/views/tracking_list_by_status_order_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'list_tracking_by_status_order_except_all.dart';
import 'search_delegate_dealer_cabang.dart';

class TrackingPageTab extends StatefulWidget {
  @override
  _TrackingPageTabState createState() => _TrackingPageTabState();
}

class _TrackingPageTabState extends State<TrackingPageTab> {

  final _controllerDealerCabang = TextEditingController();
  var _autoValidate = false;
  SearchDealerDelegate _searchDealerDelegate;
  var _dealerCabang,_startDateTracking,_endDateTracking;
  bool _validate = false;
  GetDataTrackingApiProvider _getDataTrackingApiProvider;
  var _isListDealerKosong = false;
  var _enableSearchListDealer = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();

  var _listDealerCabang =[];
  var _listStatusOrder = [];

  var _tracking = [
    {
      "id":1,
      "title":"Order"
    },
    {
      "id":2,
      "title":"PO"
    },
    {
      "id":3,
      "title":"Pencairan Produk"
    },
    {
      "id":4,
      "title":"Sudah PPD"
    }
    ];

  var _listTrackingByMonth = [];

  var _trackingSelected,_statusOrderSelectedByOrder,_statusOrderSelectedByPO,
      _statusOrderSelectedByPencarianProduk,_statusOrderSelectedBySudahPPD,_monthSelected;
  var _statusOrderSelected,_idBranchSelected;

  DateTrackingByMonth _trackingByMonthSelected;

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.only(top: 16,right: 16,left: 16),
          children: <Widget>[
            FocusScope(
              node: FocusScopeNode(),
              child: TextFormField(
                enableInteractiveSelection: false,
                autovalidate: _autoValidate,
                controller: _controllerDealerCabang,
                decoration: new InputDecoration(
                  labelText: _isListDealerKosong ? 'Dealer Tidak Tersedia' : 'Dealer Cabang Adira',
                  labelStyle: TextStyle(fontFamily: "NunitoSans"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onTap: (){
                  showSearch(context: context, delegate: _searchDealerDelegate);
                },
                validator: (e) {
                  if (e.isEmpty) {
                    return "Tidak boleh kosong";
                  }
                  else{
                    return null;
                  }},
                onSaved: (e) => _dealerCabang = e,
                enabled: _enableSearchListDealer,
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _trackingSelected,
              onChanged: (String newVal) {
                setState(() {
                  _trackingSelected = newVal;
                });
                _getStatusOrder(_trackingSelected);
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih tracking";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tracking',
                  labelStyle: TextStyle(fontFamily: 'NunitoSans'),
                  contentPadding: EdgeInsets.symmetric( horizontal: 10)
              ),
              items:
              _tracking.map((item) {
                return DropdownMenuItem<String>(
                  value: item['id'].toString(),
                  child: Text(
                    item['title'],
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _statusOrderSelected,
              onChanged: (String newVal) {
                setState(() {
                  _statusOrderSelected = newVal;
                });
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih Status Order";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status Order',
                  labelStyle: TextStyle(fontFamily: 'NunitoSans'),
                  contentPadding: EdgeInsets.symmetric( horizontal: 10)
              ),
              items:
              _listStatusOrder.map((item) {
                return DropdownMenuItem<String>(
                  value: item['Value'].toString(),
                  child: Text(
                    item['StatusName'],
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                      activeColor: myPrimaryColor,
                    ),
                    Text("Tracking bulanan",style: TextStyle(fontFamily: "NunitoSans")),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                      activeColor: myPrimaryColor,
                    ),
                    Text("Tracking harian",style: TextStyle(fontFamily: "NunitoSans")),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _trackingByMonth
                ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date Tracking',
                        labelStyle: TextStyle(fontFamily: "NunitoSans"),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        errorText: _validate
                            ?
                        'Format tanggal Salah'
                            :
                        _validasiTanggal
                            ?
                        "Tidak bisa tracking > 31 hari"
                            :
                        null,
                      ),
                      child: Text(_startDateTracking,style: TextStyle(fontSize: 16,fontFamily: "NunitoSans")),
                    ),
                    onTap: () {
                      _selectStartTracking(context);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date Tracking',
                        labelStyle: TextStyle(fontFamily: "NunitoSans"),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        errorText:
                        _validate
                            ?
                        'Format tanggal Salah'
                            :
                        _validasiTanggal
                            ?
                        "Tidak bisa tracking > 31 hari"
                            :
                        null,
                      ),
                      child: Text(_endDateTracking,style: TextStyle(fontSize: 16,fontFamily: "NunitoSans")),
                    ),
                    onTap: () {
                      _selectEndDateTracking(context);
                    },
                  ),
                ),
              ],
            )
                :
            DropdownButtonFormField<DateTrackingByMonth>(
              value: _trackingByMonthSelected,
              onChanged: (DateTrackingByMonth newVal) {
                setState(() {
                  _trackingByMonthSelected = newVal;
                });
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih tracking";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tracking By Month',
                  labelStyle: TextStyle(fontFamily: 'NunitoSans'),
                  contentPadding: EdgeInsets.symmetric( horizontal: 10)
              ),
              items:
              _listDateTrackingByMonth.map((DateTrackingByMonth user) {
                return new DropdownMenuItem<DateTrackingByMonth>(
                  value: user,
                  child: new Text(
                    user.titleMonth,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
            onPressed: (){
              check();
            },
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Cari',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black))
              ],
            ),color: myPrimaryColor,
          ),
        ),
        elevation: 0.0,
        color: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDataTrackingApiProvider = GetDataTrackingApiProvider();
    cekDateTime();
    setState(() {
      _trackingSelected = _tracking[0]['id'].toString();
    });
    _getBranchByDLC();
    _getStatusOrder(_trackingSelected);
  }

  _getBranchByDLC() async{
    var _result = await _getDataTrackingApiProvider.getBranchByDLC();
    if(_result['status']){
      setState(() {
        _listDealerCabang = _result['listBranch'];
        _enableSearchListDealer = true;
      });
      _searchDealerDelegate = SearchDealerDelegate(_listDealerCabang,setValue);
    }
    else{
      if(_result['message']== "0"){
        setState(() {
          _isListDealerKosong = true;
          _enableSearchListDealer = false;
        });
        _showSnackBar("Dealer Tidak Tersedia");
      }
      else{
        setState(() {
          _isListDealerKosong = true;
          _enableSearchListDealer = false;
        });
        _showSnackBar(_result['message']);
      }
    }
  }

  int _radioValue = 0;
  DateTrackingByMonth _dateTrackingByMonth;
  List<DateTrackingByMonth> _listDateTrackingByMonth = [];

  cekDateTime(){

    var now = new DateTime.now();
    var formatter = new DateFormat('d-M-yyyy');
    String formatted = formatter.format(now);
    setState(() {
      _startDate = DateTime.now();
      _endDate = DateTime.now();
      _startDateTracking = formatted;
      _endDateTracking = formatted;
    });

    var _formatter = DateFormat('MMMM');
    String _monthFormatted = _formatter.format(DateTime.now());
    _listTrackingByMonth.add({"id":DateTime.now().month,"titleMonth":_monthFormatted,"titleYear":DateTime.now().year});
    for( int i = 1; i<3; i++){
      var _date = DateTime.now();
      var _perMonth = DateTime(_date.year,_date.month-i,_date.day);
      var _testGetMonth = _perMonth.month;
      var _testThn = _perMonth.year;
      String _trackingMonthFormated = _formatter.format(_perMonth);
      _listTrackingByMonth.add({"id":_testGetMonth,"titleMonth":_trackingMonthFormated,"titleYear":_testThn});
    }

    for(var u in _listTrackingByMonth){
      _dateTrackingByMonth = DateTrackingByMonth(u['id'], u['titleMonth'], u['titleYear']);
      _listDateTrackingByMonth.add(_dateTrackingByMonth);
    }
  }

  setValue(Map value){
    print(value['SZBRID']);
    setState(() {
      _controllerDealerCabang.text = value['SZBRANCHNAME'];
      _idBranchSelected = value['SZBRID'];
    });
  }

  Screen size;

  var hariIni = DateTime.now().day;
  var bulanIni = DateTime.now().month;
  var _startDate,_endDate;
  var _validasiTanggal = false;

  Future<Null> _selectStartTracking(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1965,bulanIni,hariIni),
        lastDate: DateTime.now());
    if(picked != null){
      var formatter = new DateFormat('d-M-yyyy');
      setState(() {
        _startDate = picked;
        _startDateTracking = formatter.format(picked);
      });
      if(_startDate != null && _endDate != null){
        print(_endDate.difference(_startDate).inDays);
        var _different = _endDate.difference(_startDate).inDays;
        if(_different < 0){
          print("format pilih tanggal salah");
          setState(() {
            _validate = true;
          });
        }
        else if( _different > 31){
          print("Tidak bisa tracking > 31 hari");
          setState(() {
            if(_validate) setState(() {
              _validate = false;
            });
            _validasiTanggal = true;
          });
        }
        else{
          setState(() {
            _validate = false;
            _validasiTanggal = false;
          });
        }
      }
    }
  }

  Future<Null> _selectEndDateTracking(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1965,bulanIni,hariIni),
        lastDate: DateTime.now());
    if(picked != null){
      var formatter = new DateFormat('d-M-yyyy');
      setState(() {
        _endDate = picked;
        _endDateTracking = formatter.format(picked);
      });
      if(_startDate != null && _endDate != null){
        print(_endDate.difference(_startDate).inDays);
        var _different = _endDate.difference(_startDate).inDays;
        if(_different < 0){
          print("format pilih tanggal salah");
          setState(() {
            _validate = true;
          });
        }
        else if( _different > 31){
          print("Tidak bisa tracking > 31 hari");
          setState(() {
            if(_validate) setState(() {
              _validate = false;
            });
            _validasiTanggal = true;
          });
        }
        else{
          setState(() {
            _validate = false;
            _validasiTanggal = false;
          });
        }
      }
    }
  }

  bool _trackingByMonth = false;

  void _handleRadioValueChange(int value){
    setState(() {
      _radioValue = value;
    });
    if(_radioValue == 1){
      setState(() {
        _trackingByMonth = true;
      });
    }else{
      setState(() {
        _trackingByMonth = false;
      });
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(
        SnackBar(content: new Text(text,style: TextStyle(
            fontFamily: "NunitoSans",color: Colors.black)),
          behavior: SnackBarBehavior.floating,backgroundColor: Colors.black,));
  }

  _getStatusOrder(String idTracking) async{
    print("cek tracking selected $idTracking");
    setState(() {
      _listStatusOrder.clear();
      _statusOrderSelected = null;
    });
    var _result = await _getDataTrackingApiProvider.getStatusOrder(idTracking);
    if(_result['status']){
      setState(() {
        _listStatusOrder = _result['listStatusOrder'];
      });
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _searchTracking();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _searchTracking(){
    print("Cek idDealerSelected $_idBranchSelected");
    print("cek trackingSelected $_trackingSelected");
    print("cek statusOrderSeleceted $_statusOrderSelected");
    var _date = DateTime(_trackingByMonthSelected.titleYear,_trackingByMonthSelected.id+1,0);
    if(_radioValue == 0){
      if(_trackingByMonthSelected.id == DateTime.now().month){
        var _startDateTrackingByMonth = "1-${_trackingByMonthSelected.id}-${_trackingByMonthSelected.titleYear}";
        var _dateTimeNow = DateTime.now();
        var _formatter = DateFormat('d-M-yyyy');
        String _monthFormatted = _formatter.format(_dateTimeNow);
        var _endDateTrackingByMonth = _monthFormatted;
        if(_statusOrderSelected == "ALL"){
          print("cek idBranch $_idBranchSelected");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListTrackingByAllStatusOrder(
                endDate: _endDateTrackingByMonth,
                startDate: _startDateTrackingByMonth,
                branchId: _idBranchSelected,
                trackingId: _trackingSelected,
                statusOrder: _statusOrderSelected,
              )));
        }
        else{
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListTrackingByCategory(
                endDate: _endDateTrackingByMonth,
                startDate: _startDateTrackingByMonth,
                branchId: _idBranchSelected,
                trackingId: _trackingSelected,
                statusOrder: _statusOrderSelected,
              )));
        }
        print("_startDateTrackingByMonth radio value 0 $_startDateTrackingByMonth");
        print("_endDateTrackingByMonth radio value 0 $_endDateTrackingByMonth");
      }
      else{
        var _startDateTrackingByMonth = "1-${_trackingByMonthSelected.id}-${_trackingByMonthSelected.titleYear}";
        var _endDateTrackingByMonth = "${_date.day}-${_trackingByMonthSelected.id}-${_trackingByMonthSelected.titleYear}";
        if(_statusOrderSelected == "ALL"){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListTrackingByAllStatusOrder(
                endDate: _endDateTrackingByMonth,
                startDate: _startDateTrackingByMonth,
                branchId: _idBranchSelected,
                trackingId: _trackingSelected,
                statusOrder: _statusOrderSelected,
              )
          ));
        }
        else{
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListTrackingByCategory(
                endDate: _endDateTrackingByMonth,
                startDate: _startDateTrackingByMonth,
                branchId: _idBranchSelected,
                trackingId: _trackingSelected,
                statusOrder: _statusOrderSelected,
              )));
        }
        print("_startDateTrackingByMonth $_startDateTrackingByMonth");
        print("_endDateTrackingByMonth $_endDateTrackingByMonth");
      }
    }
    else{
      var _startDateTrackingByMonth = "1-${_trackingByMonthSelected.id}-${_trackingByMonthSelected.titleYear}";
      var _endDateTrackingByMonth = "${_date.day}-${_trackingByMonthSelected.id}-${_trackingByMonthSelected.titleYear}";
      if(_statusOrderSelected == "ALL"){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListTrackingByAllStatusOrder(
              endDate: _endDateTrackingByMonth,
              startDate: _startDateTrackingByMonth,
              branchId: _idBranchSelected,
              trackingId: _trackingSelected,
              statusOrder: _statusOrderSelected,
            )));
      }
      else{
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListTrackingByCategory(
              endDate: _endDateTrackingByMonth,
              startDate: _startDateTrackingByMonth,
              branchId: _idBranchSelected,
              trackingId: _trackingSelected,
              statusOrder: _statusOrderSelected,
            )));
      }
      print("_startDateTracking $_startDateTracking");
      print("_endDateTracking $_endDateTracking");
    }
  }
}


class DateTrackingByMonth{
  final int id;
  final String titleMonth;
  final int titleYear;
  DateTrackingByMonth(this.id, this.titleMonth, this.titleYear);
}