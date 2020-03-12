import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/models/pokeapi.dart';
part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  PokeAPI _pokeAPI;

  @observable
  Pokemon _pokemonAtual;

  @computed
  PokeAPI get pokeAPI => _pokeAPI;

  @action
  getPokemon({int index}) {
    return _pokeAPI.pokemon[index];
  }

  @action
  setPokemonAtual({int index}) {
    _pokemonAtual = _pokeAPI.pokemon[index];
  }

  @action
  Pokemon get getPokemonAtual{
    return _pokemonAtual;
  }

  @action
  fetchPokemonList() {
    _pokeAPI = null;
    loadPokeAPI().then((pokeList) {
      _pokeAPI = pokeList;
    });
  }

  Future<PokeAPI> loadPokeAPI() async {
    try {
      final response = await http.get(ConstsAPI.pokeapiURL);
      var decodeJson = jsonDecode(response.body);
      return PokeAPI.fromJson(decodeJson);
    } catch (error, stacktrace) {
      print("Erro ao carregar a lista" + stacktrace.toString());
      return null;
    }
  }

  @action
  Widget getImage({String numero}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: CachedNetworkImage(
        height: 110,
        width: 110,
        placeholder: (context, url) => new Container(
          child: CircularProgressIndicator(),
        ),
        imageUrl:
            'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$numero.png',
      ),
    );
  }
}
