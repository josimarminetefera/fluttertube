import 'package:fluttertube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'dart:async';

class VideosBloc implements BlocBase {
  //o bloc sera a ponte entre a api e os tiles
  Api api;

  //quando coloco os videos aqui dentro autimaticamente ele já vai chamar o sink e ja sai no Stream
  List<Video> videos;

  //nao quero ter acesso fora do bloc
  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();

  //externamente só vou falar com esta variavel pois as outras ficaram internas
  Stream get sairVideos => _videosController.stream;

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
      //para limpar a lista quando eu pesquiso algo novo
      //ele refaz a tela com uma lista vazia e depois sim carrega a lista nova
      _videosController.sink.add([]);
      videos = await api.buscarSujestao(busca);
    } else {
      //juntando duas listas com +=
      videos += await api.proximaPagina();
    }
    _videosController.sink.add(videos); //isso passa os videos para a entrada do Stream > depois é chamado a saida dele
  }

  @override
  void dispose() {
    //toda vez que voce for usar uma stream voce tem que fechar para não prejudicar a preformance.
    _videosController.close();
    _buscaController.close();
  }
}
