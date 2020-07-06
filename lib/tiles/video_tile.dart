import 'package:flutter/material.dart';
import 'package:fluttertube/models/video_models.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  const VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, //largura total
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.network(
              video.imagemVideo,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        video.titulo,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        video.canal,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                color: Colors.white,
                iconSize: 30.0,
                icon: Icon(Icons.star_border),
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
