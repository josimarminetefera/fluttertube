import 'dart:convert';

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
    //carregado toda vez que eu digitar alguma informação
    print("1");
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder<List>(
        future: sujestoes(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                //para cada um dos dados ele vai chamar um itemBuilder
                return ListTile(
                  title: snapshot.data[index],
                  leading: Icon(Icons.play_arrow),
                  onTap: () {
                    //quando eu tocar na minha sujestão
                  },
                );
              },
              itemCount: snapshot.data.length,
            );
          }
        },
      );
    }
  }

  Future<List> sujestoes(String busca) async {
    print("2");
    http.Response response = await http.get(
      "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$busca&format=5&alt=json",
    );
    print("teste");
    if (response.statusCode == 200) {
      print("opa");
      //se eu tenho um mapa eu uno o .map para percorrer ele melhor que o for
      json.decode(response.body)[1].map(
        (valor) {
          print(valor[0]);
          return valor[0];
        },
      ).toList();
    } else {
      throw Exception("Erro ao carregar os dados.");
    }
  }
}
