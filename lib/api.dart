import 'dart:convert';

import 'package:fluttertube/models/video_models.dart';
import 'package:http/http.dart' as http;

//esta api que usa para buscar videos dar play no video
const API_KEY = "AIzaSyBNKwBnydbDCJaSzjsQElDqDFfAZDSiaHQ";

//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
//"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

class Api {
  buscar(String busca) async {
    http.Response response = await http.get(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$busca&type=video&key=$API_KEY&maxResults=10",
    );
    decodificar(response);
  }

  List<Video> decodificar(http.Response response){
    //verificar se o codigo foi 200
    if(response.statusCode == 200){
      var decodificado = json.decode(response.body);

      //jogando tudo dentro de uma lista de Videos
      List<Video> videos = decodificado["items"].map<Video>(
        //temos que passar uma função que vai receber o map cada map é um video
          (map){
            return Video.paraJson(map);
          }
      ).toList();
      print(videos);
      return videos;
    }
  }
}