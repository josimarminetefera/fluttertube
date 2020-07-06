import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/tiles/buscar_delegate_tile.dart';
import 'package:fluttertube/tiles/video_tile.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/youtube-logo-1.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          IconButton(
            icon: Stack(
              children: <Widget>[
                Icon(Icons.star),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: new Text(
                      '10',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String resultado = await showSearch(
                  context: context, delegate: BuscarDelegateTile());
              if (resultado != null) {
                BlocProvider.of<VideosBloc>(context).entrarBusca.add(resultado);
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        //toda vez que tiver alguma atualização na stream
        stream: BlocProvider.of<VideosBloc>(context).sairVideos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                //para cada um dos itens tendo que resgatar uma imagem e um titulo
                if (index < snapshot.data.length) {
                  //quando eu chegar no item 10 (ultimo pois começa no 0) ele vai tentar recarregar
                  return VideoTile(snapshot.data[index]);
                } else {
                  //caso seja maior que 10 é um item que ainda tenho que buscar
                  //passo null para ele pular para a proxima pagina
                  BlocProvider.of<VideosBloc>(context).entrarBusca.add(null);
                  return Container(
                    height: 40.0,
                    width: 40.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
