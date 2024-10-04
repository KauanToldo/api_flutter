import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:api_flutter/model/personagem.dart';
import 'package:http/http.dart' as http;

class Telalistapersonagens extends StatelessWidget {
  const Telalistapersonagens({super.key});

  Future<List<Personagem>> pageData() async {
    final response = await http.Client()
        .get(Uri.parse('https://rickandmortyapi.com/api/character'));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dadosResult = dados['results'] as List;
      List<Personagem> todosPersonagens = [];

      dadosResult.forEach((personagem) {
        todosPersonagens.add(Personagem(
          id: personagem['id'],
          name: personagem['name'],
          status: personagem['status'],
          created: personagem['created'],
          episodes: [],
          gender: personagem['gender'],
          image: personagem['image'],
          species: personagem['species'],
          type: personagem['type'],
          url: personagem['url'],
        ));
      });
      return todosPersonagens;
    } else {
      debugPrint('Failed to load data');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Personagens"),
      ),
      body: FutureBuilder(
        future: pageData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return (Text('Não há dados para exibir'));
          } else {
            List<Personagem> listaPersonagens =
                snapshot.data as List<Personagem>;
            return ListView.builder(
              itemCount: listaPersonagens.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(listaPersonagens[index].name.toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
