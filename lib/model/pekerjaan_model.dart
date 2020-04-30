class PekerJaanModel{
  List<ResultPekerjaan> _resultListPekerjaan = [];

  PekerJaanModel.fromJson(List parsedJson){
    List<ResultPekerjaan> _temp = [];
    for(int i=0; i<parsedJson.length; i++){
      ResultPekerjaan _result = ResultPekerjaan(parsedJson[i]);
      _temp.add(_result);
    }
    _resultListPekerjaan = _temp;
    print("cek hasil ${_resultListPekerjaan[0]._id}");
  }

  List<ResultPekerjaan> get resultListPekerjaan => _resultListPekerjaan;
}

class ResultPekerjaan{
 int _id;
 String _occupationCode;
 String _occupationDesc;

 ResultPekerjaan(resultPekerjaan){
   _id = resultPekerjaan['id'];
   _occupationCode = resultPekerjaan['occupation_code'];
   _occupationDesc = resultPekerjaan['occupation_desc'];
 }

 String get occupationDesc => _occupationDesc;

 String get occupationCode => _occupationCode;

 int get id => _id;
}