import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2/api-test/public',
);

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiAccount {
  const ApiAccount({required this.id, required this.email});

  final int id;
  final String email;

  factory ApiAccount.fromJson(Map<String, dynamic> json) => ApiAccount(
    id: int.parse(json['id'].toString()),
    email: json['email'] as String,
  );
}

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  String get fullName => '$prenom $nom $postnom'.trim();

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: int.parse(json['id'].toString()),
    nom: json['nom'] as String,
    postnom: json['postnom'] as String,
    prenom: json['prenom'] as String,
    lieuNaissance: json['lieu_naissance'] as String,
    dateNaissance: json['date_naissance'] as String,
    parente: json['parente'] as String,
    imageUrl: json['image_url'] as String?,
  );

  Map<String, String> toJson() => {
    'nom': nom,
    'postnom': postnom,
    'prenom': prenom,
    'lieu_naissance': lieuNaissance,
    'date_naissance': dateNaissance,
    'parente': parente,
  };
}

abstract interface class CvApi {
  Future<ApiAccount> login(String email, String password);
  Future<ApiAccount> register(String email, String password);
  Future<List<FamilyMember>> listFamilyMembers();
  Future<FamilyMember> createFamilyMember(Map<String, String> member);
  Future<FamilyMember> updateFamilyMember(int id, Map<String, String> member);
  Future<void> deleteFamilyMember(int id);
}

class HttpCvApi implements CvApi {
  HttpCvApi({Uri? baseUri, http.Client? client})
    : _baseUri = baseUri ?? Uri.parse(apiBaseUrl),
      _client = client ?? http.Client();

  final Uri _baseUri;
  final http.Client _client;

  Uri _endpoint(String path) {
    final base = _baseUri.toString().replaceFirst(RegExp(r'/$'), '');
    return Uri.parse('$base/$path');
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, String>? body,
  }) async {
    late final http.Response response;
    try {
      final uri = _endpoint(path);
      final headers = {'Accept': 'application/json'};
      if (body != null) headers['Content-Type'] = 'application/json';
      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 20));
        case 'POST':
          response = await _client
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 20));
        case 'PUT':
          response = await _client
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 20));
        case 'DELETE':
          response = await _client
              .delete(uri, headers: headers)
              .timeout(const Duration(seconds: 20));
        default:
          throw ApiException('Méthode HTTP non prise en charge.');
      }
    } on http.ClientException {
      throw const ApiException(
        'Impossible de joindre le serveur. Vérifiez le réseau et l’URL de l’API.',
      );
    } on TimeoutException {
      throw const ApiException(
        'Le serveur met trop de temps à répondre. Réessayez.',
      );
    }

    Map<String, dynamic> decoded;
    try {
      final value = jsonDecode(response.body);
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Réponse JSON inattendue.');
      }
      decoded = value;
    } on FormatException {
      throw ApiException(
        'Réponse invalide du serveur (HTTP ${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] != true) {
      throw ApiException(
        decoded['message'] as String? ??
            'Erreur du serveur (HTTP ${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }
    return decoded;
  }

  Map<String, dynamic> _data(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Données inattendues reçues du serveur.');
    }
    return data;
  }

  @override
  Future<ApiAccount> login(String email, String password) async {
    final response = await _request(
      'POST',
      'accounts/login',
      body: {'email': email, 'password': password},
    );
    return ApiAccount.fromJson(_data(response));
  }

  @override
  Future<ApiAccount> register(String email, String password) async {
    final response = await _request(
      'POST',
      'accounts/register',
      body: {'email': email, 'password': password},
    );
    return ApiAccount.fromJson(_data(response));
  }

  @override
  Future<List<FamilyMember>> listFamilyMembers() async {
    final response = await _request('GET', 'famille-membres');
    final data = response['data'];
    if (data is! List) {
      throw const ApiException('Liste des membres invalide reçue du serveur.');
    }
    return data
        .map((item) => FamilyMember.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<FamilyMember> createFamilyMember(Map<String, String> member) async {
    final response = await _request('POST', 'famille-membres', body: member);
    return FamilyMember.fromJson(_data(response));
  }

  @override
  Future<FamilyMember> updateFamilyMember(
    int id,
    Map<String, String> member,
  ) async {
    final response = await _request('PUT', 'famille-membres/$id', body: member);
    return FamilyMember.fromJson(_data(response));
  }

  @override
  Future<void> deleteFamilyMember(int id) async {
    await _request('DELETE', 'famille-membres/$id');
  }
}
