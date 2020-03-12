import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/store/pokeapi_store.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatelessWidget {
  final int index;

  PokeDetailPage({Key key, this.index}) : super(key: key);

  Color _corPokemon;

  @override
  Widget build(BuildContext context) {
    final _pokemonStrore = Provider.of<PokeApiStore>(context);
    Pokemon _pokemon = _pokemonStrore.getPokemon(index: this.index);
    _corPokemon = ConstsAPI.getColorType(type: _pokemon.type[0]);
    return Observer(
      builder: (BuildContext context){
        return Scaffold(
        appBar: AppBar(
          backgroundColor: _corPokemon,
          elevation: 0,
          title: Opacity(
            child: Text(
              _pokemon.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21
              ),
            ),          
            opacity: 0.0,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.favorite_border), 
            onPressed: (){

            })
          ],
        ),
        backgroundColor: _corPokemon,
        body: Stack(
          children: <Widget>[
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
              builder: (context, state){
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text('fodase')
                  ),
                );
              },
            ),
            Positioned(
              child: SizedBox(
                height: 200,
                child: PageView.builder(     
                  itemCount: _pokemonStrore.pokeAPI.pokemon.length,         
                  itemBuilder: (BuildContext context, int count){
                    Pokemon _pokeitem = _pokemonStrore.getPokemon(index: count);           
                    return CachedNetworkImage(
                      height: 80,
                      width: 80,
                      placeholder: (context, url) => Container(
                        child: Center(child: CircularProgressIndicator(),),
                      ),
                      imageUrl: 'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png',
                    );
                    // return _pokemonStrore.getImage(numero: pokemon.num);
                  },
                ),
              ),
            ),
          ],
        ),
        );
      },
    );
  }
}