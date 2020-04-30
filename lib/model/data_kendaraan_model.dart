class DataKendaraanModel{
  List<ResultDataKendaraan> _listDataKendaraan = [];
  DataKendaraanModel.fromJson(List parsedJson){
    List<ResultDataKendaraan> _temp = [];
    for(int i=0; i<parsedJson.length; i++){
      ResultDataKendaraan _result = ResultDataKendaraan(parsedJson[i]);
      _temp.add(_result);
    }
    _listDataKendaraan = _temp;
  }

  List<ResultDataKendaraan> get listDataKendaraan => _listDataKendaraan;
}

class ResultDataKendaraan{
  int _id;
  String _obectCode;
  String _objectDesc;
  String _typeCode;
  String _typeDesc;
  String _brandCode;
  String _brandDesc;
  String _modelCode;
  String _modelDesc;

  ResultDataKendaraan(resultDataKendaraan){
    _id = resultDataKendaraan['id'];
    _obectCode = resultDataKendaraan['object_code'];
    _objectDesc = resultDataKendaraan['obect_desc'];
    _typeCode = resultDataKendaraan['type_code'];
    _typeDesc = resultDataKendaraan['type_desc'];
    _brandCode = resultDataKendaraan['brand_code'];
    _brandDesc = resultDataKendaraan['brand_desc'];
    _modelCode = resultDataKendaraan['model_code'];
    _modelDesc = resultDataKendaraan['model_desc'];
  }

  String get modelDesc => _modelDesc;

  String get modelCode => _modelCode;

  String get brandDesc => _brandDesc;

  String get brandCode => _brandCode;

  String get typeDesc => _typeDesc;

  String get typeCode => _typeCode;

  String get objectDesc => _objectDesc;

  String get obectCode => _obectCode;

  int get id => _id;

}