import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuscarDelegateTile extends SearchDelegate<String> {
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
    //caso queira mostrar os resultados de videos na propria tela de pesquisa
    //buil desenha a tela então quando dou só close ele esta desenhando e sai da tela desenhando então da erro
    //então mudo para ele aguardar o desenho terminar e depois passar para a proxima tela
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //carregado toda vez que eu digitar alguma informação
    if (query.isEmpty) {
      return Container();
    } else {
      //busca as sujestões na api do youtube
      return FutureBuilder<List>(
        future: sujestoes(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //teve valor na busca
            return ListView.builder(
              itemBuilder: (context, index) {
                //para cada um dos dados ele vai chamar um itemBuilder
                return ListTile(
                  title: Text(snapshot.data[index]),
                  leading: Icon(Icons.play_arrow),
                  onTap: () {
                    //quando eu tocar na minha sujestão
                    close(context, snapshot.data[index]);
                  },
                );
              },
              //eu sei a quantidade de itens
              itemCount: snapshot.data.length,
            );
          }
        },
      );
    }
  }

  Future<List> sujestoes(String busca) async {
    http.Response response = await http.get("http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$busca&format=5&alt=json");
    if (response.statusCode == 200) {
      //se eu tenho um mapa eu uno o .map para percorrer ele melhor que o for
      return json.decode(response.body)[1].map(
        (v) {
          return v[0];
        },
      ).toList();
    } else {
      throw Exception("Erro ao carregar os dados.");
    }
  }
}
