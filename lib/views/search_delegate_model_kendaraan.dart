import 'package:flutter/material.dart';

class SearchDelegateModelKendaraan extends SearchDelegate<String>{
  final List _listJenisKendaraan;
  final ValueChanged<Map> _onSelected;

  SearchDelegateModelKendaraan(this._listJenisKendaraan, this._onSelected);

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
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<Map> _suggestions = _listJenisKendaraan.where((listKendaraan) => listKendaraan['model'].toLowerCase().contains(query));
    return ListView.builder(
      itemBuilder: (context,index){
        return ListTile(
          title: Text(
              "${_suggestions.toList()[index]['model']} - "
              "${_suggestions.toList()[index]['tipe']} - "
              "${_suggestions.toList()[index]['merk']}",
            style: TextStyle(color: Colors.black,fontFamily: "NunitoSans"),
          ),
          onTap: (){
            print(_suggestions.toList()[index]);
            _onSelected(_suggestions.toList()[index]);
            close(context, null);
          },
        );
      },
      itemCount: _suggestions.toList().length,
    );
  }

}