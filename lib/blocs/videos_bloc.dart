import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video_models.dart';

class VideosBloc implements BlocBase {
  //o bloc sera a ponte entre a api e os widgets
  Api api;

  //quando coloco os vvideos aqui dentro autimaticamente ele já vai chamar o sink e ja sai no Stream
  List<Video> videos;

  //nao quero ter acesso fora do bloc
  final StreamController<List<Video>> _streamController =
      StreamController<List<Video>>();

  //externamente só vou falar com esta variavel pois as outras ficaram internas
  Stream get sairVideos => _streamController.stream;

  //passar da dos para dentro de um bloc
  //vou receber dados de fora
  final StreamController<String> _buscaController = StreamController<String>();

  //toda vez que eu colocar algum dado dentro do _buscarController uso esta entrada
  Sink get entrarBusca => _buscaController.sink;

  VideosBloc() {
    api = Api();
    _buscaController.stream.listen(_buscar);
  }

  //o que for passado dentro de entrarBusca vem como paremetro
  void _buscar(String busca) async {
    if (busca != null) {
      videos = await api.buscar(busca);
    } else {
      videos += await api.proximaPagina();
    }
    _streamController.sink.add(videos);
  }

  @override
  void dispose() {
    //toda vez que voce for usar uma stream voce tem que fechar para não prejudicar a preformance.
    _streamController.close();
    _buscaController.close();
  }
}
