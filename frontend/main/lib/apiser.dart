import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:main/database.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS Simulator, or your machine IP for physical device
  static const String baseUrl = "http://192.168.1.23:8000/api";
  static const String storageBaseUrl = "http://192.168.1.23:8000/storage/";

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
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }

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
    required String governorate,
    required String city,
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
      "governorate": governorate,
      "city": city,
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
  static Future<List<dynamic>> getMyBookings() async {
    final response = await http.get(
      Uri.parse("$baseUrl/my-bookings"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Failed to load bookings");
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
    File? profileImage,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/update-profile"));
    request.headers.addAll(await getHeaders());
    request.headers.remove('Content-Type');

    if (firstName != null) request.fields['first_name'] = firstName;
    if (lastName != null) request.fields['last_name'] = lastName;
    if (phone != null) request.fields['phone'] = phone;
    if (password != null && password.isNotEmpty) request.fields['password'] = password;

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', profileImage.path));
    }

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Update failed");
    }
  }

  /// FAVORITES
  static Future<List<dynamic>> getFavorites() async {
    final response = await http.get(
      Uri.parse("$baseUrl/favorites"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Failed to load favorites");
    }
  }

  static Future<void> addFavorite(String apartmentId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/favorites/$apartmentId"),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
       final data = jsonDecode(response.body);
       throw Exception(data["message"] ?? "Failed to add favorite");
    }
  }

  static Future<void> removeFavorite(String apartmentId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/favorites/$apartmentId"),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
       final data = jsonDecode(response.body);
       throw Exception(data["message"] ?? "Failed to remove favorite");
    }
  }

  /// MESSAGES
  static Future<List<dynamic>> getConversations() async {
    final response = await http.get(
      Uri.parse("$baseUrl/conversations"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Failed to load conversations");
    }
  }

  static Future<List<dynamic>> getMessages(String conversationId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/messages/$conversationId"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Failed to load messages");
    }
  }

  static Future<void> sendMessage(String conversationId, String content) async {
    final response = await http.post(
      Uri.parse("$baseUrl/messages/send"),
      headers: await getHeaders(),
      body: jsonEncode({
        "conversation_id": conversationId,
        "content": content,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
       final data = jsonDecode(response.body);
       throw Exception(data["message"] ?? "Failed to send message");
    }
  }

  /// BOOKINGS
  static Future<Map<String, dynamic>> createBooking({
    required String apartmentId,
    required String startDate,
    required String endDate,
    required String location,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bookings"),
      headers: await getHeaders(),
      body: jsonEncode({
        "apartment_id": apartmentId,
        "start_date": startDate,
        "end_date": endDate,
        "location": location,
        "payment_method": paymentMethod,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["message"] ?? "Failed to create booking");
    }
  }

  /// OWNER METHODS
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard-stats"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load dashboard stats");
    }
  }

  static Future<List<dynamic>> getMyApartments() async {
    final response = await http.get(
      Uri.parse("$baseUrl/my-apartments"), 
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Failed to load my apartments");
    }
  }

  static Future<List<dynamic>> getOwnerBookings() async {
    final response = await http.get(
      Uri.parse("$baseUrl/owner-bookings"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['bookings'] ?? [];
    } else {
      throw Exception("Failed to load owner bookings");
    }
  }

  static Future<void> approveBooking(int bookingId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bookings/$bookingId/approve"),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
       final data = jsonDecode(response.body);
       throw Exception(data["message"] ?? "Failed to approve booking");
    }
  }

  static Future<void> rejectBooking(int bookingId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bookings/$bookingId/reject"),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
       final data = jsonDecode(response.body);
       throw Exception(data["message"] ?? "Failed to reject booking");
    }
  }
}
