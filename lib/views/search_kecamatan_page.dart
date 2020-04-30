import 'package:adira_finance/resources/get_data_kecamatan_api_provider.dart';
import 'package:flutter/material.dart';

class SearchkecamatanPage extends StatefulWidget {
  final ValueChanged<Map> onSelected;

  const SearchkecamatanPage({Key key, this.onSelected}) : super(key: key);
  @override
  _SearchkecamatanPageState createState() => _SearchkecamatanPageState();
}

class _SearchkecamatanPageState extends State<SearchkecamatanPage> {
  GetDataKecamatanApiProvider _getDataKecamatanApiProvider;
  var _loadDataKecamatan  = false;

  @override
  void initState() {
    super.initState();
    _getDataKecamatanApiProvider = GetDataKecamatanApiProvider();
  }

  _getDataAllKecamatan(String kecamatanQuery) async{
    print(kecamatanQuery);
    setState(() {
      _loadDataKecamatan = true;
    });
    var _resultKecamatan = await _getDataKecamatanApiProvider.getAllKecamatan(kecamatanQuery);
    if(_resultKecamatan['status']){
      _listKecamatan = _resultKecamatan['listAllKecamatan'];
      setState(() {
        _loadDataKecamatan = false;
      });
    }
    else{
      print(_resultKecamatan['message']);
      setState(() {
        _loadDataKecamatan = false;
      });
    }
  }
  var _listKecamatan = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          style: new TextStyle(color: Colors.black),
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (e){
            if(e.isNotEmpty || e != null)
            _getDataAllKecamatan(e);
          },
          decoration: new InputDecoration(
            hintText: 'Cari Kecamatan',
            hintStyle: TextStyle(
                fontFamily: "NunitoSans", color: Colors.black),
          ),
        ),
      ),
      body: _loadDataKecamatan
          ?
      Center(child: CircularProgressIndicator())
          :
      ListView.builder(
        itemBuilder: (context,int index){
          return ListTile(
            title: Text(
              "${_listKecamatan[index]['PARA_KECAMATAN_DESC'].trim()} "
                  "- ${_listKecamatan[index]['PARA_KELURAHAN_DESC'].trim()} - "
                  "${_listKecamatan[index]['PARA_KELURAHAN_ZIP_CODE'].trim()}"
              ,style: TextStyle(color: Colors.black),
            ),
            onTap: (){
              widget.onSelected(_listKecamatan[index]);
              Navigator.pop(context);
            },
          );
        },
        itemCount: _listKecamatan.length,
      )
    );
  }
}
