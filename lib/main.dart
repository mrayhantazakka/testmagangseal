import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      home: StarWarsCharactersScreen(),
    );
  }
}

class StarWarsCharactersScreen extends StatefulWidget {
  @override
  _StarWarsCharactersScreenState createState() =>
      _StarWarsCharactersScreenState();
}

class _StarWarsCharactersScreenState extends State<StarWarsCharactersScreen> {
  List<dynamic> characters = [];

  // Fungsi untuk mengambil data dari API
  Future<void> fetchCharacters() async {
    final response = await http.get(
      Uri.parse('https://swapi.py4e.com/api/people/'),
    );

    if (response.statusCode == 200) {
      // Parsing JSON response
      final data = json.decode(response.body);
      setState(() {
        characters = data['results'];
      });
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCharacters(); // Panggil fungsi untuk mengambil data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'STAR WARS Characters',
          style: TextStyle(
            fontFamily: 'StarWarsFont', // Menggunakan font Orbitron
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Judul di tengah
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Hilangkan bayangan AppBar
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25, // Ukuran lingkaran
            backgroundImage: AssetImage('assets/img/sw_lg.png'),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gambar latar belakang dengan BoxFit.cover agar responsif
          Positioned.fill(
            child: Image.asset(
              'assets/img/star.png',
              fit: BoxFit.cover, // Gambar menyesuaikan dengan layar
            ),
          ),
          // Konten utama (data karakter)
          characters.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                        0.8,
                      ), // Latar belakang kotak semi-transparan
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ], // Efek bayangan pada kotak
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      title: Text(
                        'Name: ${character['name']}',
                        style: TextStyle(
                          fontFamily: 'StarWarsFont', // Font Orbitron
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Height: ${character['height']} cm',
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
