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

  Widget _infoTile(IconData icon, String title, dynamic value) {
    String valueString = value?.toString() ?? 'Não informado';

    if (value is List) {
      valueString = value.isNotEmpty ? value.join(', ') : 'Não informado';
    }

    if (value is bool) {
      valueString = value ? 'Sim' : 'Não';
    }

    if (valueString.trim().isEmpty || valueString == 'null') {
      valueString = 'Não informado';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.greenAccent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valueString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent(Map<String, dynamic> data) {
    final plantDetails = data['data'] as Map<String, dynamic>? ?? {};

    if (plantDetails.isEmpty) {
      return const Center(
        child: Text(
          'Detalhes não disponíveis.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final commonName = plantDetails['common_name'] ?? 'Nome Comum Desconhecido';
    final scientificName = plantDetails['scientific_name'] ?? 'Nome Científico Desconhecido';
    final family = plantDetails['family']?['common_name'] ?? plantDetails['family_name'] ?? 'Não informado';
    final duration = plantDetails['duration'] ?? 'Não informado';
    final edibleRaw = plantDetails['edible'];
    final edibleStatus = (edibleRaw is bool && edibleRaw == true) ? 'Sim' : 'Não';
    final year = plantDetails['year']?.toString() ?? 'Não informado';
    final genusName = plantDetails['genus']?['name'] ?? 'Não informado';
    final imageUrl = plantDetails['image_url'];

    return CustomScrollView(
      slivers: [
        // Header com imagem
        SliverToBoxAdapter(
          child: Stack(
            children: [
              // Imagem de fundo
              if (imageUrl != null)
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                )
              else
                Container(
                  height: 350,
                  color: const Color(0xFF1E1E1E),
                  child: const Center(
                    child: Icon(Icons.grass, color: Colors.green, size: 80),
                  ),
                ),
              
              // Nomes da planta
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commonName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            scientificName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Conteúdo
        SliverToBoxAdapter(
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Informações',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),

                  _infoTile(Icons.park_outlined, 'Família', family),
                  _infoTile(Icons.category_outlined, 'Gênero', genusName),
                  _infoTile(Icons.timer_outlined, 'Duração', duration),
                  _infoTile(
                    edibleRaw == true ? Icons.restaurant_menu : Icons.close,
                    'Comestível',
                    edibleStatus,
                  ),
                  _infoTile(Icons.calendar_today_outlined, 'Ano de Descoberta', year),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

  
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            // child: IconButton(
            //   icon: const Icon(Icons.favorite_border, color: Colors.white),
            //   onPressed: () {
            //     // Ação de favoritar
            //   },
            // ),
          ),
        ],
      ),

      backgroundColor: Colors.black,

      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 20),
                  Text(
                    'Carregando detalhes...',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 64),
                    const SizedBox(height: 20),
                    Text(
                      'Erro ao carregar detalhes',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
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