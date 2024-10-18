import 'dart:convert';

import 'package:api_flutter/model/local.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Telalistalocais extends StatefulWidget {
  const Telalistalocais({super.key});

  @override
  State<Telalistalocais> createState() => _TelalistalocaisState();
}

class _TelalistalocaisState extends State<Telalistalocais> {
  Future<List<Local>> pageData() async {
    final response = await http.Client()
        .get(Uri.parse('https://rickandmortyapi.com/api/location'));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dadosResult = dados['results'] as List;
      List<Local> todosLocais = [];

      dadosResult.forEach((locais) {
        todosLocais.add(Local(
          id: locais['id'],
          name: locais['name'],
          created: locais['created'],
          dimension: locais['dimension'],
          type: locais['type'],
          residents: locais['residents'],
          url: locais['url'],
        ));
      });
      return todosLocais;
    } else {
      debugPrint('Failed to load data');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Locais"),
      ),
      body: FutureBuilder(
        future: pageData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Local> listalocais = snapshot.data as List<Local>;
            return ListView.builder(
              itemCount: listalocais.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      listalocais[index].name.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(listalocais[index].type),
                    trailing: Text(listalocais[index].dimension),
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
