import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/blocs/favorito_bloc.dart';
import 'package:fluttertube/models/video.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FlutterYoutube.playYoutubeVideoById(
          apiKey: API_KEY,
          videoId: video.id,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, //largura total
          children: <Widget>[
            montarVideo(),
            montarDescricaoEBotaoFavorito(context),
          ],
        ),
      ),
    );
  }

  Row montarDescricaoEBotaoFavorito(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  video.title,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  video.channel,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              )
            ],
          ),
        ),
        montarBotaoFavorito(context),
      ],
    );
  }

  StreamBuilder<Map<String, Video>> montarBotaoFavorito(BuildContext context) {
    //para carregar o StreamBuilder
    return StreamBuilder<Map<String, Video>>(
      stream: BlocProvider.of<FavoritosBloc>(context).saidaFavoritos, //toda vez que eu modificar o mapa de favoritos eu refaço o botão
      builder: (context, snapshot) {
        //snapshot vai conter toda a lista de favoritos que eu marquei
        if (snapshot.hasData) {
          return IconButton(
            icon: Icon(
              //o cideo montado está na lista de favoritos
              snapshot.data.containsKey(video.id) ? Icons.star : Icons.star_border,
            ),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              //adiciono ou removo o video do favorito
              BlocProvider.of<FavoritosBloc>(context).ligarDesligarFavorito(video);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  AspectRatio montarVideo() {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Image.network(
        video.thumb,
        fit: BoxFit.cover,
      ),
    );
  }
}
