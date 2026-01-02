import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:main/database.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS Simulator, or your machine IP for physical device
  static const String baseUrl = "http://10.0.2.2:8000/api";
  static const String storageBaseUrl = "http://10.0.2.2:8000/storage/";

  static Future<Map<String, String>> getHeaders() async {
    final db = Database();
    final token = await db.getToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// REGISTER
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String birthDate,
    required File profileImage,
    required File idImage,
    String role = 'tenant',
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/register"));
    
    request.fields.addAll({
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "password": password,
      "password_confirmation": password,
      "birth_date": birthDate,
      "role": role,
    });

    request.files.add(await http.MultipartFile.fromPath('profile_image', profileImage.path));
    request.files.add(await http.MultipartFile.fromPath('id_image', idImage.path));
    
    request.headers.addAll({
      "Accept": "application/json",
    });

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Register failed");
    }
  }

  /// LOGIN
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "phone": phone,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Save Token
      if (data['token'] != null) {
        final db = Database();
        await db.saveToken(data['token']);
        // Also save user info if needed
      }
      return data;
    } else {
      throw Exception(data["message"] ?? "Login failed");
    }
  }

  /// GET APARTMENTS
  static Future<List<dynamic>> getApartments() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/apartments"),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['data'] ?? []; // Assuming response structure { success: true, data: [...] }
    } else {
      throw Exception("Failed to load apartments");
    }
  }

  /// CREATE APARTMENT
  static Future<Map<String, dynamic>> createApartment({
    required String title,
    required String description,
    required String location,
    required double price,
    required double area,
    required int rooms,
    required List<File> images,
  }) async {
    final headers = await getHeaders();
    // Use MultipartRequest for images
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/apartments"));
    request.headers.addAll(headers);
    // remove content-type from headers for multipart, it adds it automatically with boundary
    request.headers.remove('Content-Type'); 

    request.fields.addAll({
      "title": title,
      "description": description,
      "location": location,
      "price": price.toString(),
      "area": area.toString(),
      "rooms": rooms.toString(),
    });

    for (var image in images) {
       request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
    }

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Failed to create apartment");
    }
  }
}
