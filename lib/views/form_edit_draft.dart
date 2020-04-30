import 'package:adira_finance/custom/currency.dart';
import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/db_helper/database_helper.dart';
import 'package:adira_finance/main.dart';
import 'package:adira_finance/model/pekerjaan_model.dart';
import 'package:adira_finance/resources/check_valid_redeem_voucher.dart';
import 'package:adira_finance/resources/generate_date_api_provider.dart';
import 'package:adira_finance/resources/get_data_tracking_api_provider.dart';
import 'package:adira_finance/resources/submit_order_api_provider.dart';
import 'package:adira_finance/views/first_widget_stepper.dart';
import 'package:adira_finance/views/get_data_profile_by_ocr.dart';
import 'package:adira_finance/views/map_location.dart';
import 'package:adira_finance/views/search_kecamatan_page.dart';
import 'package:adira_finance/views/search_model_kendaraan.dart';
import 'package:adira_finance/views/second_widget_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class FormEditDraft extends StatefulWidget {

  final int id;
  const FormEditDraft({Key key, this.id}) : super(key: key);

  @override
  _FormEditDraftState createState() => _FormEditDraftState();
}

class _FormEditDraftState extends State<FormEditDraft> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DbHelper _dbHelper = DbHelper();
  var _loadData = false;
  int _currentStep = 0;
  VoidCallback _onStepContinue,_onStepCancel;
  Screen size;
  bool _autoValidate = false;
  bool _autoValidate2 = false;
  bool _autoValidate3 = false;
  bool _autoValidate4 = false;
  var _processSendData = false;

  //step 1
  final _controllerNomerKTP = TextEditingController();
  final _controllerNamaLengkap = TextEditingController();
  final _controllerTempatLahir = TextEditingController();
  final _controllerAlamatSurvey = TextEditingController();
  final _controllerRT = TextEditingController();
  final _controllerRW = TextEditingController();
  final _controllerKecamatan = TextEditingController();
  final _controllerKelurahan = TextEditingController();
  final _controllerKodePos = TextEditingController();
  final _controllerAlamatKTP = TextEditingController();
  final _controllerRtKtp = TextEditingController();
  final _controllerRwKtp = TextEditingController();
  final _controllerKecamatanKTP = TextEditingController();
  final _controllerKelurahanKTP = TextEditingController();
  final _controllerKodePosKTP = TextEditingController();
  final _controllerKodeArea = TextEditingController();
  final _controllerTlpnRumah = TextEditingController();
  final _controllerKodeNegara = TextEditingController();
  final _controllerNoHp = TextEditingController();
  final _controllerRedeemVoucher = TextEditingController();
  final _focusNodeNoKTP = FocusNode();
  final _focusNodeNamaLengkap = FocusNode();
  final _focusNodeTempatLahir = FocusNode();
  final _focusNodeAlamatSurvey = FocusNode();
  final _focusNodeRT = FocusNode();
  final _focusNodeRW = FocusNode();
  final _focusNodeAlamatKTP = FocusNode();
  final _focusNodeRtKtp = FocusNode();
  final _focusNodeRwKtp = FocusNode();
  final _focusNodeKodeArea = FocusNode();
  final _focusNodeTlpnRumah = FocusNode();
  final _focusNodeKodeNegara = FocusNode();
  final _focusNodeNoHp = FocusNode();
  final _focusNodeRedeemVoucher = FocusNode();
  var _thnLahir,_blnLahir,_tglLahir,_statusPernikahan;
  List<String> _listDateBirthdate = [];
  bool _validate = false;
  Gender _gender;
  var idKelurahan,idKecamatan,idKota,idKotaProvinsi;
  var idKelurahanKTP,idKecamatanKTP,idKotaKTP,idKotaProvinsiKTP;
  int _radioValue = 0;
  var _isProcessCheckVoucher = false;
  CheckValidRedeemVoucher _checkValidRedeemVoucher;
  ResultPekerjaan _resultPekerjaan;
  List<ResultPekerjaan> _listResultPekerjaan = [];

  //step 2
  final _controllerModelKendaraan = TextEditingController();
  final _controllerTipeKendaraan = TextEditingController();
  final _controllerMerkKendaraan = TextEditingController();
  final _controllerNamaPadaBPKB = TextEditingController();
  JenisKendaraan _jenisKendaraan;
  var _listTahunKendaraan =["Pilih jenis kendaraan terlebih dahulu"];
  List<String> _listTahunKendaraanBaru = [];
  List<String> _listTahunKendaraanBekas = [];
  var _tahunKendaraanDipilih,_tahunKendaraanDipilihBekas,_tahunKendaraanDipilihBaru;
  var idMerkKendaraan;
  var idTypeKendaraan;
  var idModelKendaraan;
  SubmitOrderForm _submitOrderForm;

  //step3
  JenisPembiayaan _jenisPembiayaan;
  final _controllerOTR = new TextEditingController();
  final _controllerAngsuran = new TextEditingController();
  final _controllerDP = TextEditingController();
  final _focusNodeOTR = FocusNode();
  final _focusNodeAngsuran = FocusNode();
  final _focusNodeDp = FocusNode();
  var _tenor;

  //step 4
  final _controllerNamaGadisIbuKandung = new TextEditingController();
  final _controllerCatatanDealer = new TextEditingController();
  final _controllerLocation = TextEditingController();
  final FocusNode _focusNodeNamaIbuKandung = FocusNode();
  final FocusNode _focusNodeCatatanDealer = FocusNode();
  PemilihanCaraSurvey _pemilihanCaraSurvey;
  GenerateDateApiProvider _genenerateDateApiProvider = GenerateDateApiProvider();
  GetDataTrackingApiProvider _getDataTrackingApiProvider = GetDataTrackingApiProvider();
  List _listDealerCabang =[];
  List<String> _dateListFix = [];
  List<String> _listHour = [];
  List<String> _listMinute = ["00","30"];
  Branch _pilihanCabang;
  String _surveyDateSelected,_surveyMenitSelected;
  var _surveyJamSelected;
  var _latitude,_longitude;
  List<Branch> _listBranch = [];

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Draft Edit and Send",style: TextStyle(fontFamily: "NunitoSans")),
        backgroundColor: myPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _loadData
          ?
      Center(child: CircularProgressIndicator())
          :
      Form(
          child: Theme(
            data: ThemeData(
              primaryColor: Color(0xff25ae88),
            ),
            child: Stepper(
              steps: <Step>[
                Step(
                  title: Text(''),
                  content: Form(child: _dataNasabahStepWidget(),key: formKeys[0]),
                  isActive: true,
                  state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
                ),
                Step(
                  title: Text(''),
                  content: Form(child: _dataKendaraanStepWidget(),key: formKeys[1],),
                  isActive: _currentStep >= 1,
                  state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
                ),
                Step(
                  title: Text(''),
                  content: Form(child: _dataPengajuanKredit(),key: formKeys[2]),
                  isActive: _currentStep >= 2,
                  state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
                ),
                Step(
                  title: Text(''),
                  content: Form(child: _dataLainStepWidget(),key: formKeys[3]),
                  isActive: _currentStep >= 3,
                  state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
                )
              ],
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepTapped: null,
              controlsBuilder: (BuildContext context, {
                VoidCallback onStepContinue,
                VoidCallback onStepCancel
              }){
                _onStepContinue = onStepContinue;
                _onStepCancel = onStepCancel;
                return SizedBox(
                  width: 0.0,height: 0.0,
                );
              },
              onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
              onStepContinue: (){
                setState(() => _currentStep += 1);
              },
            ),
          )
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          margin: EdgeInsets.only(left: size.wp(2.5),right: size.wp(2.5),bottom: size.hp(1),top: size.hp(1)),
          child: _currentStep == 0
              ?
          RaisedButton(
            padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
            onPressed: (){
              _check();
            },
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Selanjutnya',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black))
              ],
            ),color: myPrimaryColor,
          )
              :
          _currentStep < 3
              ?
          Row(children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),),
                onPressed: (){
                  _onStepCancel();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Kembali',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black),),
                  ],
                ),
                color: const Color(0xffe6e6e6),
              ),flex: 5,
            ),
            SizedBox(width: size.wp(2)),
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
                onPressed: (){
                  _check();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Selanjutnya',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black))
                  ],
                ),color: myPrimaryColor,
              ),flex: 5,
            ),
          ])
              :
          Row(children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),),
                onPressed: _onStepCancel,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Kembali',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black),),
                  ],
                ),
                color: const Color(0xffe6e6e6),
              ),flex: 5,
            ),
            SizedBox(width: size.wp(2)),
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
                onPressed: (){
                  _check();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Selesai',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black))
                  ],
                ),color: myPrimaryColor,
              ),flex: 5,
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
        _currentStep = 3;
      });
    _checkValidRedeemVoucher = CheckValidRedeemVoucher();
    _submitOrderForm = SubmitOrderForm();
    _processYear();
    _getAndSetDraft();
  }

  _getAndSetDraft() async{
    setState(() {
      _loadData = true;
    });
    var _result = await _dbHelper.getDraftWhereId(widget.id);
    setState(() {
      _controllerNomerKTP.text = _result[0]['KTP_No'];
      _controllerNamaLengkap.text = _result[0]['LastName'];
      _controllerTempatLahir.text = _result[0]['BirthPlace'];
      _controllerAlamatSurvey.text = _result[0]['Survey_Address'];
      _controllerRT.text = _result[0]['RT'];
      _controllerRW.text = _result[0]['RW'];
      _controllerKecamatan.text = _result[0]['Kecamatan'];
      idKecamatan = _result[0]['Kecamatan_Id'];
      _controllerKelurahan.text = _result[0]['Kelurahan'];
      idKelurahan = _result[0]['Kelurahan_Id'];
      _controllerKodePos.text = _result[0]['ZipCode'];
      idKota = _result[0]['Kab_Kota_Id'];
      idKotaProvinsi = _result[0]['Provinsi_Id'];
      _controllerAlamatKTP.text = _result[0]['KTP_Address'];
      _controllerRtKtp.text = _result[0]['KTP_RT'];
      _controllerRwKtp.text = _result[0]['KTP_RW'];
      _controllerKecamatanKTP.text = _result[0]['KTP_Kecamatan'];
      idKecamatanKTP = _result[0]['KTP_Kecamatan_Id'];
      _controllerKelurahanKTP.text = _result[0]['KTP_Kelurahan'];
      idKelurahanKTP = _result[0]['KTP_Kelurahan_Id'];
      _controllerKodePosKTP.text = _result[0]['KTP_ZipCode'];
      idKotaKTP = _result[0]['KTP_KabKota'];
      idKotaProvinsiKTP = _result[0]['KTP_Provinsi'];
      _statusPernikahan = _result[0]['MarriageStatus'];
      _controllerRedeemVoucher.text = _result[0]['KodeVoucher'];
      _controllerKodeNegara.text = "62";
      _controllerNoHp.text = _result[0]['HP_No'];
      _controllerModelKendaraan.text = _result[0]['Model_Kendaraan'];
      idModelKendaraan = _result[0]['Model_Kendaraan_Id'];
      _controllerMerkKendaraan.text = _result[0]['Merk_Kendaraan'];
      idMerkKendaraan = _result[0]['Merk_Kendaraan_Id'];
      _controllerTipeKendaraan.text = _result[0]['Type_kendaraan'];
      idTypeKendaraan = _result[0]['Type_kendaraan_iD'];
      _controllerNamaPadaBPKB.text = _result[0]['BPKB_Name'];
      _controllerOTR.text = _result[0]['OTR'];
      _controllerAngsuran.text = _result[0]['Installment'];
      _longitude = _result[0]['Longtitude'];
      _latitude = _result[0]['Latitude'];
      _controllerCatatanDealer.text = _result[0]['DLC_Note'];
      _controllerLocation.text = _result[0]['Location'];
      _controllerNamaGadisIbuKandung.text = _result[0]['Maiden_LastName'];
    });
    String _isSameLifeAddressString = _result[0]['IsSameLifeAddress'];
    bool _isSameLifeAddress = _isSameLifeAddressString.toLowerCase() == 'true';
    if(_isSameLifeAddress){
      setState(() {
        _radioValue = 0;
      });
    }
    else{
      setState(() {
        _radioValue = 1;
      });
    }
    _setBirthDate(_result[0]['BirthDate']);
    _setGender(_result[0]['Gender_Id']);
    _setTlpnRumah(_result[0]['Phone_No']);
    _getPekerjaan(_result[0]['Pekerjaan_Id']);
    _setJenisKendaraan(_result[0]['Jenis_Kendaraan_Id'],_result[0]['Tahun_Kendaraan']);
    _setJenisPembiayaan(_result[0]['Jenis_Pembiayaan_Id']);
    _setTenor(_result[0]['Tenor']);
    _setDP(_result[0]['Gross_DP'],_result[0]['Net_DP']);
    _setJenisSurvey(_result[0]['JenisSurvey_Id'],_result[0]['BranchID'],_result[0]['BranchName']);
    _setDateTimeSurvey(_result[0]['SurveyDate']);
  }

  _getPekerjaan(String code) async{
    var _result = await _dbHelper.getPekerjaan();
    for(var i=0; i<_result.resultListPekerjaan.length; i++){
      _listResultPekerjaan.add(_result.resultListPekerjaan[i]);
    }
    var _resultCode = await _dbHelper.getPekerjaanByCode(code);
    for(var i=0; i<_listResultPekerjaan.length; i++){
      if(_listResultPekerjaan[i].occupationCode == _resultCode.resultListPekerjaan[0].occupationCode){
        setState(() {
          _resultPekerjaan = _listResultPekerjaan[i];
        });
      }
    }
  }

  _setGender(String idGender){
    for(var i=0; i<_listGender.length; i++){
      if(_listGender[i].id == idGender){
        _gender = _listGender[i];
      }
    }
  }

  _setBirthDate(String birthDate){
    List<String> _splitBirtDateList = birthDate.split("-");
    _thnLahir = _splitBirtDateList[0];
    _blnLahir = _splitBirtDateList[1];
    _tglLahir = _splitBirtDateList[2];
  }

  _setTlpnRumah(String tlpnRumah){
    List<String> _splitTlpnRumah = tlpnRumah.split("-");
    _controllerKodeArea.text = _splitTlpnRumah[0];
    _controllerTlpnRumah.text = _splitTlpnRumah[1];
  }

  _setJenisKendaraan(String resultJenisKendaraan,String tahunKendaraan){
    for(var i =0; i < _listJenisKendaraan.length; i++){
      if(_listJenisKendaraan[i].id == resultJenisKendaraan){
        _jenisKendaraan = _listJenisKendaraan[i];
      }
    }
    _addTahunKendaraan();
    _setTahunKendaraan(_jenisKendaraan.id,tahunKendaraan);
  }

  _setTahunKendaraan(String jenisKendaraanId, String tahunKendaraan){
    if(jenisKendaraanId == "001" || jenisKendaraanId == "002"){
      for(var i=0; i<_listTahunKendaraanBaru.length; i++){
        if(_listTahunKendaraanBaru[i] == tahunKendaraan){
          setState(() {
            _tahunKendaraanDipilihBaru = tahunKendaraan;
          });
        }
      }
    }
    else{
      for(var i=0; i<_listTahunKendaraanBekas.length; i++){
        if(_listTahunKendaraanBekas[i] == tahunKendaraan){
          setState(() {
            _tahunKendaraanDipilihBekas = tahunKendaraan;
          });
        }
      }
    }
  }

  _setJenisPembiayaan(String jenisPembiayaanId){
    for(var i=0; i<_listJenisPembiayaan.length; i++){
      if(_listJenisPembiayaan[i]._id.toString() == jenisPembiayaanId){
        _jenisPembiayaan = _listJenisPembiayaan[i];
      }
    }
  }

  _setTenor(String tenor){
    for(var i=0; i < _listPilihanTenor.length; i++){
      if(_listPilihanTenor[i]== tenor){
        setState(() {
          _tenor = tenor;
        });
      }
    }
  }

  _setDP(String grossDP,String netDP){
    if(_jenisKendaraan.id == "001" || _jenisKendaraan.id == "002"){
      setState(() {
        _controllerDP.text = grossDP;
      });
    }
    else{
      _controllerDP.text = netDP;
    }
  }

  _setJenisSurvey(String jenisSurvey,String branchId,String branchName){
    int _jenisSurvey = int.parse(jenisSurvey);
    for(var i = 0; i < _listPemilihanCaraSurvey.length; i++){
      if(_listPemilihanCaraSurvey[i]._id == _jenisSurvey){
        _pemilihanCaraSurvey = _listPemilihanCaraSurvey[i];
      }
    }
    if(_pemilihanCaraSurvey._id == 2 || _pemilihanCaraSurvey._id == 4){
      Branch _branch = Branch(branchId, branchName);
      _listBranch.add(_branch);
      _pilihanCabang = _listBranch[0];
    }
  }


  _setDateTimeSurvey(String date){
    print(date);
    List _splitDateTime = date.split(" ");
    _dateListFix.add(_splitDateTime[0]);
    _surveyDateSelected = _dateListFix[0];
    String _time = _splitDateTime[1];
    List _splitTime = _time.split(":");
    _listHour.add(_splitTime[0]);
    _surveyJamSelected = _listHour[0];
    _surveyMenitSelected = _splitTime[1];
    setState(() {
      _loadData = false;
    });
  }

  _check(){
    final form = formKeys[_currentStep].currentState;
    if(_currentStep == 0){
      if(form.validate()){
        if(_cekTahun()){
          _validate = true;
        }
        else{
          form.save();
          _onStepContinue();
        }
      }
      else{
        setState(() {
          _autoValidate = true;
        });
      }
    }
    else if(_currentStep == 1){
      if(form.validate()){
        form.save();
        _onStepContinue();
      }
      else{
        setState(() {
          _autoValidate2 = true;
        });
      }
    }
    else if(_currentStep == 2){
      if(form.validate()){
        form.save();
        _onStepContinue();
      }
      else{
        setState(() {
          _autoValidate3 = true;
        });
      }
    }
    else{
      if(form.validate()){
        form.save();
        _showDialog();
      }else{
        setState(() {
          _autoValidate4 = true;
        });
      }
    }
  }

  setDataByOCR(List value){
    setState(() {
      _controllerNomerKTP.text = value[0];
      _controllerNamaLengkap.text = value[1];
      _controllerTempatLahir.text = value[2];
      _controllerAlamatSurvey.text = value[4];
      _controllerRT.text = value[5];
      _controllerRW.text = value[6];
    });
    _showSnackBar("Please check your data again");
  }

  String _textKota,_textProv;
  setValueKecamatan(Map value){
    setState(() {
      _controllerKecamatan.text = value['PARA_KECAMATAN_DESC'];
      _controllerKelurahan.text = value['PARA_KELURAHAN_DESC'];
      _controllerKodePos.text = value['PARA_KELURAHAN_ZIP_CODE'];
      _textKota = value['KAB_KOT_DESC'];
      _textProv = value['PROVINSI_DESC'];
      idKecamatan = value['PARA_KELURAHAN_ID_KEC'];
      idKelurahan = value['PARA_KELURAHAN_ID'];
      idKota = value['KAB_KOT_ID'];
      idKotaProvinsi = value['KAB_KOT_ID_PROV'];
    });
  }

  String _textKotaKTP,_textProvKTP;
  setValueKecamatanKTP(Map value){
    setState(() {
      _controllerKecamatanKTP.text = value['PARA_KECAMATAN_DESC'];
      _controllerKelurahanKTP.text = value['PARA_KELURAHAN_DESC'];
      _controllerKodePosKTP.text =  value['PARA_KELURAHAN_ZIP_CODE'];
      _textKotaKTP = value['KAB_KOT_DESC'];
      _textProvKTP= value['PROVINSI_DESC'];
      idKecamatanKTP = value['PARA_KELURAHAN_ID_KEC'];
      idKelurahanKTP = value['PRA_KELURAHAN_ID'];
      idKotaKTP = value['KAB_KOT_ID'];
      idKotaProvinsiKTP = value['KAB_KOT_ID_PROV'];
    });
  }

  _checkValidVoucher() async{
    if(_controllerRedeemVoucher.text.isNotEmpty && _controllerNomerKTP.text.isNotEmpty){
      setState(() {
        _isProcessCheckVoucher = true;
      });
      var _result = await _checkValidRedeemVoucher.checkRedeemVoucher(
          _controllerNomerKTP.text, _controllerRedeemVoucher.text);

      if(_result['status']){
        if(_result['IsValid'] == 1){
          setState(() {
            _isProcessCheckVoucher = false;
          });
          _showSnackBar("voucher valid ${_result['remark']}");
        }
        else{
          setState(() {
            _isProcessCheckVoucher = false;
          });
          _showSnackBar("voucher invalid ${_result['remark']}");
        }
      }
      else{
        setState(() {
          _isProcessCheckVoucher = false;
        });
        _showSnackBar(_result['message']);
      }
    }
    else{
      _showSnackBar("Please insert KTP number and voucher code");
    }
  }

  List<String> _listYear = [];

  _processYear() {
    var now = DateTime.now();
    var limitYearDown = now.year - 60;
    var limitYearUp = now.year - 21;

    for(var i = limitYearDown; i <= limitYearUp; i++){
      _listYear.add(i.toString());
    }

    for(var i = 1; i<=31; i++){
      _listDateBirthdate.add(i.toString());
    }
  }

  List _listMonth = [
    {
      "id":1,
      "month": "January"
    },
    {
      "id":2,
      "month": "February"
    },
    {
      "id":3,
      "month": "March"
    },
    {
      "id":4,
      "month": "April"
    },
    {
      "id":5,
      "month": "May"
    },
    {
      "id":6,
      "month": "June"
    },
    {
      "id":7,
      "month": "July"
    },
    {
      "id":8,
      "month": "August"
    },
    {
      "id":9,
      "month": "September"
    },
    {
      "id":10,
      "month": "October"
    },
    {
      "id":11,
      "month": "November"
    },
    {
      "id":12,
      "month": "December"
    }
  ];

  _processDay(){

    int thnLahirSelected = int.parse(_thnLahir);
    int blnLahirSelected;

    if(_blnLahir == "1"){
      blnLahirSelected = 2;
    }
    else if(_blnLahir == "2"){
      blnLahirSelected = 3;
    }
    else if(_blnLahir == "3"){
      blnLahirSelected = 4;
    }
    else if(_blnLahir == "4"){
      blnLahirSelected = 5;
    }
    else if(_blnLahir == "5"){
      blnLahirSelected = 6;
    }
    else if(_blnLahir == "6"){
      blnLahirSelected = 7;
    }
    else if(_blnLahir == "7"){
      blnLahirSelected = 8;
    }
    else if(_blnLahir == "8"){
      blnLahirSelected = 9;
    }
    else if(_blnLahir == "9"){
      blnLahirSelected = 10;
    }
    else if(_blnLahir == "10"){
      blnLahirSelected = 11;
    }
    else if(_blnLahir == "11"){
      blnLahirSelected = 12;
    }
    else if(_blnLahir == "12"){
      blnLahirSelected = 1;
    }
    var date = new DateTime(thnLahirSelected, blnLahirSelected, 0);
    print(date.day);

    setState(() {
      _listDateBirthdate.clear();
    });

    for (var i=1; i<= date.day; i++){
      _listDateBirthdate.add(i.toString());
    }
    _tglLahir = "1";
  }

  bool _cekTahun(){
    var dDay = new DateTime.now();
    var dateSelected = DateTime(int.parse(_thnLahir),int.parse(_blnLahir),int.parse(_tglLahir));
    Duration difference = dDay.difference(dateSelected);
    print(difference.inDays);
    if(difference.inDays < 7670){
      setState(() {
        _validate = true;
      });
      _showSnackBar("Data yang anda masukkan salah");
      return true;
    }else{
      setState(() {
        _validate = false;
      });
      return false;
    }
  }

  List<Gender> _listGender = <Gender>[Gender("01", "Pria"),Gender("02", "Wanita")];

  var _listStatusPernikahan = [
    {
      "id": "01",
      "statusKawin": "Kawin",
    },
    {
      "id": "02",
      "statusKawin": "Single",
    },
    {
      "id": "03",
      "statusKawin": "Duda/Janda Tanpa Anak",
    },
    {
      "id": "04",
      "statusKawin": "Duda/Janda Dgn Anak",
    },
    {
      "id": "99",
      "statusKawin": "Migrasi",
    }
  ];

  void _handleRadioValueChange(int value){
    setState(() {
      _radioValue = value;
    });
  }

  _cekZeroPhoneNumber(String zero){
    if(zero == "0"){
      _controllerNoHp.clear();
    }
    else{
      return;
    }
  }

  List<JenisKendaraan> _listJenisKendaraan = <JenisKendaraan>[
    JenisKendaraan("001", "Mobil Baru"),
    JenisKendaraan("002", "Motor Baru"),
    JenisKendaraan("003", "Mobil Bekas"),
    JenisKendaraan("004", "Motor Bekas"),
    JenisKendaraan("005", "Durable")
  ];

  _addTahunKendaraan(){
    print(_jenisKendaraan.id);
    var _tahunKendaraan = DateTime.now().year;

    if(_jenisKendaraan.id == "001" || _jenisKendaraan.id == "002"){
      setState(() {
        _listTahunKendaraanBaru.clear();
        _listTahunKendaraanBaru.add((_tahunKendaraan - 1).toString());
        _listTahunKendaraanBaru.add(_tahunKendaraan.toString());
        _listTahunKendaraanBaru.add((_tahunKendaraan + 1).toString());
      });
      print(_listTahunKendaraanBaru.length);
    }
    else {
      setState(() {
        _listTahunKendaraanBekas.clear();
      });
      for(int i = 0; i<= 10 ; i++){
        _listTahunKendaraanBekas.add((_tahunKendaraan - i).toString());
      }
    }
  }

  _setValueModel(Map _modelKendaraan){
    setState(() {
      idMerkKendaraan = _modelKendaraan['OBBR_CODE'];
      idTypeKendaraan = _modelKendaraan['OBTY_CODE'];
      idModelKendaraan = _modelKendaraan['OBMO_CODE'];
      _controllerModelKendaraan.text = _modelKendaraan['OBBR_DESC'];
      _controllerTipeKendaraan.text = _modelKendaraan['OBTY_DESC'];
      _controllerMerkKendaraan.text = _modelKendaraan['OBMO_DESC'];
    });
  }

  List<JenisPembiayaan> _listJenisPembiayaan = <JenisPembiayaan>[
    JenisPembiayaan(1, "Konvensional"),
    JenisPembiayaan(2, "Syariah"),
  ];
  var _listPilihanTenor = ["6","12","18","24","30","36","42","48","54","60","66","72","78","84","90"];

  List<PemilihanCaraSurvey> _listPemilihanCaraSurvey = [
    PemilihanCaraSurvey(1, "Auto Assign"),
    PemilihanCaraSurvey(2, "Pemilihan Cabang"),
    PemilihanCaraSurvey(3, "MKT Extend"),
    PemilihanCaraSurvey(4, "Submit To Action"),
  ];

  _getDateList(String branchId) async{
    if(_pemilihanCaraSurvey._id == 2){
      var _resultDate = await _dbHelper.getDateByBranchId(branchId);
      var _lisDateTemp = [];
      if(_lisDateTemp.isNotEmpty || _dateListFix.isNotEmpty){
        setState(() {
          _lisDateTemp.clear();
          _dateListFix.clear();
          _listHour.clear();
          _surveyDateSelected = null;
          _surveyJamSelected = null;
        });
        for(var i=0; i<_resultDate.length; i++){
          _lisDateTemp.add(_resultDate[i]['date']);
        }
        for(var i=0; i<_lisDateTemp.length;i++){
          if(!_dateListFix.contains(_lisDateTemp[i])){
            setState(() {
              _dateListFix.add(_lisDateTemp[i]);
            });
          }
        }
      }
      else{
        for(var i=0; i<_resultDate.length; i++){
          _lisDateTemp.add(_resultDate[i]['date']);
        }
        for(var i=0; i<_lisDateTemp.length;i++){
          if(!_dateListFix.contains(_lisDateTemp[i])){
            setState(() {
              _dateListFix.add(_lisDateTemp[i]);
            });
          }
        }
      }
    }
    else{
      setState(() {
        _dateListFix.clear();
        _listHour.clear();
        _surveyDateSelected = null;
        _surveyJamSelected = null;
      });
      var _now = DateTime.now();
      DateFormat _formatter = DateFormat("EEEE,dd-MM-yyyy");
      for(var i=0; i< 6; i++){
        var _date = DateTime(_now.year,_now.month,_now.day+i);
        String _dateSurvey = _formatter.format(_date);
        _dateListFix.add(_dateSurvey);
      }
    }
  }

  _getGenerateDate() async{
    if(_pemilihanCaraSurvey._id == 1){
      var _result = await _genenerateDateApiProvider.generateDatesByAutoAssign(
          _controllerKodePos.text, _controllerKelurahan.text.trim(), _jenisPembiayaan._id.toString());
      if(_result['status']){
        var _temp = [];
        setState(() {
          _temp.clear();
          _listDealerCabang.clear();
          _dateListFix.clear();
          _listHour.clear();
          _pilihanCabang = null;
          _surveyDateSelected = null;
          _surveyJamSelected = null;
          _pilihanCabang = null;
        });

        var _listDate = [];
        var _lisTimes = [];
        var _listDateAndTimeAutoAssign = [];

        for(var i=0; i<_result['listDateByAutoAsign'].length; i++){
          var _formatDate = _result['listDateByAutoAsign'][i]['dates'];
          print("cek date awal ${_result['listDateByAutoAsign'][i]['dates']}");
          var _dates = _formatDate.split(" ");
          _listDate.add(_dates[0]);
          print(_listDate[i]);
        }

        for(var i=0; i<_result['listDateByAutoAsign'].length; i++){
          var _formatTime = _result['listDateByAutoAsign'][i]['dates'];
          var _times = _formatTime.split(" ");
          _lisTimes.add(_times[1]);
        }

        for(var i=0; i<_result['listDateByAutoAsign'].length; i++){
          var _data = {
            "tanggal": _listDate[i],
            "jam":_lisTimes[i]
          };
          _listDateAndTimeAutoAssign.add(_data);
          print(_listDateAndTimeAutoAssign[i]);
        }

        var _checkDateAutoAssign = await _dbHelper.getDateTimeAutoAssign();
        if(_checkDateAutoAssign.isNotEmpty || _checkDateAutoAssign !=  null){
          await _dbHelper.deleteDateAutoAssign();
          await _dbHelper.addDateAutoAssign(_listDateAndTimeAutoAssign);
        }
        else{
          await _dbHelper.addDateAutoAssign(_listDateAndTimeAutoAssign);
        }

        var _resultDateAutoAssign = await _dbHelper.getDateAutoAssign();
        for(var i=0; i < _resultDateAutoAssign.length; i++){
          if(!_dateListFix.contains(_resultDateAutoAssign[i]['tanggal'])){
            setState(() {
              _dateListFix.add(_resultDateAutoAssign[i]['tanggal']);
            });
          }
        }
      }
      else{
        _showSnackBar(_result['message']);
      }
    }
    else if(_pemilihanCaraSurvey._id == 2){
      print("dijalankan");
      var _result = await _genenerateDateApiProvider.generateDatesByPemilihanCabang(
          _controllerKodePos.text, _controllerKelurahan.text.trim(), _jenisPembiayaan._id.toString());
      print("check auto branch ${_result['listGenerateDateByBranch']}");
      if(_result['status']){
        var _temp = [];
        setState(() {
          _temp.clear();
          _listDealerCabang.clear();
          _dateListFix.clear();
          _listHour.clear();
          _pilihanCabang = null;
          _surveyDateSelected = null;
          _surveyJamSelected = null;
        });

        var _listDate = [];
        var _lisTimes = [];
        var _listDataDateAndBranch = [];
        for(var i=0; i<_result['listGenerateDateByBranch'].length; i++){
          var _formatDate = _result['listGenerateDateByBranch'][i]['dates'].trim();
          var _dates = _formatDate.split(" ");
          _listDate.add(_dates[0]);
        }
        for(var i=0; i<_result['listGenerateDateByBranch'].length; i++){
          var _formatTime = _result['listGenerateDateByBranch'][i]['dates'].trim();
          var _times = _formatTime.split(" ");
          _lisTimes.add(_times[1]);
        }
        for(var i =0; i<_result['listGenerateDateByBranch'].length; i++){
          var _data = {
            "branchId":_result['listGenerateDateByBranch'][i]['branchId'],
            "branchName": _result['listGenerateDateByBranch'][i]['BranchName'],
            "date": _listDate[i],
            "time":_lisTimes[i]
          };
          _listDataDateAndBranch.add(_data);
        }
        var _cekDataDateAndBranch = await _dbHelper.getDateAndBranchDate();
        if(_cekDataDateAndBranch.isNotEmpty || _cekDataDateAndBranch != null){
          await _dbHelper.deleteDataDateAndGenerate();
          await _dbHelper.addDateAndBranchdata(_listDataDateAndBranch);
        }
        else{
          await _dbHelper.addDateAndBranchdata(_listDataDateAndBranch);
        }
        for(var i=0; i<_result['listGenerateDateByBranch'].length; i++){
          var _dataDealer = {
            "branchId":_result['listGenerateDateByBranch'][i]['branchId'],
            "BranchName":_result['listGenerateDateByBranch'][i]['BranchName']
          };
          _temp.add(_dataDealer);
        }

        var uniqueIds = _temp.map((o) => o["branchId"].trim()).toSet().toList();
        var uniqueName = _temp.map((o) => o["BranchName"].trim()).toSet().toList();
        for(var i =0; i<uniqueIds.length; i++){
          var _myData = {"branchId":uniqueIds[i],"BranchName":uniqueName[i]};
          setState(() {
            _listDealerCabang.add(_myData);
          });
        }
      }
    }
    else if(_pemilihanCaraSurvey._id == 3){
      print("dijalankan");
      var _result = await _genenerateDateApiProvider.generateDatesByDadicateCMO(
          _controllerKodePos.text, _controllerKelurahan.text.trim(), _jenisPembiayaan._id.toString());

      if(_result['status']){
        print("cek_result ${_result['listDateByDedicateCMO']}");
        setState(() {
          _listDealerCabang.clear();
          _dateListFix.clear();
          _listHour.clear();
          _pilihanCabang = null;
          _surveyDateSelected = null;
          _surveyJamSelected = null;
        });

        var _listDate = [];
        var _lisTimes = [];
        var _listDateTimeByDedicateCMO = [];

        for(var i=0; i < _result['listDateByDedicateCMO'].length; i++){
          var _formatDate = _result['listDateByDedicateCMO'][i]['dates'];
          var _dates = _formatDate.split(" ");
          _listDate.add(_dates[0]);
        }

        for(var i=0; i< _result['listDateByDedicateCMO'].length; i++){
          var _formatTime = _result['listDateByDedicateCMO'][i]['dates'];
          var _times = _formatTime.split(" ");
          _lisTimes.add(_times[1]);
        }

        for(var i=0; i< _result['listDateByDedicateCMO'].length; i++){
          var _data = {
            "tanggal": _listDate[i],
            "jam":_lisTimes[i]
          };
          _listDateTimeByDedicateCMO.add(_data);
        }

        var _checkDateTimeByDedicatedCMO = await _dbHelper.getDateTimeByDedicatedCMO();
        if(_checkDateTimeByDedicatedCMO.isNotEmpty || _checkDateTimeByDedicatedCMO !=  null){
          await _dbHelper.deleteDateTimeByDedicatedCMO();
          await _dbHelper.addDateTimeByDedicatedCMO(_listDateTimeByDedicateCMO);
        }
        else{
          await _dbHelper.addDateTimeByDedicatedCMO(_listDateTimeByDedicateCMO);
        }

        var _resultDateDecicatedCMO = await _dbHelper.getDateByDedicatedCMO();
        for(var i=0; i < _resultDateDecicatedCMO.length; i++){
          if(!_dateListFix.contains(_resultDateDecicatedCMO[i]['tanggal'])){
            setState(() {
              _dateListFix.add(_resultDateDecicatedCMO[i]['tanggal']);
            });
          }
        }
      }
      else{
        print("data salah");
      }
    }
    else if(_pemilihanCaraSurvey._id == 4){
      var _result = await _getDataTrackingApiProvider.getBranchByDLC();
      var _temp = [];
      setState(() {
        _temp.clear();
        _listDealerCabang.clear();
        _dateListFix.clear();
        _listHour.clear();
        _pilihanCabang = null;
        _surveyDateSelected = null;
        _surveyJamSelected = null;
      });
      if(_result['status']){
        for(var i=0 ; i < _result['listBranch'].length; i++){
          _listDealerCabang.add(_result['listBranch'][i]);
        }
      }
    }
  }

  _getTimeByDateAutoBranchOrByAsIs(String date) async{
    setState(() {
      _listHour.clear();
      _surveyJamSelected = null;
    });

    if(_pemilihanCaraSurvey._id == 2){
      var _resultTime = await _dbHelper.getTimeByBranchAndDate(_pilihanCabang._id, date);
      var _tempListTime = [];
      for(var i= 0; i<_resultTime.length;i++){
        String _hour = _resultTime[i]['time'];
        var _splitHour = _hour.split(":");
        _tempListTime.add(_splitHour[0]);
      }
      for(var i= 0; i<_tempListTime.length;i++){
        print(_tempListTime[i]);
        if(!_listHour.contains(_tempListTime[i]))
          _listHour.add(_tempListTime[i]);
      }
    }
    else{
      for(var i=6; i < 22; i++){
        _listHour.add("$i");
      }
    }

  }

  _getTimeByDateAutoAssignOrByDateDedicatedCMO(String date) async{
    setState(() {
      _listHour.clear();
      _surveyJamSelected = null;
    });
    if(_pemilihanCaraSurvey._id == 3){
      var _resultTime = await _dbHelper.getTimeByDateDedicatedCMO(date);
      var _tempListTime = [];
      for(var i= 0; i<_resultTime.length;i++){
        String _hour = _resultTime[i]['jam'];
        var _splitHour = _hour.split(":");
        _tempListTime.add(_splitHour[0]);
      }
      for(var i= 0; i<_tempListTime.length;i++){
        print(_tempListTime[i]);
        if(!_listHour.contains(_tempListTime[i]))
          setState(() {
            _listHour.add(_tempListTime[i]);
          });
      }
    }
    else{
      var _resultTime = await _dbHelper.getTimeByDateAutoAssign(date);
      var _tempListTime = [];
      for(var i= 0; i<_resultTime.length;i++){
        String _hour = _resultTime[i]['jam'];
        var _splitHour = _hour.split(":");
        _tempListTime.add(_splitHour[0]);
      }
      for(var i= 0; i<_tempListTime.length;i++){
        print(_tempListTime[i]);
        if(!_listHour.contains(_tempListTime[i]))
          setState(() {
            _listHour.add(_tempListTime[i]);
          });
      }
    }
  }

  setAddressByMap(Map value){
    setState(() {
      _controllerLocation.text = value['address'];
      _longitude = value['longitude'].toString();
      _latitude = value['latitude'].toString();
    });
  }

  _showDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text("Anda yakin untuk mengajukan kredit ini?",style: TextStyle(fontFamily: "NunitoSans")),
            actions: <Widget>[
              _processSendData
                  ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )
                  :
              FlatButton(
                  onPressed: (){
                    _processData();
                  },
                  child: Text("Lanjutkan",style: TextStyle(fontFamily: "NunitoSansBold",color: yellow))),
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    _saveToDraft();
                  },
                  child: Text("Simpan di draft",style: TextStyle(fontFamily: "NunitoSans",color: yellow))),
            ],
          );
        }
    );
  }

  _processData() async{
    setState(() {
      _processSendData =true;
    });
    bool IsSameLifeAddress;
    if(_radioValue == 1){
      setState(() {
        IsSameLifeAddress = false;
      });
    }
    else{
      setState(() {
        IsSameLifeAddress = true;
        _controllerAlamatKTP.text = _controllerAlamatSurvey.text;
        _controllerRtKtp.text = _controllerRT.text;
        _controllerRwKtp.text = _controllerRW.text;
        _controllerKodePosKTP.text = _controllerKodePos.text;
        idKelurahanKTP = idKelurahan;
        idKecamatanKTP = idKecamatan;
        idKotaKTP = idKota;
        idKotaProvinsiKTP = idKotaProvinsi;
      });
    }
    String _strReplaceOTR = _controllerOTR.text.replaceAll(",", "");
    String _strRaplaceDp = _controllerDP.text.replaceAll(",", "");
    double _dp = double.parse(_strRaplaceDp);
    double _otr = double.parse(_strReplaceOTR);
    double _newDp;
    if(_dp <= 100){
      _newDp = (_dp / 100 )* _otr;
    }else{
      double _dpNominal = double.parse(_strRaplaceDp);
      _newDp = _dpNominal;
    }

    var _grosDp;
    var _netDp;
    if(_jenisKendaraan.id == "001" || _jenisKendaraan.id == "002"){
      setState(() {
        _grosDp = _newDp;
        _netDp = 0;
      });
    }
    else{
      _grosDp = 0;
      _netDp = _newDp;
    }

    var _tahunKendaraan;
    if(_jenisKendaraan.id == "001" || _jenisKendaraan.id == "002" ){
      _tahunKendaraan = _tahunKendaraanDipilihBaru;
    }
    else{
      _tahunKendaraan = _tahunKendaraanDipilihBekas;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _userDlc = preferences.getString("userDLC");
    var CreateUserID = preferences.getString("email");
    String _strReplaceAngsuran = _controllerAngsuran.text.replaceAll(",", "");
    double _installment = double.parse(_strReplaceAngsuran);

    var _pilihCabang;
    if(_pilihanCabang == null){
      _pilihCabang = "";
    }
    else{
      _pilihCabang = _pilihanCabang._id;
      print("cek pilihan cabang ${_pilihCabang}");
    }
    var _body = {
      "DlcCode": _userDlc,
      "BranchID": _pilihCabang,
      "KTP_No": _controllerNomerKTP.text,
      "FirstName": "",
      "LastName": _controllerNamaLengkap.text,
      "MidName": "",
      "BirthPlace": _controllerTempatLahir.text,
      "BirthDate": "$_thnLahir-$_blnLahir-$_tglLahir",
      "MarriageStatus": _statusPernikahan,
      "KTP_Address": _controllerAlamatKTP.text,
      "KTP_RT": _controllerRtKtp.text,
      "KTP_RW": _controllerRwKtp.text,
      "KTP_Kelurahan": idKelurahanKTP,
      "KTP_Kecamatan": idKecamatanKTP,
      "KTP_KabKota": idKotaKTP,
      "KTP_Provinsi": idKotaProvinsiKTP,
      "KTP_ZipCode": _controllerKodePosKTP.text,
      "IsSameLifeAddress": IsSameLifeAddress.toString(),
      "Address": _controllerAlamatSurvey.text,
      "RT": _controllerRT.text,
      "RW": _controllerRW.text,
      "Kelurahan": idKelurahan,
      "Kecamatan": idKecamatan,
      "Kab_Kota": idKota,
      "Provinsi": idKotaProvinsi,
      "ZipCode": _controllerKodePos.text,
      "Survey_Address": _controllerAlamatSurvey.text,
      "Phone_No": "${_controllerKodeArea.text}-${_controllerTlpnRumah.text}",
      "Spouse_FirstName": "",
      "Spouse_LastName": "",
      "Maiden_FirstName": "",
      "Maiden_LastName": _controllerNamaGadisIbuKandung.text,
      "Jenis_Kendaraan": _jenisKendaraan.jenisKendaraan,
      "ID_Jenis_Kendaraan":_jenisKendaraan.id,
      "Merk_Kendaraan": _controllerMerkKendaraan.text,
      "ID_Merk_Kendaraan":idMerkKendaraan,
      "Type_kendaraan": _controllerTipeKendaraan.text,
      "ID_Type_Kendaraan":idTypeKendaraan,
      "Model_Kendaraan": _controllerModelKendaraan.text,
      "ID_Model_Kendaraan":idModelKendaraan,
      "Tahun_Kendaraan": _tahunKendaraan,
      "OTR": _otr.toString(),
      "Tenor": _tenor.toString(),
      "Gross_DP": _grosDp.toString(), //bekas ini 0, baru ini dari field dp
      "NET_DP": _netDp.toString(), //nilai dp, jika baru ini 0
      "Installment": _installment.toString(), //ini angsuran
      "SurveyDate": "$_surveyDateSelected $_surveyJamSelected:$_surveyMenitSelected",
      "DLC_Note": _controllerCatatanDealer.text,
      "Gender": _gender.id,
      "HP_No": _controllerNoHp.text,
      "Jenis_Angsuran": "",
      "LeaseType": "",
      "Jenis_Pembiayaan": _jenisPembiayaan._id.toString(),
      "BPKB_Name": _controllerNamaPadaBPKB.text,
      "Eff_Rate": "0",
      "Flat_rate": "0",
      "Pekerjaan": _resultPekerjaan.occupationCode,
      "Purpose": "",
      "CreateUserID": CreateUserID,
      "Longtitude": _longitude,
      "Latitude": _latitude,
      "JenisSurvey": _pemilihanCaraSurvey._id.toString(),
      "KodeVoucher":_controllerRedeemVoucher.text
    };
    var _result = await _submitOrderForm.submitOrder(_body);
    print("cek hasil submit $_result");
    if(_result['status']){
      await _dbHelper.deleteRowDraft(widget.id);
      setState(() {
        _processSendData = false;
      });
      Navigator.pop(context);
      _showDialogSuccess(_result['data'][0]);
    }
    else{
      setState(() {
        _processSendData = false;
      });
      Navigator.pop(context);
      _showDialogError(_result['message']);
    }
  }

  _showDialogError(String message){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text(message,style: TextStyle(fontFamily: "NunitoSans")),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      _pemilihanCaraSurvey = _listPemilihanCaraSurvey[0];
                    });
                  },
                  child: Text("Close",style: TextStyle(fontFamily: "NunitoSans",color: yellow))),
            ],
          );
        }
    );
  }

  _showDialogSuccess(Map message){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text("Success",style: TextStyle(fontFamily: "NunitoSans")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Nama"),flex: 3),
                    Expanded(child: Text(" : "),flex: 0),
                    Expanded(child: Text(message['NamaPemohon'] != null ? message['NamaPemohon'] : ""),flex:7),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Order No"),flex: 3),
                    Expanded(child: Text(" : "),flex: 0),
                    Expanded(child: Text(message['OrderNo'] != null ? message['OrderNo'] : ""),flex: 7),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Branch Code"),flex: 3,),
                    Expanded(child: Text(" : "),flex: 0),
                    Expanded(child: Text(message['BranchID'] != null ? message['BranchID'] :""),flex: 7),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("No KTP"),flex: 3),
                    Expanded(child: Text(" : "),flex: 0),
                    Expanded(child: Text(message['KTP_No'] != null ? message['KTP_No'] : ""),flex: 7),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(dif: 1,)), (Route <dynamic> route) => false);
                  },
                  child: Text("Close",style: TextStyle(fontFamily: "NunitoSans",color: yellow))),
            ],
          );
        }
    );
  }

  _saveToDraft() async{
    bool IsSameLifeAddress;
    if(_radioValue == 1){
      setState(() {
        IsSameLifeAddress = false;
      });
    }
    else{
      setState(() {
        IsSameLifeAddress = true;
        _controllerAlamatKTP.text = _controllerAlamatSurvey.text;
        _controllerRtKtp.text = _controllerRT.text;
        _controllerRwKtp.text = _controllerRW.text;
        _controllerKodePosKTP.text = _controllerKodePos.text;
        idKelurahanKTP = idKelurahan;
        idKecamatanKTP = idKecamatan;
        idKotaKTP = idKota;
        idKotaProvinsiKTP = idKotaProvinsi;
        _textKotaKTP = _textKota;
        _textProvKTP = _textProv;
      });
    }
    String _strReplaceOTR = _controllerOTR.text.replaceAll(",", "");
//    String _strRaplaceDp = _controllerDP.text.replaceAll(",", "");
//    double _dp = double.parse(_strRaplaceDp);
    double _otr = double.parse(_strReplaceOTR);
//    double _newDp;
//    if(_dp <= 100){
//      _newDp = _dp / 100 * _otr;
//    }else{
//      double _dpNominal = double.parse(_strRaplaceDp);
//      _newDp = _dpNominal;
//    }
//
    var _grosDp;
    var _netDp;
    if(_jenisKendaraan.id == "001" || _jenisKendaraan.id == "002"){
      setState(() {
        _grosDp = _controllerDP.text;
        _netDp = "0";
      });
    }
    else{
      _grosDp = "0";
      _netDp = _controllerDP.text;
    }

    var _tahunKendaraan;
    if(_jenisKendaraan.id == "001" || _jenisKendaraan.id == "002" ){
      _tahunKendaraan = _tahunKendaraanDipilihBaru;
    }
    else{
      _tahunKendaraan = _tahunKendaraanDipilihBekas;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _userDlc = preferences.getString("userDLC");
    var CreateUserID = preferences.getString("email");
    String _strReplaceAngsuran = _controllerAngsuran.text.replaceAll(",", "");
    double _installment = double.parse(_strReplaceAngsuran);
    var _pilihCabangId,_pilihCabangName;
    if(_pilihanCabang != null){
      _pilihCabangId = _pilihanCabang._id;
      _pilihCabangName = _pilihanCabang._branchName;
      print("cek pilihan cabang ${_pilihCabangName}");
      print("cek pilihan cabang ${_pilihCabangId}");
    }
    else{
      _pilihCabangId = "";
      _pilihCabangName = "";
    }
    var _body = {
      "DlcCode": _userDlc,
      "BranchID": _pilihCabangId,
      "KTP_No": _controllerNomerKTP.text,
      "LastName": _controllerNamaLengkap.text,
      "BirthPlace": _controllerTempatLahir.text,
      "BirthDate": "$_thnLahir-$_blnLahir-$_tglLahir",
      "MarriageStatus": _statusPernikahan,
      "KTP_Address": _controllerAlamatKTP.text,
      "KTP_RT": _controllerRtKtp.text,
      "KTP_RW": _controllerRwKtp.text,
      "KTP_Kelurahan": _controllerKelurahanKTP.text,
      "KTP_Kecamatan": _controllerKecamatanKTP.text,
      "KTP_KabKota": _textKotaKTP,
      "KTP_Provinsi": _textProvKTP,
      "KTP_ZipCode": _controllerKodePosKTP.text,
      "IsSameLifeAddress": IsSameLifeAddress,
      "Address": _controllerAlamatSurvey.text,
      "RT": _controllerRT.text,
      "RW": _controllerRW.text,
      "Kelurahan": _controllerKelurahan.text,
      "Kecamatan": _controllerKecamatan.text,
      "Kab_Kota": _textKota,
      "Provinsi": _textProv,
      "ZipCode": _controllerKodePos.text,
      "Survey_Address": _controllerAlamatSurvey.text,
      "Phone_No": "${_controllerKodeArea.text}-${_controllerTlpnRumah.text}",
      "Jenis_Kendaraan": _jenisKendaraan.jenisKendaraan,
      "Merk_Kendaraan": _controllerMerkKendaraan.text,
      "Type_kendaraan": _controllerTipeKendaraan.text,
      "Model_Kendaraan": _controllerModelKendaraan.text,
      "Tahun_Kendaraan": _tahunKendaraan,
      "OTR": _otr,
      "Tenor": _tenor,
      "Gross_DP": _grosDp, //bekas ini 0, baru ini dari field dp
      "NET_DP": _netDp, //nilai dp, jika baru ini 0
      "Installment": _installment, //ini angsuran
      "SurveyDate": "$_surveyDateSelected $_surveyJamSelected:$_surveyMenitSelected",
      "DLC_Note": _controllerCatatanDealer.text,
      "Gender": _gender.genderName,
      "HP_No": _controllerNoHp.text,
      "Jenis_Pembiayaan": _jenisPembiayaan._jenisPembiayaanName,
      "BPKB_Name": _controllerNamaPadaBPKB.text,
      "Pekerjaan": _resultPekerjaan.occupationDesc,
      "CreateUserID": CreateUserID,
      "Longtitude": _longitude,
      "Latitude": _latitude,
      "JenisSurvey": _pemilihanCaraSurvey._pemilihanCaraSurvey,
      "Kelurahan_Id":idKelurahan,
      "Kecamatan_Id":idKecamatan,
      "Kab_Kota_Id":idKota,
      "Provinsi_Id":idKotaProvinsi,
      "KTP_Kelurahan_Id":idKelurahanKTP,
      "KTP_Kecamatan_Id":idKecamatanKTP,
      "KTP_Kab_Kota_Id":idKotaKTP,
      "KTP_Provinsi_Id":idKotaProvinsiKTP,
      "Gender_Id":_gender.id,
      "Pekerjaan_Id": _resultPekerjaan.occupationCode,
      "Jenis_Kendaraan_Id":_jenisKendaraan.id,
      "Model_Kendaraan_Id":idModelKendaraan,
      "Type_kendaraan_iD":idTypeKendaraan,
      "Merk_Kendaraan_iD":idMerkKendaraan,
      "Jenis_Pembiayaan_Id":_jenisPembiayaan._id,
      "JenisSurvey_Id":_pemilihanCaraSurvey._id,
      "KodeVoucher":_controllerRedeemVoucher.text,
      "Location":_controllerLocation.text,
      "Maiden_LastName": _controllerNamaGadisIbuKandung.text,
      "BranchName":_pilihCabangName
    };
    await _dbHelper.updateDraft(_body,widget.id);
    _backToHomePage();
  }

  _backToHomePage(){
    Navigator.pop(context,true);
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);}

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text),behavior: SnackBarBehavior.floating));
  }

  Widget _dataNasabahStepWidget(){
    return Theme(
        data: ThemeData(primaryColor: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                  "Data Nasabah",
                  style: TextStyle(
                      fontFamily: "NunitoSansSemiBold",fontSize: 18
                  )
              ),
            ),
            SizedBox(height: size.hp(2)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    autovalidate: _autoValidate,
                    controller: _controllerNomerKTP,
                    decoration: new InputDecoration(
                      labelText: 'Nomor KTP',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _focusNodeNoKTP,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _focusNodeNoKTP, _focusNodeNamaLengkap);
                    },
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Tidak boleh kosong";
                      }else{
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(width: size.wp(2),),
                Expanded(
                    flex:4,
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetDataProfileByOCR(dataKTP: setDataByOCR)));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0)),
                      child: Text('Get profile with ocr',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
                      color: myPrimaryColor,
                    )
                )
              ],
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate,
              controller: _controllerNamaLengkap,
              decoration: new InputDecoration(
                labelText: 'Nama Lengkap',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodeNamaLengkap,
              onFieldSubmitted: (term){
                _fieldFocusChange(context, _focusNodeNamaLengkap, _focusNodeTempatLahir);
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }
                else{
                  return null;
                }
              },
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate,
              controller: _controllerTempatLahir,
              decoration: new InputDecoration(
                labelText: 'Tempat Lahir',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              focusNode: _focusNodeTempatLahir,
              onFieldSubmitted: (value){
                _focusNodeTempatLahir.unfocus();
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }
                else{
                  return null;
                }
              },
            ),
            SizedBox(height: size.hp(2)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _thnLahir,
                    onChanged: (String newVal) {
                      setState(() {
                        _thnLahir = newVal;
                      });
                      if(_blnLahir != null){
                        _processDay();
                        _cekTahun();
                      }
                    },
                    validator: (e){
                      if(e == null){
                        return "Silahkan pilih tahun lahir";
                      }
                      else{
                        return null;
                      }
                    },
                    autovalidate: _autoValidate,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        labelText: "Tahun lahir",
                        labelStyle: TextStyle(fontFamily: "NunitoSans"),
                        contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 4),
                        errorText: _validate ? "Umur < 21 tahun" : null
                    ),
                    items:
                    _listYear.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 4,),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _blnLahir,
                    onChanged: (String newVal) {
                      setState(() {
                        _blnLahir = newVal;
                      });
                      if(_thnLahir != null){
                        _processDay();
                        _cekTahun();
                      }
                    },
                    validator: (e){
                      if(e == null){
                        return "Silahkan pilih bulan";
                      }
                      else{
                        return null;
                      }
                    },
                    autovalidate: _autoValidate,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        labelText: "Bulan lahir",
                        labelStyle: TextStyle(fontFamily: "NunitoSans"),
                        contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 4),
                        errorText: _validate ? "Umur < 21 tahun" : null
                    ),
                    items:
                    _listMonth.map((map) {
                      return DropdownMenuItem<String>(
                        value: map['id'].toString(),
                        child: Text(
                          map['month'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 4,),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _tglLahir,
                    onChanged: (String newVal) {
                      setState(() {
                        _tglLahir = newVal;
                      });
                      if(_blnLahir!=null && _thnLahir != null){
                        _cekTahun();
                      }
                    },
                    validator: (e){
                      if(e == null){
                        return "Silahkan pilih hari";
                      }
                      else{
                        return null;
                      }
                    },
                    autovalidate: _autoValidate,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        labelText: "Hari lahir",
                        labelStyle: TextStyle(fontFamily: "NunitoSans"),
                        contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 4),
                        errorText: _validate ? "Umur < 21 tahun" : null
                    ),
                    items:
                    _listDateBirthdate.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.hp(2)),
            DropdownButtonFormField<Gender>(
              value: _gender,
              onChanged: (gender) {
                setState(() {
                  _gender = gender;
                });
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih gender";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  labelText: "Gender",
                  labelStyle: TextStyle(fontFamily: "NunitoSans"),
                  contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 5)
              ),
              items:
              _listGender.map((Gender gender) {
                return new DropdownMenuItem<Gender>(
                  value: gender,
                  child: new Text(gender.genderName,
                      style: new TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            SizedBox(height: size.hp(2)),
            DropdownButtonFormField<String>(
              value: _statusPernikahan,
              onChanged: (String newVal) {
                setState(() {
                  _statusPernikahan = newVal;
                });
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih status pernikahan";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  labelText: "Status Pernikahan",
                  labelStyle: TextStyle(fontFamily: "NunitoSans"),
                  contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 5)
              ),
              items:
              _listStatusPernikahan.map((map) {
                return new DropdownMenuItem<String>(
                  value: map['id'].toString(),
                  child: new Text(map['statusKawin'],
                      style: new TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate,
              controller: _controllerAlamatSurvey,
              decoration: new InputDecoration(
                labelText: 'Alamat Survey',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodeAlamatSurvey,
              onFieldSubmitted: (term){
                _fieldFocusChange(context, _focusNodeAlamatSurvey, _focusNodeRT);
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }else{
                  return null;
                }
              },
              maxLines: 3,
            ),
            SizedBox(height: size.hp(2)),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child:
                    TextFormField(
                        autovalidate: _autoValidate,
                        controller: _controllerRT,
                        decoration: new InputDecoration(
                          labelText: 'RT',
                          labelStyle: TextStyle(fontFamily: "NunitoSans"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _focusNodeRT,
                        onFieldSubmitted: (term){
                          _fieldFocusChange(context, _focusNodeRT, _focusNodeRW);
                        },
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Tidak boleh kosong";
                          }
                          else{
                            return null;
                          }
                        },
                    )
                ),
                SizedBox(width: size.wp(1.5)),
                Expanded(
                    flex: 5,
                    child:
                    TextFormField(
                        autovalidate: _autoValidate,
                        controller: _controllerRW,
                        decoration: new InputDecoration(
                          labelText: 'RW',
                          labelStyle: TextStyle(fontFamily: "NunitoSans"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        focusNode: _focusNodeRW,
                        onFieldSubmitted: (term){
                          _focusNodeRW.unfocus();
                        },
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Tidak boleh kosong";
                          }
                          else{
                            return null;
                          }
                        },
                    )
                )
              ],
            ),
            SizedBox(height: size.hp(2)),
            FocusScope(
              node: FocusScopeNode(),
              child: TextFormField(
                  autovalidate: _autoValidate,
                  controller: _controllerKecamatan,
                  decoration: new InputDecoration(
                      labelText: 'Kecamatan',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: Icon(Icons.search,color: Colors.black)
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchkecamatanPage(onSelected: setValueKecamatan)));
                  },
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Tidak boleh kosong";
                    }
                    else{
                      return null;
                    }
                  }
              ),
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate,
              controller: _controllerKelurahan,
              decoration: new InputDecoration(
                labelText: 'Kelurahan',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              enabled: false,
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }
                else{
                  return null;
                }
              },
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate,
              controller: _controllerKodePos,
              decoration: new InputDecoration(
                labelText: 'Kode Pos',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              enabled: false,
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }
                else{
                  return null;
                }
              },
            ),
            SizedBox(height: size.hp(2)),
            Container(
              child: Text("Alamat KTP",style: TextStyle(fontFamily: "NunitoSans")),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                  activeColor: const Color(0xff25AE88),
                ),
                Text("Sesuai Alamat Tinggal",style: TextStyle(fontFamily: "NunitoSans")),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                  activeColor: const Color(0xff25AE88),
                ),
                Text("Tidak Sesuai Alamat Tinggal",style: TextStyle(fontFamily: "NunitoSans")),
              ],
            ),
            SizedBox(height: size.hp(2)),
            _radioValue == 1
                ?
            //---alamat tidak sesuai ktp----//
            Column(
              children: <Widget>[
                TextFormField(
                  autovalidate: _autoValidate,
                  controller: _controllerAlamatKTP,
                  decoration: new InputDecoration(
                    labelText: 'Alamat KTP',
                    labelStyle: TextStyle(fontFamily: "NunitoSans"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodeAlamatKTP,
                  onFieldSubmitted: (term){
                    _fieldFocusChange(context,_focusNodeAlamatKTP, _focusNodeRtKtp);
                  },
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Tidak boleh kosong";
                    }else{
                      return null;
                    }},
                  maxLines: 3,
                ),
                SizedBox(height: size.hp(2)),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child:
                        TextFormField(
                            autovalidate: _autoValidate,
                            controller: _controllerRtKtp,
                            decoration: new InputDecoration(
                              labelText: 'RT KTP',
                              labelStyle: TextStyle(fontFamily: "NunitoSans"),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _focusNodeRtKtp,
                            onFieldSubmitted: (term){
                              _fieldFocusChange(context, _focusNodeRtKtp, _focusNodeRwKtp);
                            },
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Tidak boleh kosong";
                              }
                              else{
                                return null;
                              }},
                        )
                    ),
                    SizedBox(width: size.wp(1.5)),
                    Expanded(
                        flex: 5,
                        child:
                        TextFormField(
                            autovalidate: _autoValidate,
                            controller: _controllerRwKtp,
                            decoration: new InputDecoration(
                              labelText: 'RW KTP',
                              labelStyle: TextStyle(fontFamily: "NunitoSans"),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            focusNode: _focusNodeRwKtp,
                            onFieldSubmitted: (term){
                              _focusNodeRwKtp.unfocus();
                            },
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Tidak boleh kosong";
                              }
                              else{
                                return null;
                              }},
                        )
                    )
                  ],
                ),
                SizedBox(height: size.hp(2),),
                FocusScope(
                  node: FocusScopeNode(),
                  child: TextFormField(
                    autovalidate: _autoValidate,
                    controller: _controllerKecamatanKTP,
                    decoration: new InputDecoration(
                        labelText: 'Kecamatan KTP',
                        labelStyle: TextStyle(fontFamily: "NunitoSans"),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: Icon(Icons.search,color: Colors.black)
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchkecamatanPage(onSelected: setValueKecamatanKTP)));
                    },
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Tidak boleh kosong";
                      }
                      else{
                        return null;
                      }},
                  ),
                ),
                SizedBox(height: size.hp(2)),
                TextFormField(
                  autovalidate: _autoValidate,
                  controller: _controllerKelurahanKTP,
                  decoration: new InputDecoration(
                    labelText: 'Kelurahan KTP',
                    labelStyle: TextStyle(fontFamily: "NunitoSans"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Tidak boleh kosong";
                    }else{
                      return null;
                    }},
                ),
                SizedBox(height: size.hp(2)),
                TextFormField(
                  autovalidate: _autoValidate,
                  controller: _controllerKodePosKTP,
                  decoration: new InputDecoration(
                    labelText: 'Kode Pos KTP',
                    labelStyle: TextStyle(fontFamily: "NunitoSans"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Tidak boleh kosong";
                    }else{
                      return null;
                    }},
                ),
              ],
            )
                :
            SizedBox(height: 0.0,width: 0.0),
            SizedBox(height: size.hp(2)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    autovalidate: _autoValidate,
                    controller: _controllerKodeArea,
                    decoration: new InputDecoration(
                      labelText: 'Kode Area',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    focusNode: _focusNodeKodeArea,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _focusNodeKodeArea, _focusNodeTlpnRumah);
                    },
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Tidak boleh kosong";
                      }else{
                        return null;
                      }},
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    autovalidate: _autoValidate,
                    controller: _controllerTlpnRumah,
                    decoration: new InputDecoration(
                      labelText: 'Telepon Rumah',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    focusNode: _focusNodeTlpnRumah,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _focusNodeTlpnRumah, _focusNodeKodeNegara);
                    },
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Tidak boleh kosong";
                      }else{
                        return null;
                      }},
                  ),
                ),
              ],
            ),
            SizedBox(height: size.hp(2)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    autovalidate: _autoValidate,
                    controller: _controllerKodeNegara,
                    decoration: new InputDecoration(
                      labelText: 'Kode Negara',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      prefixText: "+",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    focusNode: _focusNodeKodeNegara,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _focusNodeKodeNegara, _focusNodeNoHp);
                    },
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Tidak boleh kosong";
                      }else{
                        return null;
                      }},
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    autovalidate: _autoValidate,
                    controller: _controllerNoHp,
                    decoration: new InputDecoration(
                      labelText: 'No HP',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    focusNode: _focusNodeNoHp,
                    onFieldSubmitted: (term){
                      _focusNodeNoHp.unfocus();
                    },
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Tidak boleh kosong";
                      }else{
                        return null;
                      }},
                    onChanged: (e){
                      _cekZeroPhoneNumber(e);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: size.hp(2)),
            DropdownButtonFormField<ResultPekerjaan>(
              value: _resultPekerjaan,
              onChanged: (newVal) {
                setState(() {
                  _resultPekerjaan = newVal;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  labelText: "Pekerjaan",
                  labelStyle: TextStyle(fontFamily: "NunitoSans"),
                  contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 5)
              ),
              items:
              _listResultPekerjaan.map((map) {
                return new DropdownMenuItem<ResultPekerjaan>(
                  value: map,
                  child: new Text(map.occupationDesc,
                      style: new TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            SizedBox(height: size.hp(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    controller: _controllerRedeemVoucher,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 0.0,bottom:0.0,right: 8,left: 8),
                      labelText: 'Redeem voucher',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.done,
                    focusNode: _focusNodeRedeemVoucher,
                    onFieldSubmitted: (term){
                      _focusNodeRedeemVoucher.unfocus();
                    },
                  ),
                ),
                SizedBox(width: size.wp(2)),
                _isProcessCheckVoucher
                    ?
                CircularProgressIndicator()
                    :
                Expanded(
                    flex:4,
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: size.hp(1.5),bottom: size.hp(1.5)),
                      onPressed: (){
                        _checkValidVoucher();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0)),
                      child: Text('Check voucher',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
                      color: myPrimaryColor,
                    )
                )
              ],
            )
          ],
        )
    );
  }

  Widget _dataKendaraanStepWidget(){
    return Theme(
      data: ThemeData(primaryColor: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("Data Kendaraan",style: TextStyle(fontFamily: "NunitoSansSemiBold",fontSize: 18)),
          ),
          SizedBox(height: size.hp(2)),
          DropdownButtonFormField<JenisKendaraan>(
            value: _jenisKendaraan,
            onChanged: (jenisKendaraan) {
              setState(() {
                _jenisKendaraan = jenisKendaraan;
              });
              _addTahunKendaraan();
              if(_controllerModelKendaraan.text.isNotEmpty){
                _controllerModelKendaraan.clear();
                _controllerTipeKendaraan.clear();
                _controllerMerkKendaraan.clear();
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: "Jenis kendaraan",
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              contentPadding: EdgeInsets.symmetric( horizontal: 10),
            ),
            validator: (e){
              if(e == null){
                return "Silahkan pilih jenis kendaraan";
              }
              else{
                return null;
              }
            },
            autovalidate: _autoValidate2,
            items:
            _listJenisKendaraan.map((JenisKendaraan jenisKendaraan) {
              return new DropdownMenuItem<JenisKendaraan>(
                value: jenisKendaraan,
                child: new Text(jenisKendaraan.jenisKendaraan,
                    style: new TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
          SizedBox(height: size.hp(2)),
          FocusScope(
            node: FocusScopeNode(),
            child: TextFormField(
              autovalidate: _autoValidate2,
              controller: _controllerModelKendaraan,
              decoration: new InputDecoration(
                  labelText: 'Model',
                  labelStyle: TextStyle(fontFamily: "NunitoSans"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: Icon(Icons.search,color: Colors.black)
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchModelKendaraan(onSelected: _setValueModel,idStatusKendaraan: _jenisKendaraan.id)));
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }
                else{
                  return null;
                }},
            ),
          ),
          SizedBox(height: size.hp(2)),
          TextFormField(
            autovalidate: _autoValidate2,
            controller: _controllerTipeKendaraan,
            decoration: new InputDecoration(
              labelText: 'Tipe',
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            enabled: false,
            validator: (e) {
              if (e.isEmpty) {
                return "Tidak boleh kosong";
              }else{
                return null;
              }},
          ),
          SizedBox(height: size.hp(2)),
          TextFormField(
            autovalidate: _autoValidate2,
            controller: _controllerMerkKendaraan,
            decoration: new InputDecoration(
              labelText: 'Merk',
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            enabled: false,
            validator: (e) {
              if (e.isEmpty) {
                return "Tidak boleh kosong";
              }else{
                return null;
              }},
          ),
          SizedBox(height: size.hp(2)),
          SizedBox(height: size.hp(2)),
          _jenisKendaraan == null
              ?
          DropdownButtonFormField<String>(
            value: _tahunKendaraanDipilih,
            onChanged: (String newVal) {
              setState(() {
                _tahunKendaraanDipilih = newVal;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: "Tahun Kendaraan",
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              contentPadding: EdgeInsets.symmetric( horizontal: 10),
            ),
            validator: (e){
              if(e == null){
                return "Silahkan pilih jenis kendaraan";
              }
              else{
                return null;
              }
            },
            autovalidate: _autoValidate2,
            items:
            _listTahunKendaraan.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          )
              :
          _jenisKendaraan.id == "001"
              ||
              _jenisKendaraan.id == "002"
              ?
          DropdownButtonFormField<String>(
            value: _tahunKendaraanDipilihBaru,
            onChanged: (String newVal) {
              setState(() {
                _tahunKendaraanDipilihBaru = newVal;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: "Tahun Kendaraan",
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              contentPadding: EdgeInsets.symmetric( horizontal: 10),
            ),
            validator: (e){
              if(e == null){
                return "Silahkan pilih tahun kendaraan";
              }
              else{
                return null;
              }
            },
            autovalidate: _autoValidate2,
            items:
            _listTahunKendaraanBaru.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          )
              :
          DropdownButtonFormField<String>(
            value: _tahunKendaraanDipilihBekas,
            onChanged: (String newVal) {
              setState(() {
                _tahunKendaraanDipilihBekas = newVal;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: "Tahun Kendaraan",
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              contentPadding: EdgeInsets.symmetric( horizontal: 10),
            ),
            validator: (e){
              if(e == null){
                return "Silahkan pilih tahun kendaraan";
              }
              else{
                return null;
              }
            },
            autovalidate: _autoValidate2,
            items:
            _listTahunKendaraanBekas.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: size.hp(2),),
          TextFormField(
            autovalidate: _autoValidate2,
            controller: _controllerNamaPadaBPKB,
            decoration: new InputDecoration(
              labelText: 'Nama pada BPKB',
              labelStyle: TextStyle(fontFamily: "NunitoSans"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            autofocus: false,
            validator: (e) {
              if (e.isEmpty) {
                return "Tidak boleh kosong";
              }else{
                return null;
              }},
          ),
        ],
      ),
    );
  }

  Widget _dataPengajuanKredit(){
    return Theme(
        data: ThemeData(primaryColor: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                  "Data Pengajuan Kredit",
                  style: TextStyle(
                      fontFamily: "NunitoSansSemiBold",fontSize: 18
                  )
              ),
            ),
            SizedBox(height: size.hp(3)),
            DropdownButtonFormField<JenisPembiayaan>(
              value: _jenisPembiayaan,
              onChanged: (newValJenisPembiayaan) {
                setState(() {
                  _jenisPembiayaan = newValJenisPembiayaan;
                });
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih jenis pembiayaan";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                labelText: "Jenis Pembiayaan",
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                contentPadding: EdgeInsets.symmetric( horizontal: 10),
              ),
              items:
              _listJenisPembiayaan.map((JenisPembiayaan jenisPembiayaan) {
                return new DropdownMenuItem<JenisPembiayaan>(
                  value: jenisPembiayaan,
                  child: new Text(jenisPembiayaan._jenisPembiayaanName,
                      style: new TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate3,
              controller: _controllerOTR,
              decoration: new InputDecoration(
                labelText: 'OTR (Rp)',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
                CurrencyFormat()
              ],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              focusNode: _focusNodeOTR,
              onFieldSubmitted: (term){
                _focusNodeOTR.unfocus();
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }else{
                  return null;
                }},
            ),
            SizedBox(height: size.hp(2)),
            DropdownButtonFormField<String>(
              value: _tenor,
              onChanged: (String newVal) {
                setState(() {
                  _tenor = newVal;
                });
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih tenor";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                labelText: "Tenor",
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                contentPadding: EdgeInsets.symmetric( horizontal: 10),
              ),
              items:
              _listPilihanTenor.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate3,
              controller: _controllerDP,
              decoration: new InputDecoration(
                labelText: 'DP',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _focusNodeDp,
              onFieldSubmitted: (term){
                _fieldFocusChange(context, _focusNodeDp, _focusNodeAngsuran);
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }else{
                  return null;
                }},
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate3,
              controller: _controllerAngsuran,
              decoration: new InputDecoration(
                labelText: 'Angsuran',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              focusNode: _focusNodeAngsuran,
              onFieldSubmitted: (value){
                _focusNodeAngsuran.unfocus();
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }else{
                  return null;
                }},
            ),
          ],
        )
    );
  }

  Widget _dataLainStepWidget(){
    return Theme(
        data: ThemeData(primaryColor: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text("Data Lain",style: TextStyle(fontFamily: "NunitoSansSemiBold",fontSize: 18)),
            ),
            SizedBox(height: size.hp(3)),
            DropdownButtonFormField<PemilihanCaraSurvey>(
              value: _pemilihanCaraSurvey,
              onChanged: (newVal) {
                setState(() {
                  _pemilihanCaraSurvey = newVal;
                });
                _getGenerateDate();
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih cara survey";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate4,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  labelText: "Pemilihan Cara Survey",
                  labelStyle: TextStyle(fontFamily: "NunitoSans"),
                  contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 5)
              ),
              items:
              _listPemilihanCaraSurvey.map((PemilihanCaraSurvey pemilihanCaraSurvey) {
                return new DropdownMenuItem<PemilihanCaraSurvey>(
                  value: pemilihanCaraSurvey,
                  child: new Text(pemilihanCaraSurvey._pemilihanCaraSurvey,
                      style: new TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            SizedBox(height: size.hp(2)),
            _pemilihanCaraSurvey._id == 2
                ?
            Column(
              children: <Widget>[
                DropdownButtonFormField<Branch>(
                  value: _pilihanCabang,
                  onChanged: (newVal) {
                    setState(() {
                      _pilihanCabang = newVal;
                    });
                    _getDateList(newVal._id);
                  },
                  validator: (e){
                    if(e == null){
                      return "Silahkan pilih dealer cabang";
                    }
                    else{
                      return null;
                    }
                  },
                  autovalidate: _autoValidate4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      labelText: "Pilih cabang",
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 5)
                  ),
                  items:
                  _listBranch.map((Branch value) {
                    return DropdownMenuItem<Branch>(
                      value: value,
                      child: Text(
                        value._branchName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: size.hp(2)),
              ],
            )
                :
            _pemilihanCaraSurvey._id == 4
                ?
            Column(
              children: <Widget>[
                DropdownButtonFormField<Branch>(
                  value: _pilihanCabang,
                  onChanged: (newVal) {
                    setState(() {
                      _pilihanCabang = newVal;
                    });
                    _getDateList(newVal._id);
                  },
                  validator: (e){
                    if(e == null){
                      return "Silahkan pilih dealer cabang";
                    }
                    else{
                      return null;
                    }
                  },
                  autovalidate: _autoValidate4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      labelText: "Pilih cabang",
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      contentPadding: EdgeInsets.symmetric( horizontal: 10,vertical: 5)
                  ),
                  items:
                  _listBranch.map((Branch value) {
                    return DropdownMenuItem<Branch>(
                      value: value,
                      child: Text(
                        value._branchName.trim(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: size.hp(2)),
              ],
            )
                :
            SizedBox(height: 0.0,width: 0.0),
            DropdownButtonFormField<String>(
              value: _surveyDateSelected,
              onChanged: (String newVal) {
                setState(() {
                  _surveyDateSelected = newVal;
                });
                if(_pemilihanCaraSurvey._id == 2 || _pemilihanCaraSurvey._id == 4){
                  _getTimeByDateAutoBranchOrByAsIs(newVal);
                }
                else{
                  _getTimeByDateAutoAssignOrByDateDedicatedCMO(newVal);
                }
              },
              validator: (e){
                if(e == null){
                  return "Silahkan pilih tanggal survey";
                }
                else{
                  return null;
                }
              },
              autovalidate: _autoValidate4,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                labelText: "Pilih tanggal survey",
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                contentPadding: EdgeInsets.symmetric( horizontal: 10),
              ),
              items:
              _dateListFix.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: size.hp(2)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _surveyJamSelected,
                    onChanged: (String newVal) {
                      setState(() {
                        _surveyJamSelected = newVal;
                      });
                    },
                    validator: (e){
                      if(e == null){
                        return "Silahkan pilih jam survey";
                      }
                      else{
                        return null;
                      }
                    },
                    autovalidate: _autoValidate4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      labelText: "Pilih jam survey",
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      contentPadding: EdgeInsets.symmetric( horizontal: 10),
                    ),
                    items:
                    _listHour.map((String _myValue) {
                      return DropdownMenuItem(
                        value: _myValue,
                        child: Text(
                          _myValue,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: size.wp(3),),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _surveyMenitSelected,
                    onChanged: (String newVal) {
                      setState(() {
                        _surveyMenitSelected = newVal;
                      });
                    },
                    validator: (e){
                      if(e == null){
                        return "Silahkan pilih menit survey";
                      }
                      else{
                        return null;
                      }
                    },
                    autovalidate: _autoValidate4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      labelText: "Pilih menit survey",
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      contentPadding: EdgeInsets.symmetric( horizontal: 10),
                    ),
                    items:
                    _listMinute.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.hp(2)),
            FocusScope(
              node: FocusScopeNode(),
              child: TextFormField(
                controller: _controllerLocation,
                decoration: new InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(fontFamily: "NunitoSans"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage(setAddress: setAddressByMap,)));
                },
                maxLines: 3,
              ),
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate4,
              controller: _controllerNamaGadisIbuKandung,
              decoration: new InputDecoration(
                labelText: 'Nama Lengkap Gadis Ibu Kandung',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodeNamaIbuKandung,
              onFieldSubmitted: (term){
                _fieldFocusChange(context, _focusNodeNamaIbuKandung, _focusNodeCatatanDealer);
              },
              validator: (e) {
                if (e.isEmpty) {
                  return "Tidak boleh kosong";
                }else{
                  return null;
                }},
            ),
            SizedBox(height: size.hp(2)),
            TextFormField(
              autovalidate: _autoValidate4,
              controller: _controllerCatatanDealer,
              decoration: new InputDecoration(
                labelText: 'Catatan Dealer',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              focusNode: _focusNodeCatatanDealer,
              onFieldSubmitted: (term){
                _focusNodeCatatanDealer.unfocus();
              },
              maxLines: 3,
            ),
          ],
        )
    );
  }
}

class Gender {
  final String id;
  final String genderName;

  Gender(this.id, this.genderName);

}

class JenisKendaraan{
  final String id;
  final String jenisKendaraan;
  JenisKendaraan(this.id, this.jenisKendaraan);
}

class JenisPembiayaan{
  final int _id;
  final String _jenisPembiayaanName;

  JenisPembiayaan(this._id, this._jenisPembiayaanName);
}

class PemilihanCaraSurvey{
  final int _id;
  final String _pemilihanCaraSurvey;

  PemilihanCaraSurvey(this._id, this._pemilihanCaraSurvey);
}

class Branch{
  final String _id;
  final String _branchName;

  Branch(this._id, this._branchName);

}
