import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/store/pokeapi_store.dart';
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
  PokeApiStore _pokemonStore;

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokemonStore.pokemonAtual;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(
          builder: (BuildContext context) {
          return AppBar(
            backgroundColor: _pokemonStore.corPokemon,
            elevation: 0,
            title: Opacity(
              child: Text(
                _pokemon.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              opacity: 0.0,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.favorite_border), onPressed: () {})
            ],
          );
        }),
      ),
      // backgroundColor: _corPokemon,
      body: Stack(
        children: <Widget>[
          Observer(
            builder: (context) {
              return Container(color: _pokemonStore.corPokemon,);
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            elevation: 0,
            cornerRadius: 16,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.7, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: Text('fodase')),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _pokemonStore.setPokemonAtual(index: index);
                },
                itemCount: _pokemonStore.pokeAPI.pokemon.length,
                itemBuilder: (BuildContext context, int count) {
                  Pokemon _pokeitem = _pokemonStore.getPokemon(index: count);
                  return CachedNetworkImage(
                    height: 80,
                    width: 80,
                    placeholder: (context, url) => Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    imageUrl:
                        'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png',
                  );
                  // return _pokemonStrore.getImage(numero: pokemon.num);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
