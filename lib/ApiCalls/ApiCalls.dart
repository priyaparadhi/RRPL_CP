import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rrpl_app/models/ProjectModel.dart';
import 'package:rrpl_app/models/StoryModel.dart';

class ApiCalls {
  static const String baseUrl = 'https://rrpl-dev.portalwiz.in/api/public/api/';

  static Future<List<Map<String, dynamic>>> fetchProjectConfiguration(
      int projectId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_project_configuration'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'project_id': projectId}),
    );

    if (response.statusCode == 200) {
      // Parse the response and return the list of configurations
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load project configurations');
    }
  }

  static Future<List<Project>> fetchProjects() async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_projects'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Project.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  static Future<List<dynamic>> fetchProject() async {
    // Replace with your API URL
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_projects'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Decode the JSON response
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<List<dynamic>> fetchBrokerageSlab(int projectId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_brokerage_slab'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"project_id": projectId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch brokerage slab');
    }
  }

  Future<List<dynamic>> fetchProjectImages(int projectId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_project_images'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'project_id': projectId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return list of images
    } else {
      throw Exception('Failed to load project images');
    }
  }

  Future<List<dynamic>> fetchProjectAttachments(int projectId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_project_attachments'),
      headers: {
        'content-Type': 'application/json',
      },
      body: jsonEncode({
        'project_id': projectId,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load project images');
    }
  }

  Future<List<dynamic>> fetchProjectLinks(int projectId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_project_links'),
      headers: {
        'content-Type': 'application/json',
      },
      body: jsonEncode({
        'project_id': projectId,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load project images');
    }
  }

  static Future<Map<String, dynamic>> fetchSingleProject(int projectId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_single_project'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'project_id': projectId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load project details');
    }
  }

  static Future<bool> addStatusUpdate({
    required String userId,
    required String title,
    required String description,
    required String? link,
    required File thumbnailImage,
    required File fullImage,
  }) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}add_status_updates'))
          ..fields['user_id'] = userId
          ..fields['title'] = title
          ..fields['description'] = description
          ..fields['link'] = link ?? '';

    request.files.add(await http.MultipartFile.fromPath(
        'status_thumbnail_img', thumbnailImage.path));
    request.files.add(
        await http.MultipartFile.fromPath('status_full_img', fullImage.path));

    try {
      final response = await request.send();
      return response.statusCode == 200;
    } catch (error) {
      print('Error occurred while adding story: $error');
      return false;
    }
  }

  static Future<List<StatusUpdate>> fetchStatusUpdates() async {
    final response =
        await http.get(Uri.parse('${baseUrl}fetch_status_updates'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => StatusUpdate.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load status updates');
    }
  }

  static Future<Map<String, dynamic>?> fetchSingleStatus(
      int statusUpdateId) async {
    final url = Uri.parse('${baseUrl}fetch_single_status');

    final response = await http.post(
      url,
      body: json.encode({
        "status_update_id": statusUpdateId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        return responseData[0];
      }
    } else {
      print('Failed to load status update: ${response.statusCode}');
    }
    return null;
  }
}
