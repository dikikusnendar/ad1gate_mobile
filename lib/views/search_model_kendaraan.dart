import 'package:adira_finance/resources/get_data_model_kendaraan_api_provider.dart';
import 'package:flutter/material.dart';

class SearchModelKendaraan extends StatefulWidget {
  final ValueChanged<Map> onSelected;
  final String idStatusKendaraan;

  const SearchModelKendaraan({Key key, this.onSelected, this.idStatusKendaraan}) : super(key: key);
  @override
  _SearchModelKendaraanState createState() => _SearchModelKendaraanState();
}

class _SearchModelKendaraanState extends State<SearchModelKendaraan> {

  GetDataModelKendaraanApiProvider _getDataModelKendaraanApiProvider;
  var _loadModelKendaraan = false;

  @override
  void initState() {
    super.initState();
    _getDataModelKendaraanApiProvider = GetDataModelKendaraanApiProvider();
  }

  var _listModelKendaraan = [];

  _getDataAllModel(String query) async{
    setState(() {
      _loadModelKendaraan = true;
    });
    var _resultModelKendaraan = await _getDataModelKendaraanApiProvider.getModelKendaraan(query,widget.idStatusKendaraan);
    print("cek status ${_resultModelKendaraan['status']}");
    if(_resultModelKendaraan['status']){
      _listModelKendaraan = _resultModelKendaraan['listModelKendaraan'];

      setState(() {
        _loadModelKendaraan = false;
      });
    }
    else{
      print(_resultModelKendaraan['message']);
      setState(() {
        _loadModelKendaraan = false;
      });
    }
  }

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
              _getDataAllModel(e);
          },
          decoration: new InputDecoration(
            hintText: 'Cari Model Kendaraan',
            hintStyle: TextStyle(
                fontFamily: "NunitoSans", color: Colors.black),
          ),
        ),
      ),
      body: _loadModelKendaraan
          ?
      Center(child: CircularProgressIndicator())
          :
      ListView.builder(
        itemBuilder: (context,int index){
          return ListTile(
            title: Text(
              "${_listModelKendaraan[index]['OBBR_DESC'].trim()} "
                  "- ${_listModelKendaraan[index]['OBMO_DESC'].trim()} - "
                  "${_listModelKendaraan[index]['OBTY_DESC'].trim()}"
              ,style: TextStyle(color: Colors.black),
            ),
            onTap: (){
              widget.onSelected(_listModelKendaraan[index]);
              Navigator.pop(context);
            },
          );
        },
        itemCount: _listModelKendaraan.length,
      ),
    );
  }
}
