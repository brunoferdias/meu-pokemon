import 'package:flutter/material.dart';
import 'package:pokemon_dias/model/pokemon_model.dart';

class InfoPagePokemon extends StatelessWidget {
  final Pokemon pokemon;

  InfoPagePokemon({required this.pokemon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black87,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: pokemon.image,
              key: ValueKey(pokemon.image),
              child: Image.asset(
                pokemon.image,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),

            // Nome do Pokemon
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                pokemon.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Categoria
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Categoria: ${pokemon.category}",
                style: TextStyle(fontSize: 18),
              ),
            ),

            // Peso e Altura
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Peso: ${pokemon.weight} | Altura: ${pokemon.height}",
                style: TextStyle(fontSize: 18),
              ),
            ),

            // Habilidades
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Habilidades: ${pokemon.abilities}",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
