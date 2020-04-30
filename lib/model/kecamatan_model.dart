class KecamatanModel{
  List<Result> _resultList = [];

  KecamatanModel.fromJson(List parsedJson) {
    List<Result> _temp = [];
    for(int i=0; i<parsedJson.length; i++){
      Result _result = Result(parsedJson[i]);
      _temp.add(_result);
    }
    _resultList = _temp;
  }

  List<Result> get resultList => _resultList;
}

class Result{
  int _id;
  String _kecamatan;
  String _kelurahan;
  String _kodePos;

  Result(result){
    _id = result['id'];
    _kecamatan = result['kecamatan'];
    _kelurahan = result['kelurahan'];
    _kodePos = result['kodepos'];
  }

  String get kodePos => _kodePos;

  String get kelurahan => _kelurahan;

  String get kecamatan => _kecamatan;

  int get id => _id;
}