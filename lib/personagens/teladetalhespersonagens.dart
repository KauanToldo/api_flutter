import 'dart:convert';
import 'package:api_flutter/model/episodio.dart';
import 'package:api_flutter/model/personagem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TelaDetalhesPersonagem extends StatefulWidget {
  Personagem personagemData;

  TelaDetalhesPersonagem({super.key, required this.personagemData});

  @override
  State<TelaDetalhesPersonagem> createState() => _TelaDetalhesPersonagemState();
}

class _TelaDetalhesPersonagemState extends State<TelaDetalhesPersonagem> {
  Future<List<Episode>> episodesData() async {
    final response = await http.Client()
        .get(Uri.parse('https://rickandmortyapi.com/api/episode'));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dadosResult = dados['results'] as List;
      List<Episode> todosEpisodios = [];

      dadosResult.forEach((episodios) {
        todosEpisodios.add(Episode(
          id: episodios['id'],
          name: episodios['name'],
          created: episodios['created'],
          airDate: episodios['air_date'],
          characters: episodios['characters'],
          episode: episodios['episode'],
          url: episodios['url'],
        ));
      });
      return todosEpisodios;
    } else {
      debugPrint('Failed to load data');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalhes do Personagem'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(widget.personagemData.image),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(widget.personagemData.name,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Status: ${widget.personagemData.status}",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Gender: ${widget.personagemData.gender}",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Species: ${widget.personagemData.species}",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Episódios:',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 300,
                        child: FutureBuilder(
                          future: episodesData(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              List<Episode> listaEpisodios =
                                  snapshot.data as List<Episode>;
                              List<Episode> episodiosPersonagem = [];
                              for (Episode i in listaEpisodios) {
                                for (String j
                                    in widget.personagemData.episodes) {
                                  if (i.url == j) {
                                    episodiosPersonagem.add(i);
                                  }
                                }
                              }
                              return ListView.builder(
                                itemCount: episodiosPersonagem.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: ListTile(
                                    title:
                                        Text(episodiosPersonagem[index].name),
                                  ));
                                },
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
