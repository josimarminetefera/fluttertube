import 'package:flutter/foundation.dart';

class Video {
  final String id;
  final String titulo;
  final String imagemVideo;
  final String canal;

  Video({
    this.id,
    this.titulo,
    this.imagemVideo,
    this.canal,
  });

  //quando eu passar um json para o construtor ele vai converter para um objeto
  factory Video.paraVideo(Map<String, dynamic> json) {
    return Video(
      id: json["id"]["videoId"],
      titulo: json["snippet"]["title"],
      imagemVideo: json["snippet"]["thumbnails"]["high"]["url"],
      canal: json["snippet"]["channelTitle"],
    );
  }
}
