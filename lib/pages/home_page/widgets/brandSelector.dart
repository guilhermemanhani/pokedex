import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/store/pokeapi_store.dart';

class BrandSelector extends StatefulWidget {
  final List<String> brands;
  BrandSelector({@required this.brands});
  @override
  _BrandSelectorState createState() => _BrandSelectorState();
}

class _BrandSelectorState extends State<BrandSelector>{
  int _indexOption = 0;
  bool _isSelected;
  PokeApiStore _pokeApiStore;
  

  @override
  void initState(){
    super.initState();
    _pokeApiStore = GetIt.instance<PokeApiStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _buildOption(),
    );
  }

  List<Widget> _buildOption(){
    return widget.brands.map((brand){
      var indexLocal = widget.brands.indexOf(brand);
      _isSelected = _indexOption == indexLocal;
      return Padding(
        padding: EdgeInsets.only(top: 80),
        child: GestureDetector(
          onTap: (){
            setState(() {
              _indexOption = indexLocal;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),         
              color: _isSelected ? Colors.black26 : Colors.transparent,
            ),
            padding: EdgeInsets.all(10),          
            child: Text(
              brand,
              style: TextStyle(
                color: _isSelected ? Colors.black : Colors.grey,
                fontSize: _isSelected ? 22 : 16,
                fontWeight: FontWeight.w700
              )
            ),            
          ),
        )
      );
    }).toList();
  }
}