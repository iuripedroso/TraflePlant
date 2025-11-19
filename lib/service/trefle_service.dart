


// melhorar app bar e pagina de detalhes


import 'dart:convert';
import 'dart:io';
import 'dart:async'; 
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class TrefleService {
  final String _token = "usr-e11bXNjn_cy_2zzDyz5e2mCxfVp1RZt6BTZNL8T5LTA"; 
  final String _baseUrl = "https://trefle.io/api/v1";
  
  // 1 (search/plants)
  Future<Map<String, dynamic>> searchPlants(String query, {int page = 1}) async {
    try {
      final uri = Uri.parse(
        "$_baseUrl/plants/search?token=$_token&q=$query&page=$page",
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      print('URL da Requisição (Busca): $uri');
      print('Status Code (Busca): ${response.statusCode}');
      print('Corpo da Resposta (Busca): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}'); 
  
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw ApiException('Resposta vazia da API, mesmo com status 200.');
        }
        return json.decode(response.body); 
        
      } else if (response.statusCode == 401) {
        throw ApiException('Erro de autenticação. Token inválido.');
      } else {
        throw ApiException(
          'Erro no servidor Trefle (código ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet.');
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder.');
    } 
    catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Ocorreu um erro inesperado: ${e.toString()}'); 
    }
  }

  // Método 2: Busca detalhes da planta por ID
  Future<Map<String, dynamic>> fetchPlantDetails(int plantId) async {
    try {
      final uri = Uri.parse(
        "$_baseUrl/plants/$plantId?token=$_token", // Endpoint de detalhes
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      print('URL Detalhes: $uri');
      print('Status Code Detalhes: ${response.statusCode}');
      print('Corpo da Resposta Detalhes: ${response.body.substring(0, response.body.length > 1000 ? 1000 : response.body.length)}'); 

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw ApiException('Resposta vazia da API para detalhes.');
        }
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw ApiException('Erro de autenticação. Token inválido.');
      } else if (response.statusCode == 404) {
        throw ApiException('Planta não encontrada.');
      } else {
        throw ApiException(
          'Erro ao buscar detalhes no servidor Trefle (código ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet.');
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder.');
    } 
  }

  // Método 3: Busca a lista de famílias (para a funcionalidade de browse)
  Future<Map<String, dynamic>> fetchFamilies({int page = 1}) async {
    try {
      final uri = Uri.parse(
        "$_baseUrl/families?token=$_token&page=$page&order=name", 
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      print('URL Famílias: $uri');
      print('Status Code Famílias: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw ApiException('Resposta vazia da API para famílias.');
        }
        return json.decode(response.body); 
      } else if (response.statusCode == 401) {
        throw ApiException('Erro de autenticação. Token inválido.');
      } else {
        throw ApiException(
          'Erro ao buscar famílias no servidor Trefle (código ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet.');
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder.');
    } 
    catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Ocorreu um erro inesperado: ${e.toString()}'); 
    }
  }

  // MÉTODO PARA FILTRAGEM POR FAMÍLIA:
  Future<Map<String, dynamic>> fetchPlantsByFamily(String familyName, {int page = 1}) async {
    try {
      // ⚠️ Note o uso do filtro: filter[family_name]=
      final uri = Uri.parse(
        "$_baseUrl/plants?token=$_token&filter[family_name]=$familyName&page=$page",
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      print('URL Filtro Família: $uri');
      print('Status Code Filtro Família: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw ApiException('Resposta vazia da API para busca por família.');
        }
        return json.decode(response.body); 
      } else if (response.statusCode == 401) {
        throw ApiException('Erro de autenticação. Token inválido.');
      } else {
        throw ApiException(
          'Erro no servidor Trefle ao filtrar por família (código ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet.');
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder.');
    } 
    catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Ocorreu um erro inesperado: ${e.toString()}'); 
    }
  }
}