import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:simple_animations/simple_animations.dart';

class PokeItem extends StatefulWidget {
  final String nome;
  final int index;
  final Color color;
  final String num;
  final List<String> types;
  const PokeItem(
      {Key key, this.nome, this.index, this.color, this.num, this.types})
      : super(key: key);

  @override
  _PokeItemState createState() => _PokeItemState();
}

class _PokeItemState extends State<PokeItem> {
  MultiTrackTween _animation;

  @override
  void initState() {
    super.initState();
    _animation = MultiTrackTween([
      Track("rotation").add(Duration(seconds: 3), Tween(begin: 0.0, end: 6.3),
          curve: Curves.linear)
    ]);
  }

  Widget setTipos() {
    List<Widget> list = [];
    widget.types.forEach((poke) {
      list.add(Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(80, 255, 255, 255)),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(poke.trim(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[100])),
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ));
    });
    return Column(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: ConstsAPI.getColorType(type: widget.types[0]),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(1.0, 6.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: <Widget>[
              ControlledAnimation(
                playback: Playback.LOOP,
                duration: _animation.duration,
                tween: _animation,
                builder: (context, animation) {
                  return Transform.rotate(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Hero(
                          child: Opacity(
                            child: Image.asset(ConstsApp.blackPokeball),
                            opacity: 0.4,
                          ),
                          tag: widget.nome + "rotation",
                        ),
                      ),
                      angle: animation["rotation"]);
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Hero(
                  tag: widget.nome,
                  child: CachedNetworkImage(
                    height: 120,
                    width: 120,
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(),
                    ),
                    imageUrl:
                        'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${widget.num}.png',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.nome,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[200]),
                    ),
                    setTipos(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
