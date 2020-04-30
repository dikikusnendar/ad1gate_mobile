import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchDealerDelegate extends SearchDelegate<String>{

  final List _words;
  final ValueChanged<Map> onSelected;

  SearchDealerDelegate(this._words, this.onSelected);

//  SearchDealerDelegate(List words, this.onSelected)
//      : _words = words, _history = <String>["Agung Abadi Motor","Berkat Motor"],super();

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
    return SizedBox();
//    final Iterable suggestions = _words.where((word) => word.startsWith(query.toLowerCase()));
//
//    return suggestions.isEmpty
//        ?
//    Center(child:Text("Dealer cabang tidak tersedia"))
//        :
//    _WordSuggestionList(
//      query: this.query,
//      suggestions: suggestions.toList(),
//      onSelected: (String suggestion) {
//        this.query = suggestion;
//        this._history.insert(0, suggestion);
//        onSelected(query);
//        this.close(context, null);
//      },
//    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable suggestions = _words.where((word) => word['SZBRANCHNAME'].contains(query.toLowerCase()));
    return ListView.builder(
      itemBuilder: (context,index){
        return ListTile(
          title: Text("${suggestions.toList()[index]['SZBRANCHNAME']} "
            ,style: TextStyle(color: Colors.black),
          ),
          onTap: (){
            onSelected(suggestions.toList()[index]);
            close(context, null);
          },
        );
      },
      itemCount: suggestions.toList().length,
    );
  }

}

// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}

class CustomLocalizationDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<MaterialLocalizations> load(Locale locale) => SynchronousFuture<MaterialLocalizations>(const CustomLocalization());

  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;

  @override
  String toString() => 'CustomLocalization.delegate(en_US)';
}

class CustomLocalization extends DefaultMaterialLocalizations {
  const CustomLocalization();

  @override
  String get searchFieldLabel => "Cari dealer cabang";

}
