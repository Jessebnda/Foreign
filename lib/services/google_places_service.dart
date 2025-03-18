import 'package:dio/dio.dart';

class GooglePlacesService {
  final Dio dio;
  final String apiKey;
  // Nuevo endpoint usando Text Search para la nueva Places API
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json';

  GooglePlacesService({required this.apiKey}) : dio = Dio() {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<List<dynamic>> fetchPlaces({
    required double latitude,
    required double longitude,
    required String query, // Se usa 'query' en vez de 'type'
    int radius = 2000,
  }) async {
    try {
      final response = await dio.get(
        baseUrl,
        queryParameters: {
          'query': query,
          'location': '$latitude,$longitude',
          'radius': radius,
          'key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        return response.data['results'] as List;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching places for query "$query": $e');
      rethrow;
    }
  }
}
