import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritosBloc implements BlocBase {
  Map<String, Video> _favoritos = {}; //para salvar o id e o video

  final _favoritoController = BehaviorSubject<Map<String, Video>>(seedValue: {});

  Stream<Map<String, Video>> get saidaFavoritos => _favoritoController.stream;

  FavoritosBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favorites")) {
        _favoritos = json.decode(prefs.getString("favorites")).map((k, v) {
          return MapEntry(k, Video.paraVideo(v));
        }).cast<String, Video>();

        _favoritoController.add(_favoritos);
      }
    });
  }

  //pode ser enviado informação para o bloc de duas formas
  // um voce pode usar o exemplo do entrarBusca
  //segundo pode ser criado uma função

  void toggleFavorito(Video video) {
    if (_favoritos.containsKey(video.id)) {
      //este video já esta no meu mapa de favoritos
      _favoritos.remove(video.id);
    } else {
      //nao esta no mapa vou adicionar
      _favoritos[video.id] = video;
    }

    //assim o lugar que eu tiver o saidaFavoritos sendo observado , vai atualizar
    _favoritoController.sink.add(_favoritos);

    _salvarFavoritos();
  }

  void _salvarFavoritos() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favoritos));
    });
  }

  @override
  void dispose() {
    //sempre tem que fechar o close
    _favoritoController.close();
  }
}
