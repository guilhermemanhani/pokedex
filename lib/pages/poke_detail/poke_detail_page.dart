import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/store/pokeapi_store.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatefulWidget {
  final int index;

  PokeDetailPage({Key key, this.index}) : super(key: key);

  @override
  _PokeDetailPageState createState() => _PokeDetailPageState();
}

class _PokeDetailPageState extends State<PokeDetailPage> {
  PageController _pageController;
  Pokemon _pokemon;
  PokeApiStore _pokemonApiStore;
  MultiTrackTween _animation;
  MultiTrackTween _animationCircular;
  double _progress;
  double _multiple;
  double _opacity;
  double _opacityTitleAppBar;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokemonApiStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokemonApiStore.pokemonAtual;
    _animation = MultiTrackTween([
      Track("rotation").add(Duration(seconds: 3), Tween(begin: 0.0, end: 6.3),
          curve: Curves.elasticInOut)
    ]);
    _animationCircular = MultiTrackTween([
      Track("rotationCircular").add(
          Duration(seconds: 3), Tween(begin: 0.0, end: 6.3),
          curve: Curves.linear)
    ]);
    _progress = 0;
    _multiple = 1;
    _opacity = 1;
    _opacityTitleAppBar = 0;
  }

  double interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(builder: (BuildContext context) {
          return criaAppBar();
        }),
      ),
      body: body(context, _pokemonApiStore),
    );
  }

  Widget body(context, PokeApiStore _pokeApiStore) {
    return Stack(
      children: <Widget>[
        constroiFundoImage(),
        constroiWidgetImage(),
        SlidingSheet(
          listener: (state) {
            setState(() {
              _progress = state.progress;
              _multiple = 1 - interval(0.0, 0.7, _progress);
              _opacity = _multiple;
              _opacityTitleAppBar = _multiple = interval(0.55, 0.8, _progress);
            });
          },
          elevation: 0,
          cornerRadius: 30,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.7, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: DefaultTabController(
                  initialIndex: 0,
                  length: 3,
                  child: Scaffold(
                    appBar: TabBar(
                      indicatorColor: _pokemonApiStore.corPokemon,
                      unselectedLabelColor: Colors.grey,
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                      unselectedLabelStyle:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      // indicatorSize: true,
                      indicatorWeight: 5.0,
                      labelColor: Colors.black,
                      tabs: <Widget>[
                        Tab(
                          child: Text("Sobre"),
                        ),
                        Tab(
                          child: Text("Evolução"),
                        ),
                        Tab(
                          child: Text("Status"),
                        ),
                      ],
                    ),
                    body: Padding(
                      padding: EdgeInsets.all(20),
                      child: Observer(builder: (context) {
                        return TabBarView(
                          children: <Widget>[
                            construirSobre(context),
                            Text("evolucao????"),
                            Text("status????"),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Opacity(
          opacity: _opacity,
          child: Padding(
            padding: EdgeInsets.only(
                top: _opacityTitleAppBar == 1 ? 1000 : 60 - _progress * 60),
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _pokemonApiStore.setPokemonAtual(index: index);
                },
                itemCount: _pokemonApiStore.pokeAPI.pokemon.length,
                itemBuilder: (BuildContext context, int count) {
                  Pokemon _pokeitem = _pokemonApiStore.getPokemon(index: count);
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ControlledAnimation(
                        playback: Playback.LOOP,
                        duration: _animation.duration,
                        tween: _animation,
                        builder: (context, animation) {
                          return Transform.rotate(
                            child: Hero(
                              child: Opacity(
                                child: Image.asset(
                                  ConstsApp.blackPokeball,
                                  height: 150,
                                  width: 150,
                                ),
                                opacity: 0.5,
                              ),
                              tag: _pokeitem.name + "rotation",
                            ),
                            angle: animation["rotation"],
                          );
                        },
                      ),
                      Observer(builder: (context) {
                        return AnimatedPadding(
                            child: Hero(
                              tag: _pokemonApiStore.pokemonAtual.name,
                              child: CachedNetworkImage(
                                height: 160,
                                width: 160,
                                placeholder: (context, url) => Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                color: count == _pokemonApiStore.posicaoAtual
                                    ? null
                                    : Colors.black.withOpacity(0.5),
                                imageUrl:
                                    'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png',
                              ),
                            ),
                            duration: Duration(milliseconds: 500),
                            padding: EdgeInsets.all(
                                count == _pokemonApiStore.posicaoAtual
                                    ? 0
                                    : 60));
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget constroiFundoImage() {
    return Observer(
      builder: (context) {
        return Hero(
          tag: _pokemonApiStore.corPokemon,
          child: Container(
            color: _pokemonApiStore.corPokemon,
          ),
        );
      },
    );
  }

  Widget criaAppBar() {
    return AppBar(
      backgroundColor: _pokemonApiStore.corPokemon,
      elevation: 0,
      title: Opacity(
        child: Text(
          _pokemon.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
        opacity: _opacityTitleAppBar,
      ),
      leading: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ControlledAnimation(
                  playback: Playback.LOOP,
                  duration: _animation.duration,
                  tween: _animationCircular,
                  builder: (context, animation) {
                    return Transform.rotate(
                      child: Opacity(
                          child: Image.asset(
                            ConstsApp.whitePokeball,
                            height: 60,
                            width: 60,
                          ),
                          opacity: _opacityTitleAppBar >= 0.2 ? 0.4 : 0.0),
                      angle: animation['rotationCircular'],
                    );
                  }),
              IconButton(icon: Icon(Icons.favorite_border), onPressed: () {})
            ],
          ),
        ),
      ],
    );
  }

  Widget constroiWidgetImage() {
    return Observer(
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        _pokemonApiStore.pokemonAtual.name,
                        style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "#${_pokemonApiStore.pokemonAtual.num}",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(top: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(80, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(_pokemonApiStore.pokemonAtual.type[0],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[100])),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromARGB(80, 255, 255, 255)),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              //mudar poke
                              print("deu certo");
                            },
                          ),
                        ),
                      ),
                      //Icons.arrow_back_ios
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromARGB(80, 255, 255, 255)),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              //mudar poke
                              print("deu certo");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget construirSobre(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Descrição",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "A perennial favorite of children everywhere, "
            "the taste of a good chocolate chip cookie can't be overstated. Whereas "
            "the chip can provide a range of consistency from gooey to crumbly, the "
            "dough gives that satisfying crunchy-on-the-outside, chewy-on-the-inside "
            "texture.",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "Biologia",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),),
          construirBiologiaInf("Espécie", _pokemonApiStore.pokemonAtual.type[0]),
          construirBiologiaInf("Altura", _pokemonApiStore.pokemonAtual.height),
          construirBiologiaInf("Peso", _pokemonApiStore.pokemonAtual.weight),
          construirBiologiaInf("Anatomia", _pokemonApiStore.pokemonAtual.candy),
         
      ],
    );
  }

  Widget construirBiologiaInf(text1, text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("$text1"),
        Padding(padding: EdgeInsets.only(left: 50)),
        Text(
          "$text2",
          // textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Column(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     BrandSelector(brands: ["Sobre", "Evolução", "Status"]),
//                     Container(
//                       margin: EdgeInsets.only(left: 15, right:15),
//                       alignment: Alignment.bottomLeft,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: <Widget>[
//                           Text("Descrição",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold
//                           ),
//                           ),
//                           Text("Procurar a url que tiro a descrição"),
//                           Text("Biologia",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold
//                           ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text("Espécie"),
//                               Text("${_pokemonApiStore.pokemonAtual.type[0]} Pokémon"),
//                             ],
//                             ),
//                         ],
//                       )
//                     ),
//                   ],
//                 ),
