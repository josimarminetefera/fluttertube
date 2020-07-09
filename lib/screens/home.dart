import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites.dart';
import 'package:fluttertube/widgets/videotile.dart';

class Home extends StatelessWidget {
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
          montarBotaoFavorito(context),
          montarBotaoFavoritoPior(context),
          montarBotaoPesquisar(context),
        ],
      ),
      backgroundColor: Colors.black87,
      body: montarTelaPrincipal(context),
    );
  }

  StreamBuilder montarTelaPrincipal(BuildContext context) {
    return StreamBuilder(
      //toda vez que tiver alguma atualização na stream
      stream: BlocProvider.of<VideosBloc>(context).sairVideos, //aqui é a saida do video carregado la no videos_bloc
      initialData: [],//quando na tem nenhum video ele tem que colocar mais um ai o entrarBusca tenta chamar
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return ListView.builder(
            itemBuilder: (context, index) {
              //para cada um dos itens tendo que resgatar uma imagem e um titulo
              if (index < snapshot.data.length) {
                //se vor um item valido retorna o tile
                //enquanto estiver nos itens normais carregados ou seja até o 9 ele carrega o tile normal
                return VideoTile(snapshot.data[index]);
              } else if (index > 1) {//não conta quando tem apenas 1
                //caso seja maior que 9 é um item que ainda tenho que buscar
                //passo null para ele pular para a proxima pagina
                //com este entrar ele vai chamar a função _buscar
                BlocProvider.of<VideosBloc>(context).entrarBusca.add(null);
                return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              } else {
                //acabamos de abrir o app e não tem nada pesquisado
                return Container();
              }
            },
            itemCount: snapshot.data.length + 1,//passa um item a mais que a lista original
          );
        else
          return Container();
      },
    );
  }

  Row montarBotaoFavoritoPior(BuildContext context) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: StreamBuilder<Map<String, Video>>(
            stream: BlocProvider.of<FavoriteBloc>(context).outFav,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  "${snapshot.data.length}",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                );
              else
                return Container();
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.star),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorites()));
          },
        ),
      ],
    );
  }

  IconButton montarBotaoFavorito(BuildContext context) {
    return IconButton(
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
              child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.of<FavoriteBloc>(context).outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      "${snapshot.data.length}",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    );
                  else
                    return Container();
                },
              ),
            ),
          )
        ],
      ),
      onPressed: () {},
    );
  }

  IconButton montarBotaoPesquisar(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () async {
        String result = await showSearch(context: context, delegate: DataSearch());
        if (result != null) {
          BlocProvider.of<VideosBloc>(context).entrarBusca.add(result);
        }
      },
    );
  }
}
