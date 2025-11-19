import 'package:flutter/material.dart';
import 'package:apkinvertexto/service/trefle_service.dart';
import 'package:apkinvertexto/view/family_plants_page.dart';


class BrowseFamiliesPage extends StatefulWidget {
  const BrowseFamiliesPage({super.key});

  @override
  State<BrowseFamiliesPage> createState() => _BrowseFamiliesPageState();
}

class _BrowseFamiliesPageState extends State<BrowseFamiliesPage> {
  final _apiService = TrefleService(); 
  Future<Map<String, dynamic>>? _familiesFuture;
  int _currentPage = 1;
  bool _canLoadMore = true;
  List<dynamic> _allFamilies = [];

  @override
  void initState() {
    super.initState();
    _loadFamilies();
  }

  void _loadFamilies() {
    if (!_canLoadMore) return;

    setState(() {
      _familiesFuture = _apiService.fetchFamilies(page: _currentPage);
    });

    _familiesFuture! 
        .then((data) {
          final List<dynamic> newFamilies = data['data'] ?? [];
          final dynamic links = data['links'] ?? {};

          setState(() {
            _allFamilies.addAll(newFamilies);
            _canLoadMore =
                links['next'] != null; // Verifica se há uma próxima página
            _currentPage++;
          });
        })
        .catchError((e) {
          if (_currentPage > 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erro ao carregar mais famílias: ${e.toString()}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explorar Famílias',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _familiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _allFamilies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          } else if (snapshot.hasError && _allFamilies.isEmpty) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else {
            // Se houver dados (ou se já tivermos dados em _allFamilies)
            return ListView.builder(
              itemCount: _allFamilies.length + (_canLoadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _allFamilies.length) {
                  // Último item: indicador de carregamento (ou "sem mais")
                  if (_canLoadMore) {
                    // evita o erro "setState() or markNeedsBuild() called during build..."
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _loadFamilies();
                    });

                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }

                final family = _allFamilies[index] as Map<String, dynamic>;
                final familyName = family['name'] ?? 'Nome Desconhecido';
                final commonName = family['common_name'] ?? 'Sem Nome Comum';

                return Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: ListTile(
                    title: Text(
                      familyName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      commonName,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FamilyPlantsPage(familyName: familyName),
                        ),
                      );
                    },
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
