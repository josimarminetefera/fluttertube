import 'dart:convert';

import 'package:fluttertube/models/video.dart';
import 'package:http/http.dart' as http;

//esta api que usa para buscar videos dar play no video
const API_KEY = "AIzaSyDimbTNmz1ytHEJARqdZd_fm-RY1JrWdu0"; // coloque sua própria API KEY!!!

//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
//"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

class Api {
  String _buscaValor;
  String _proximoToken;

  Future<List<Video>> buscarSujestao(String busca) async {
    _buscaValor = busca;

    http.Response response = await http.get("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$busca&type=video&key=$API_KEY&maxResults=10");

    return decodificar(response);
  }

  Future<List<Video>> proximaPagina() async {
    http.Response response = await http.get("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_buscaValor&type=video&key=$API_KEY&maxResults=10&pageToken=$_proximoToken");

    return decodificar(response);
  }

  //decodificar o json do objeto Video
  List<Video> decodificar(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      _proximoToken = decoded["nextPageToken"];
      //jogando tudo dentro de uma lista de Videos
      List<Video> videos = decoded["items"].map<Video>(
        //temos que passar uma função que vai receber o map cada map é um video
        (map) {
          return Video.paraVideo(map);
        },
      ).toList();
      return videos;
    } else {
      throw Exception("Erro ao receber dados dos vídeos!");
    }
  }
}
