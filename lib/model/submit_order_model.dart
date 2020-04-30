class SubmitOrderModel{
  List<ResultSubmitOrder> _listResultSumbitOrder = [];

  SubmitOrderModel.fromJson(List parsedJson){
    List<ResultSubmitOrder> _temp = [];
    for(int i=0; i<parsedJson.length; i++){
      ResultSubmitOrder _result = ResultSubmitOrder(parsedJson[i]);
      _temp.add(_result);
    }
    _listResultSumbitOrder = _temp;
  }

  List<ResultSubmitOrder> get listResultSumbitOrder => _listResultSumbitOrder;

}

class ResultSubmitOrder{
  int _orderID;
  String _dlcCode;
  String _DLC_Name;
  String _branchID;
  String _orderDate;
  String _orderNo;
  String _KTP_No;
  String _firstName;
  String _lastName;
  String _midName;
  String _BirthPlace;
  String _BirthDate;
  String _MaritalStatus;
  String _KTP_Address;
  String _KTP_RT;
  String _KTP_RW;
  String _KTP_Kelurahan;
  String _KTP_Kecamatan;
  String _KTP_KabKota;
  String _KTP_Provinsi;
  String _KTP_ZipCode;
  bool _IsSameLifeAddress;
  String _Address;
  String _RT;
  String _RW;
  String _Kelurahan;
  String _Kecamatan;
  String _Kab_Kota;
  String _Provinsi;
  String _ZipCode;
  String _Survey_Address;
  String _Phone_No;
  String _Spouse_FirstName;
  String _Spouse_LastName;
  String _Maiden_FirstName;
  String _Maiden_LastName;
  String _Jenis_Kendaraan_ID;
  String _Jenis_Kendaraan;
  String _Merk_Kendaraan;
  String _Type_kendaraan;
  String _Model_Kendaraan;
  String _Tahun_Kendaraan;
  double _OTR;
  int _Tenor;
  double _Gross_DP;
  double _NET_DP;
  double _Installment;
  String _SurveyDate;
  String _DLC_Note;
  String _HP_No;
  String _Jenis_Angsuran;
  String _LeaseType;
  int _Jenis_Pembiayaan;
  String _BPKB_Name;
  int _Eff_Rate;
  int _Flat_rate;
  String _Pekerjaan;
  String _Purpose;
  String _CreateUserID;
  String _NIK_Surveyor;
  String _SurveyorName;
  String _NIK_Marketing;
  String _MarketingName;
  String _Langtitude;
  String _Longtitude;
  int _JenisSurvey;
  String _Gender;
  String _Status;
  String _Remark;

  ResultSubmitOrder(resultSubmitOrder){
    _orderID = resultSubmitOrder['OrderID'];
    _dlcCode = resultSubmitOrder['DlcCode'];
    _branchID = resultSubmitOrder['BranchID'];
    _orderDate = resultSubmitOrder['Orderdate'];
    _orderNo = resultSubmitOrder['OrderNo'];
    _KTP_No = resultSubmitOrder['KTP_No'];
    _firstName = resultSubmitOrder['FirstName'];
    _lastName = resultSubmitOrder['LastName'];
    _midName = resultSubmitOrder['MidName'];
    _BirthPlace = resultSubmitOrder['BirthPlace'];
    _BirthDate = resultSubmitOrder['BirthDate'];
    _MaritalStatus = resultSubmitOrder['MaritalStatus'];
    _KTP_Address = resultSubmitOrder['KTP_Address'];
    _KTP_RT = resultSubmitOrder['KTP_RT'];
    _KTP_RW = resultSubmitOrder['KTP_RW'];
    _KTP_Kelurahan = resultSubmitOrder['KTP_Kelurahan'];
    _KTP_Kecamatan = resultSubmitOrder['KTP_Kecamatan'];
    _KTP_KabKota = resultSubmitOrder['KTP_KabKota'];
    _KTP_Provinsi = resultSubmitOrder['KTP_Provinsi'];
    _KTP_ZipCode = resultSubmitOrder['KTP_ZipCode'];
    _IsSameLifeAddress = resultSubmitOrder['IsSameLifeAddress'];
    _Address = resultSubmitOrder['Address'];
    _RT = resultSubmitOrder['RT'];
    _RW = resultSubmitOrder['RW'];
    _Kelurahan = resultSubmitOrder['Kelurahan'];
    _Kecamatan = resultSubmitOrder['Kecamatan'];
    _Kab_Kota = resultSubmitOrder['Kab_Kota'];
    _Provinsi = resultSubmitOrder['Provinsi'];
    _ZipCode = resultSubmitOrder['ZipCode'];
    _Survey_Address = resultSubmitOrder['Survey_Address'];
    _Phone_No = resultSubmitOrder['Phone_No'];
    _Spouse_FirstName = resultSubmitOrder['Spouse_FirstName'];
    _Spouse_LastName = resultSubmitOrder['Spouse_LastName'];
    _Maiden_FirstName = resultSubmitOrder['Maiden_FirstName'];
    _Maiden_LastName = resultSubmitOrder['Maiden_LastName'];
    _Jenis_Kendaraan_ID = resultSubmitOrder['Jenis_Kendaraan_ID'];
    _Jenis_Kendaraan = resultSubmitOrder['Jenis_Kendaraan'];
    _Merk_Kendaraan = resultSubmitOrder['Merk_Kendaraan'];
    _Type_kendaraan = resultSubmitOrder['Type_kendaraan'];
    _Model_Kendaraan = resultSubmitOrder['Model_Kendaraan'];
    _Tahun_Kendaraan = resultSubmitOrder['Tahun_Kendaraan'];
    _OTR = resultSubmitOrder['OTR'];
    _Tenor = resultSubmitOrder['Tenor'];
    _Gross_DP = resultSubmitOrder['Gross_DP'];
    _NET_DP = resultSubmitOrder['NET_DP'];
    _Installment = resultSubmitOrder['Installment'];
    _SurveyDate = resultSubmitOrder['SurveyDate'];
    _DLC_Note = resultSubmitOrder['DLC_Note'];
    _HP_No = resultSubmitOrder['HP_No'];
    _Jenis_Angsuran = resultSubmitOrder['Jenis_Angsuran'];
    _LeaseType = resultSubmitOrder['LeaseType'];
    _Jenis_Pembiayaan = resultSubmitOrder['Jenis_Pembiayaan'];
     _BPKB_Name = resultSubmitOrder['BPKB_Name'];
     _Eff_Rate = resultSubmitOrder['Eff_Rate'];
     _Flat_rate = resultSubmitOrder['Flat_rate'];
     _Pekerjaan = resultSubmitOrder['Pekerjaan'];
     _Purpose = resultSubmitOrder['Purpose'];
     _CreateUserID = resultSubmitOrder['CreateUserID'];
     _NIK_Surveyor = resultSubmitOrder['NIK_Surveyor'];
     _SurveyorName = resultSubmitOrder['SurveyorName'];
     _NIK_Marketing = resultSubmitOrder['NIK_Marketing'];
     _MarketingName = resultSubmitOrder['MarketingName'];
     _Langtitude = resultSubmitOrder['Langtitude'];
     _Longtitude = resultSubmitOrder['Longtitude'];
     _JenisSurvey = resultSubmitOrder['JenisSurvey'];
     _Gender = resultSubmitOrder['Gender'];
    _Status = resultSubmitOrder['Status'];
    _Remark = resultSubmitOrder['Remark'];
  }

