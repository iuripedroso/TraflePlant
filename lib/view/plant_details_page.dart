import 'package:flutter/material.dart';
import 'package:apkinvertexto/service/trefle_service.dart'; 

class PlantDetailsPage extends StatefulWidget {
  final int plantId;
  const PlantDetailsPage({super.key, required this.plantId});

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  final _apiService = TrefleService();
  Future<Map<String, dynamic>>? _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _apiService.fetchPlantDetails(widget.plantId);
  }

  // Widget para exibir os valores/titulos dos detalhes
  Widget _infoTile(String title, dynamic value) {
    String valueString = value?.toString() ?? 'Não informado';

    // Se o valor for uma lista, junta os itens em uma string.
    if (value is List) {
      valueString = value.join(', ');
    }

    if (valueString.isEmpty || valueString == 'null') {
      return const SizedBox.shrink(); // Oculta se o valor for vazio/nulo
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
            ),
            TextSpan(text: valueString),
          ],
        ),
      ),
    );
  }
  
  // Widget principal para construir a tela de detalhes após o fetch
  Widget _buildDetailsContent(Map<String, dynamic> data) {
    final plantDetails = data['data'] as Map<String, dynamic>? ?? {};

    if (plantDetails.isEmpty) {
      return const Center(child: Text('Detalhes não disponíveis.', style: TextStyle(color: Colors.white)));
    }

    // operadores n nulo
    final commonName = plantDetails['common_name'] ?? 'Nome Comum Desconhecido';
    final scientificName = plantDetails['scientific_name'] ?? 'Nome Científico Desconhecido';
    final family = plantDetails['family']?['common_name'] ?? plantDetails['family_name'] ?? 'Não informado';
    final duration = plantDetails['duration'] ?? 'Não informado';
    
    final edibleRaw = plantDetails['edible'];
    final edibleStatus = (edibleRaw is bool && edibleRaw == true) ? 'Sim' : 'Não';
    
    final year = plantDetails['year']?.toString() ?? 'Não informado';
    final imageUrl = plantDetails['image_url'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Imagem
          if (imageUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
          if (imageUrl != null) const SizedBox(height: 20),

          // Nomes
          Center(
            child: Text(
              commonName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              scientificName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Divider(height: 40, color: Colors.greenAccent),

          // Informações Detalhadas
          _infoTile('Família', family),
          _infoTile('Duração', duration),
          _infoTile('Comestível', edibleStatus), // Usa o status corrigido
          _infoTile('Ano de Descoberta', year),
          _infoTile('Gênero', plantDetails['genus']?['name']),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Planta', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : 'Erro: ${snapshot.error.toString()}';

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Erro ao carregar detalhes: $errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return _buildDetailsContent(snapshot.data!);
          } else {
            return const Center(
              child: Text(
                'Detalhes da planta não encontrados.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}