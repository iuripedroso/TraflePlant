import 'package:flutter/material.dart';
import 'package:apkinvertexto/service/trefle_service.dart';
import 'package:apkinvertexto/view/plant_details_page.dart';


class SearchPlantsPage extends StatefulWidget {
  const SearchPlantsPage({super.key});

  @override
  State<SearchPlantsPage> createState() => _SearchPlantsPageState();
}

class _SearchPlantsPageState extends State<SearchPlantsPage> {
  final _searchController = TextEditingController();
  final _apiService = TrefleService();
  
  Future<Map<String, dynamic>>? _plantsFuture;

  @override //limpar a memoria//
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _searchPlants() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _showErrorSnackBar('O campo de busca não pode estar vazio.');
      return;
    }
    
    // esconde o teclado 
    FocusScope.of(context).unfocus(); 

    setState(() {
      _plantsFuture = _apiService.searchPlants(query);
    });
  }

  // 2. Widget de Construção dos Resultados (ListView.builder)
  Widget _buildResultadoWidget(Map<String, dynamic> data) {
    final List<dynamic> plants = data['data'] ?? [];

    if (plants.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma planta encontrada para esta busca.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index] as Map<String, dynamic>;
        
        // Extrai os campos, usando '??' para garantir um valor padrão se for nulo
        final commonName = plant['common_name'] ?? 'Sem Nome Comum';
        final scientificName = plant['scientific_name'] ?? 'Nome Científico Desconhecido';
        
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ListTile(
            // Tenta carregar a imagem, senão exibe um ícone de grama
            leading: plant['image_url'] != null
                ? Image.network(
                    plant['image_url'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    // Garante que o widget não quebre se a URL da imagem falhar
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.grass, color: Colors.greenAccent, size: 30),
                  )
                : const Icon(Icons.grass, color: Colors.greenAccent, size: 30),
            
            title: Text(
              commonName,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Científico: $scientificName',
              style: const TextStyle(color: Colors.white70),
            ),
            // Ação ao tocar no item (exemplo)
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantDetailsPage(
                    plantId: plant['id'],  // <-- ID CORRETO
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 3. Método build (Estrutura da Tela)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca de Plantas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Campo de entrada de texto
            TextField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nome da Planta (ex: Rose, Oak)',
                labelStyle: TextStyle(color: Colors.greenAccent.shade100),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Botão de busca
            ElevatedButton.icon(
              onPressed: _searchPlants,
              icon: const Icon(Icons.search),
              label: const Text('Buscar Planta'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            
            // 4. FutureBuilder para gerenciar estados
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _plantsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: Text(
                        'Digite o nome de uma planta para começar a busca.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.greenAccent),
                    );
                  } else if (snapshot.hasError) {
                    // Trata as exceções personalizadas (ApiException)
                    final errorMessage = snapshot.error is ApiException
                        ? (snapshot.error as ApiException).message
                        : 'Erro: ${snapshot.error.toString()}';

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 60),
                          const SizedBox(height: 16),
                          Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Se não houver erro, exibe os resultados
                    return _buildResultadoWidget(snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}