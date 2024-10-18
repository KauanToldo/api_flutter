import 'dart:convert';

import 'package:api_flutter/personagens/teladetalhespersonagens.dart';
import 'package:flutter/material.dart';
import 'package:api_flutter/model/personagem.dart';
import 'package:http/http.dart' as http;

class Telalistapersonagens extends StatefulWidget {
  const Telalistapersonagens({super.key});

  @override
  State<Telalistapersonagens> createState() => _TelalistapersonagensState();
}

class _TelalistapersonagensState extends State<Telalistapersonagens> {
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
          episodes: personagem['episode'].cast<String>(),
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
            return Center(child: CircularProgressIndicator());
          } else {
            List<Personagem> listaPersonagens =
                snapshot.data as List<Personagem>;
            return ListView.builder(
              itemCount: listaPersonagens.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaDetalhesPersonagem(
                                personagemData: listaPersonagens[index],
                              ))),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(listaPersonagens[index].image)),
                      title: Text(
                        listaPersonagens[index].name.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text('Espécie: ${listaPersonagens[index].species}'),
                      trailing: listaPersonagens[index].status == 'Alive'
                          ? Icon(
                              Icons.circle,
                              color: Color.fromARGB(255, 17, 255, 0),
                            )
                          : listaPersonagens[index].status == "Dead"
                              ? Icon(
                                  Icons.circle,
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                )
                              : Icon(Icons.question_mark),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
