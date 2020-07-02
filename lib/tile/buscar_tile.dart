import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuscarTile extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // botão que fica no topo do lado direito
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //o que vai ficar no canto esquerdo da pesquisa
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  sujestoes(String busca) async {
    http.Response response = await http.get(
      "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$busca&format=5&alt=json",
    );
  }
}
