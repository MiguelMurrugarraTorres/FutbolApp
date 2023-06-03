import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<dynamic>> fetchNews() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.5:3000/api/football-data'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      return jsonData.map((newsItem) {
        final title = newsItem['title'] as String?;
        final description = newsItem['description'] as String?;
        final imageUrl = newsItem['urlToImage'] as String?;

        return {
          'title': title ?? '',
          'description': description ?? '',
          'imageUrl': imageUrl ?? '',
        };
      }).toList();
    } else {
      throw Exception('Error al obtener los datos de las noticias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutbolApp',
      home: Scaffold(
        appBar: AppBar(
          title: Text('FutbolApp'),
        ),
        body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: fetchNews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error al cargar los datos de las noticias');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final newsItem = snapshot.data![index];
                    final imageUrl = newsItem['imageUrl'];
                    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

                    return Card(
                      child: ListTile(
                        leading: hasImage
                            ? Image.network(imageUrl!)
                            : SizedBox.shrink(),
                        title: Text(
                          newsItem['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(newsItem['description']),
                      ),
                    );
                  },
                );
              } else {
                return Text('No hay noticias disponibles');
              }
            },
          ),
        ),
      ),
    );
  }
}
