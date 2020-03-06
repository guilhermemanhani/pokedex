import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/pages/home_page/widgets/app_bar_home.dart';
import 'package:pokedex/pages/home_page/widgets/poke_item.dart';
import 'package:pokedex/store/pokeapi_store.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeApiStore pokeApiStore;
  @override
  void initState(){
    super.initState();
    pokeApiStore = PokeApiStore();
    pokeApiStore.fetchPokemonList();
  } 

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double statusWidth = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: -(240 / 4.7),
            left: screenWidth - (240 / 1.6),
            child: Opacity(
              child: Image.asset(
                ConstsApp.blackPokeball,
                height: 240,
                width: 240,
              ),
              opacity: 0.2,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: statusWidth,
                  // color: Colors.red,
                ),
                AppBarHome(),
                Expanded(
                  child: Observer(
                    name: "ListaHomePage",
                    builder: (BuildContext context){
                      PokeAPI _pokeApi = pokeApiStore.pokeAPI;
                      return (_pokeApi != null) 
                      ? AnimationLimiter(
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(12),
                          addAutomaticKeepAlives: false,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemCount: pokeApiStore.pokeAPI.pokemon.length,
                          itemBuilder: (context, index){                
                            Pokemon pokemon = pokeApiStore.getPokemon(index: index);
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds:  375),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PokeItem(
                                      types: pokemon.type,
                                      index: index, 
                                      nome: pokemon.name, 
                                      image: pokeApiStore.getImage(numero: pokemon.num),
                                      ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context, 
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => Container(),
                                      fullscreenDialog: true,
                                    ));
                                  },
                                ),
                              ),            
                            );
                          },
                        ),
                        )
                      : Center(
                        child: CircularProgressIndicator()
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
