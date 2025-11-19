// view/home_page.dart
import 'package:flutter/material.dart';
import 'package:apkinvertexto/view/search_plants_page.dart';
import 'package:apkinvertexto/view/browse_families_page.dart'; // NOVO IMPORT

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String _backgroundImageUrl = 
      "https://i.pinimg.com/736x/bb/db/ab/bbdbab5b203c3cedf48259f212867508.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Torna o AppBar transparente
        elevation: 0, 
        title: const Text(
          'Trefle Plant Finder',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      
      //3. Usa Stack para colocar o fundo atrás do conteúdo
      body: Stack(
        children: <Widget>[
          
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_backgroundImageUrl), // Carrega a imagem da internet
                fit: BoxFit.cover, // Garante que a imagem cubra toda a área
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), // Adiciona um filtro de escuridão (overlay)
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Conteúdo (que estava antes no Body) --------------------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Escolha uma opção:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Item de menu para Busca de Plantas (EXISTENTE)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPlantsPage(),
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.black.withOpacity(0.7), 
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.nature_people, color: Colors.greenAccent, size: 40),
                          SizedBox(width: 15),
                          Text(
                            'Buscar Plantas',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: Colors.greenAccent, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),

                // Item de menu para Explorar Famílias
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BrowseFamiliesPage(),
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.black.withOpacity(0.7), 
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.category, color: Colors.orangeAccent, size: 40),
                          SizedBox(width: 15),
                          Text(
                            'Explorar por Família',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}