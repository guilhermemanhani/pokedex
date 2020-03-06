import 'package:flutter/material.dart';
import 'package:pokedex/consts/consts_app.dart';

class PokeItem extends StatelessWidget {
  final String nome;
  final int index;
  final Color color;
  final Widget image;
  final List<String> types;
  const PokeItem({Key key, this.nome, this.index, this.color, this.image, this.types}) 
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Stack(
          children: <Widget>[
            Opacity(
              child: Image.asset(ConstsApp.whitePokeball),
              opacity: 0.4,
              ),
            image,
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(1.0, 6.0),
              blurRadius: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
