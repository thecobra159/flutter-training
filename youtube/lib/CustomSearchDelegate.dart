import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, "");
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> list = new List();

    if(query.isNotEmpty) {
      list = [
        "Game of Thrones",
        "You",
        "Resumão",
        "Sex Education",
        "História do Cinema",
        "Entrevista"
      ].where((text) => text.toLowerCase().startsWith(query.toLowerCase())).toList();
    }

    return ListView.builder(
        itemCount: list.length,
      itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              close(context, list[index]);
            },
            title: Text(list[index]),
          )
;      },
    );
  }
}
