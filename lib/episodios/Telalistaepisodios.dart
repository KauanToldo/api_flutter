import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:api_flutter/model/episodio.dart';
import 'package:http/http.dart' as http;

class Telalistaepisodios extends StatefulWidget {
  const Telalistaepisodios({super.key});

  @override
  State<Telalistaepisodios> createState() => _TelalistaepisodiosState();
}

class _TelalistaepisodiosState extends State<Telalistaepisodios> {
  Future<List<Episode>> pageData() async {
    final response = await http.Client()
        .get(Uri.parse('https://rickandmortyapi.com/api/episode'));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dadosResult = dados['results'] as List;
      List<Episode> todosepisodios = [];

      dadosResult.forEach((episodios) {
        todosepisodios.add(Episode(
          id: episodios['id'],
          name: episodios['name'],
          created: episodios['created'],
          airDate: episodios['air_date'],
          characters: episodios['characters'],
          episode: episodios['episode'],
          url: episodios['url'],
        ));
      });
      return todosepisodios;
    } else {
      debugPrint('Failed to load data');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de episodios"),
      ),
      body: FutureBuilder(
        future: pageData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Episode> listaepisodios = snapshot.data as List<Episode>;
            return ListView.builder(
              itemCount: listaepisodios.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      listaepisodios[index].name.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(listaepisodios[index].episode.toString()),
                    trailing: Text(listaepisodios[index].airDate),
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
