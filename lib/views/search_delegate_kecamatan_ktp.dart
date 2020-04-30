import 'dart:ffi';

import 'package:adira_finance/blocs/bloc_kecamatan.dart';
import 'package:adira_finance/db_helper/database_helper.dart';
import 'package:adira_finance/model/kecamatan_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchDelegateKecamatanKTP extends SearchDelegate<KecamatanModel>{

  final List<Result> _listKecamatan;
  final ValueChanged<Result> _onSelected;

  SearchDelegateKecamatanKTP(this._listKecamatan, this._onSelected);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty ?
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ) : SizedBox(width: 0.0,height: 0.0)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return
      IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation,
          ),
          onPressed: () {
            query = '';
            close(context, null);
          }
      );
  }


  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<Result> _suggestion = _listKecamatan.where((e) => e.kecamatan.toLowerCase().contains(query));

    return
//      StreamBuilder<KecamatanModel>(
//          builder: (BuildContext context,AsyncSnapshot<KecamatanModel> snapshot){
//            print(snapshot.data.resultList.length);
//            if(!snapshot.hasData){
//              return Center(
//                child: Text("No Data!"),
//              );
//            }
//            else{
//              Center(child: Text(snapshot.data.resultList[0].kecamatan));
//            }
//            return Center(child: CircularProgressIndicator());},
//          stream: _blocKecamatan
//      );
      ListView.builder(
        itemBuilder: (context,index){
          return ListTile(
            title: Text("${_suggestion.toList()[index].kecamatan} "
                "- ${_suggestion.toList()[index].kelurahan}"
              ,style: TextStyle(color: Colors.black),
            ),
            onTap: (){
              _onSelected(_suggestion.toList()[index]);
              close(context, null);
            },
          );
        },
        itemCount: _suggestion.toList().length,
      );
  }

  @override
  String get searchFieldLabel => 'Cari kecamatan';
}