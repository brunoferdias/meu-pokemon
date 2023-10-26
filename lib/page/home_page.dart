import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_dias/page/infopage_pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/pokemon_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredPokemonList = [];

  List<dynamic> pokemonList = [];
  bool mostrarApenasFavoritos = false;

  Future<void> lerJson() async {
    final String response = await rootBundle.loadString('assets/pokemon.json');
    final data = await json.decode(response);

    setState(() {
      pokemonList =
          data['pokemons'].map((data) => Pokemon.fromJson(data)).toList();
    });


    final prefs = await SharedPreferences.getInstance();
    for (var pokemon in pokemonList) {
      final isFavorite = prefs.getBool(pokemon.id);
      if (isFavorite != null) {
        setState(() {
          pokemon.isMyFav = isFavorite;
        });
      }
    }
  }

  void filterPokemonList(String query) {
    setState(() {
      filteredPokemonList = pokemonList.where((pokemon) {
        return pokemon.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _saveFavoriteState(Pokemon pokemon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(pokemon.id, pokemon.isMyFav);
  }

  @override
  void initState() {
    super.initState();
    lerJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 20,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                iconSize: 30,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final List favoritePokemonList = pokemonList.where((pokemon) => pokemon.isMyFav).toList();
                      return AlertDialog(
                        title: Text('Favoritos'),
                        content: favoritePokemonList.isEmpty
                            ? Text('Não há Pokémon favorito.')
                            : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: double.maxFinite,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: favoritePokemonList.length,
                              itemBuilder: (context, index) {
                                final Pokemon favoritePokemon = favoritePokemonList[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 5,
                                  color: Colors.grey.shade100,
                                  child: Column(
                                    children: [
                                      Image.asset(favoritePokemon.image),
                                      Text('Nome: ${favoritePokemon.name}'),
                                      Text('Categoria: ${favoritePokemon.category}'),
                                      Text('Peso: ${favoritePokemon.weight}'),
                                      Text('Altura: ${favoritePokemon.height}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );

                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.grey.shade400,
                )),
          )
        ],
        title: Container(
          height: 45,
          child: TextField(
            controller: searchController,
            cursorColor: Colors.grey,
            onChanged: (text) {
              filterPokemonList(text);
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              filled: true,
              fillColor: Colors.grey.shade200,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none),
              hintText: "Pesquisar Pokemon",
              hintStyle: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
      body: Container(
          child: searchController.text.isEmpty
              ? ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20),
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                return pokemonComponent(pokemon: pokemonList[index]);
              })
              : ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20),
              itemCount: filteredPokemonList.length,
              itemBuilder: (context, index) {
                return pokemonComponent(
                    pokemon: filteredPokemonList[index]);
              })),
    );
  }

  pokemonComponent({required Pokemon pokemon}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            reverseTransitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) {
              return InfoPagePokemon(pokemon: pokemon);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    Container(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Hero(
                            tag: pokemon.image,
                            key: ValueKey(pokemon.image),
                            child: Image.asset(pokemon.image),
                          ),
                        )),
                    SizedBox(width: 10),
                    Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pokemon.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(pokemon.category,
                                style: TextStyle(color: Colors.grey[500])),
                          ]),
                    )
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      pokemon.isMyFav = !pokemon.isMyFav;
                      _saveFavoriteState(pokemon);
                    });
                  },
                  child: AnimatedContainer(
                      height: 35,
                      padding: EdgeInsets.all(5),
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          )),
                      child: Center(
                          child: pokemon.isMyFav
                              ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                              : Icon(Icons.favorite_outline,
                              color: Colors.grey.shade600))),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200),
                        child: Text(
                          pokemon.category,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),

                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}