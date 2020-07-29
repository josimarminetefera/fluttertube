import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritosBloc implements BlocBase {
  Map<String, Video> _favoritos = {}; //para salvar o id e o video que eu marquei

  //caso queira que várias instancias acessem ao mesmo tempo pode usar o broadcard, pois na tela de videos aparecem várias botões de favorito ai cada um deles aciona uma instancia
  final StreamController _favoritoController = BehaviorSubject<Map<String, Video>>(seedValue: {});

  //como eu vou chegar neste bloc aqui será a saida do tudo de controller
  Stream<Map<String, Video>> get saidaFavoritos => _favoritoController.stream;

  //salvar permanetemente a lista de favoritos
  FavoritosBloc() {
    _abrirFavoritosSalvos();
  }

  //pode ser enviado informação para o bloc de duas formas
  // um voce pode usar o exemplo do entrarBusca com listener e função
  //segundo pode ser criado uma função

  //esta ligado ou desligado o video
  void ligarDesligarFavorito(Video video) {
    if (_favoritos.containsKey(video.id)) {
      //este video já esta no meu mapa de favoritos então eu removo
      _favoritos.remove(video.id);
    } else {
      //nao esta no mapa vou adicionar no meu mapa
      _favoritos[video.id] = video;
    }

    //assim o lugar que eu tiver o saidaFavoritos sendo observado , vai atualizar
    _favoritoController.sink.add(_favoritos);

    _salvarFavoritos();
  }

  void _abrirFavoritosSalvos() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favorites")) {
        //vou salvar a lista de videos em json
        _favoritos = json.decode(prefs.getString("favorites")).map((k, v) {
          //mapear um mapa por isso tem duas variaveis (k, v)
          return MapEntry(k, Video.paraVideo(v));
        }).cast<String, Video>();

        //assim que entra no app ele vai carregar para o meu sink
        //assim todos lugares que estão apontados para o sairFavorito vao receber atualizações
        _favoritoController.add(_favoritos);
      }
    });
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