  String get Gender => _Gender;

  int get JenisSurvey => _JenisSurvey;

  String get Longtitude => _Longtitude;

  String get Langtitude => _Langtitude;

  String get MarketingName => _MarketingName;

  String get NIK_Marketing => _NIK_Marketing;

  String get SurveyorName => _SurveyorName;

  String get NIK_Surveyor => _NIK_Surveyor;

  String get CreateUserID => _CreateUserID;

  String get Purpose => _Purpose;

  String get Pekerjaan => _Pekerjaan;

  int get Flat_rate => _Flat_rate;

  int get Eff_Rate => _Eff_Rate;

  String get BPKB_Name => _BPKB_Name;

  int get Jenis_Pembiayaan => _Jenis_Pembiayaan;

  String get LeaseType => _LeaseType;

  String get Jenis_Angsuran => _Jenis_Angsuran;

  String get HP_No => _HP_No;

  String get DLC_Note => _DLC_Note;

  String get SurveyDate => _SurveyDate;

  double get Installment => _Installment;

  double get NET_DP => _NET_DP;

  double get Gross_DP => _Gross_DP;

  int get Tenor => _Tenor;

  double get OTR => _OTR;

  String get Tahun_Kendaraan => _Tahun_Kendaraan;

  String get Model_Kendaraan => _Model_Kendaraan;

  String get Type_kendaraan => _Type_kendaraan;

  String get Merk_Kendaraan => _Merk_Kendaraan;

  String get Jenis_Kendaraan => _Jenis_Kendaraan;

  String get Maiden_LastName => _Maiden_LastName;

  String get Maiden_FirstName => _Maiden_FirstName;

  String get Spouse_LastName => _Spouse_LastName;

  String get Spouse_FirstName => _Spouse_FirstName;

  String get Phone_No => _Phone_No;

  String get Survey_Address => _Survey_Address;

  String get ZipCode => _ZipCode;

  String get Provinsi => _Provinsi;

  String get Kab_Kota => _Kab_Kota;

  String get Kecamatan => _Kecamatan;

  String get Kelurahan => _Kelurahan;

  String get RW => _RW;

  String get RT => _RT;

  String get Address => _Address;

  bool get IsSameLifeAddress => _IsSameLifeAddress;

  String get KTP_ZipCode => _KTP_ZipCode;

  String get KTP_Provinsi => _KTP_Provinsi;

  String get KTP_KabKota => _KTP_KabKota;

  String get KTP_Kecamatan => _KTP_Kecamatan;

  String get KTP_Kelurahan => _KTP_Kelurahan;

  String get KTP_RW => _KTP_RW;

  String get KTP_RT => _KTP_RT;

  String get KTP_Address => _KTP_Address;

  String get MaritalStatus => _MaritalStatus;

  String get BirthDate => _BirthDate;

  String get BirthPlace => _BirthPlace;

  String get midName => _midName;

  String get lastName => _lastName;

  String get firstName => _firstName;

  String get KTP_No => _KTP_No;

  String get orderNo => _orderNo;

  String get orderDate => _orderDate;

  String get branchID => _branchID;

  String get DLC_Name => _DLC_Name;

  String get dlcCode => _dlcCode;

  int get orderID => _orderID;

  String get Remark => _Remark;

  String get Status => _Status;

  String get Jenis_Kendaraan_ID => _Jenis_Kendaraan_ID;

}