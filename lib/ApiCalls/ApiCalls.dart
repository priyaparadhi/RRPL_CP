import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rrpl_app/Views/EnquiryPage.dart';
import 'package:rrpl_app/models/BookingModel.dart';
import 'package:rrpl_app/models/EnquiryModel.dart';
import 'package:rrpl_app/models/ProjectModel.dart';
import 'package:rrpl_app/models/StoryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<List<dynamic>> fetchBrokerageSlab(
      int projectId, int cpTypeId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_brokerage_slab'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "project_id": projectId,
        "cp_type_id": cpTypeId, // Include cp_type_id in the request
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch brokerage slab');
    }
  }

  static Future<List<dynamic>> fetchProjectImages(int projectId) async {
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

  static Future<List<dynamic>> fetchProjectAttachments(int projectId) async {
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

  static Future<List<dynamic>> fetchProjectLinks(int projectId) async {
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

    // Add files to the request
    request.files.add(await http.MultipartFile.fromPath(
        'status_thumbnail_img', thumbnailImage.path));
    request.files.add(
        await http.MultipartFile.fromPath('status_full_img', fullImage.path));

    // Print request details
    print('Request:');
    print('URL: ${request.url}');
    print('Fields: ${request.fields}');
    for (var file in request.files) {
      print('File: ${file.filename}'); // Print file name
    }

    try {
      final response = await request.send();

      // Read response body
      final responseBody = await http.Response.fromStream(response);
      print('Response status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');

      // Return true if the response status is 200
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

  static Future<void> addProjectDetails({
    required String userId,
    required String projectName,
    required String description,
    required String address,
    required String mapLocation,
    required String pricingDesc,
    required int isFeatured,
    required String website,
    required List<String> configurations,
    required List<File> projectImages,
    required List<File> projectAttachments,
    required File projectThumbnailImg,
    required String projectLink,
    required List<String> brokerageSlabs,
    required List<int> cpTypeIds, // Added parameter for brokerage slabs
  }) async {
    var uri = Uri.parse('${baseUrl}add_project_details');
    var request = http.MultipartRequest('POST', uri);

    // Add fields
    request.fields['user_id'] = userId;
    request.fields['property_name'] = projectName;
    request.fields['description'] = description;
    request.fields['address'] = address;
    request.fields['map_location'] = mapLocation;
    request.fields['pricing_desc'] = pricingDesc;
    request.fields['is_featured'] = isFeatured.toString();
    request.fields['website'] = website;
    request.fields['project_link'] = projectLink;

    // Add configurations
    for (int i = 0; i < configurations.length; i++) {
      request.fields['configuration[$i]'] = configurations[i];
    }

    // Add brokerage slabs

    for (int i = 0; i < brokerageSlabs.length; i++) {
      request.fields['brokerage_slab[$i]'] = brokerageSlabs[i];

      request.fields['cp_type_id'] = cpTypeIds[i].toString();
    }

    // Add project images
    for (int i = 0; i < projectImages.length; i++) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'project_image[$i]', projectImages[i].path),
      );
    }

    // Add project attachments
    for (int i = 0; i < projectAttachments.length; i++) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'project_attachment[$i]', projectAttachments[i].path),
      );
    }

    // Add project thumbnail image
    request.files.add(
      await http.MultipartFile.fromPath(
          'project_thumbnail_img', projectThumbnailImg.path),
    );

    // Print request details (URL, fields, and files)
    print('Request URL: ${request.url}');
    print('Request fields: ${request.fields}');
    print(
        'Request files: ${request.files.map((file) => file.filename).toList()}');

    // Send the request
    var response = await request.send();

    // Parse the response body
    var responseBody = await http.Response.fromStream(response);
    print('Response status: ${response.statusCode}');
    print('Response body: ${responseBody.body}');

    // Check response status
    if (response.statusCode == 200) {
      print('Project created successfully');
    } else {
      print('Failed to create project');
    }
  }

  static Future<List<String>> fetchImages(int projectId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}fetch_project_images'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'project_id': projectId,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      // Extract project_image URLs and return as a list of strings
      return responseData
          .map((imageData) =>
              'https://rrpl-dev.portalwiz.in/api/storage/app/${imageData["project_image"]}')
          .toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  static Future<Map<String, dynamic>?> editProjectDetails({
    required int projectId,
    required String userId,
    required String propertyName,
    required String description,
    required String address,
    required String pricingDesc,
    required bool isFeatured,
    required String website,
    required String? projectThumbnailImg,
    required String maplocation,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}add_project_details'),
    );

    // Add fields to the request
    request.fields['user_id'] = userId;
    request.fields['property_name'] = propertyName;
    request.fields['description'] = description;
    request.fields['address'] = address;
    request.fields['pricing_desc'] = pricingDesc;
    request.fields['is_featured'] = isFeatured ? '1' : '0';
    request.fields['website'] = website;
    request.fields['project_id'] = projectId.toString();
    request.fields['map_location'] = maplocation;
    // Print the request fields for debugging
    print("Request Fields:");
    print(request.fields);

    // Attach image if provided
    if (projectThumbnailImg != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'project_thumbnail_img',
          projectThumbnailImg,
        ),
      );
      print(
          "Attached Image: $projectThumbnailImg"); // Print attached image path
    }

    try {
      var response = await request.send();

      print('Response Status Code: ${response.statusCode}');

      final responseBody = await response.stream.bytesToString();
      print('Response Body: $responseBody'); // Print response body

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        return {'success': false, 'message': 'Failed to update project.'};
      }
    } catch (e) {
      print('Error: $e');
      return null; // Return null on error
    }
  }

  static Future<void> addProjectImages({
    required int userId,
    required int projectId,
    required List<File> projectImages, // Expecting a list of image files
  }) async {
    // Create a multipart request
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl}add_project_images'));
    request.fields['user_id'] = userId.toString();
    request.fields['project_id'] = projectId.toString();

    // Add images to the request
    for (int i = 0; i < projectImages.length; i++) {
      var image = await http.MultipartFile.fromPath(
        'project_image[$i]', // Use the correct key format
        projectImages[i].path,
      );
      request.files.add(image);
    }

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Images uploaded successfully');
    } else {
      print('Failed to upload images: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> addProjectConfiguration({
    required int userId,
    required int projectId,
    required List<String> configuration,
  }) async {
    final url = Uri.parse('${baseUrl}add_project_configuration');

    final requestBody = jsonEncode({
      'user_id': userId,
      'project_id': projectId,
      'configuration': configuration,
    });

    print('Request URL: $url');
    print('Request Body: $requestBody');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      if (responseData.isNotEmpty && responseData[0] is Map<String, dynamic>) {
        return responseData[0];
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to add project configuration');
    }
  }

  static Future<bool> addBrokerageSlab(
      int userId, int projectId, List<String> slabs) async {
    final url = Uri.parse('${baseUrl}add_brokerage_slab');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode(
        {"user_id": userId, "project_id": projectId, "brokerage_slab": slabs});

    try {
      print('Request URL: $url');
      print('Request Headers: $headers');
      print('Request Body: $body');

      final response = await http.post(url, headers: headers, body: body);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to add brokerage slab: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> addProjectAttachment(
      int userId, int projectId, String attachmentPath) async {
    final url = Uri.parse('${baseUrl}add_project_attachments');
    final request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = userId.toString()
      ..fields['project_id'] = projectId.toString();

    // Attach the file to the request
    if (attachmentPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'project_attachment', attachmentPath));
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // If the server returns a success response
        return true;
      } else {
        // Handle other status codes or errors
        print('Failed to add project attachment: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<void> addProjectLink(
      int userId, int projectId, String projectLink) async {
    final url = Uri.parse('${baseUrl}add_project_links');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'project_id': projectId,
        'project_link': projectLink,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add project link: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCpTypes() async {
    final response = await http.get(Uri.parse('${baseUrl}cp_type_dropdown'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .map((e) => {'cp_type_id': e['cp_type_id'], 'cp_type': e['cp_type']})
          .toList();
    } else {
      throw Exception('Failed to load CP Types');
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('${baseUrl}login');

    // Prepare request body
    final requestBody = jsonEncode({
      'email_id': email,
      'password': password,
    });

    // Print the request body
    print('Request URL: $url');
    print('Request Body: $requestBody');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    // Print the response status and body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<List<Project>> fetchProjectsDropdown() async {
    final response = await http.get(Uri.parse('${baseUrl}project_dropdown'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((project) => Project.fromJson(project)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  static Future<void> addProjectEnquiry({
    required int projectId,
    required String name,
    required String mobileNo,
    required String emailId,
    required String enquiry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    print('User ID retrieved from SharedPreferences: $userId');

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'user_id': userId,
      'project_id': projectId,
      'name': name,
      'mobile_no': mobileNo,
      'email_id': emailId,
      'enquiry': enquiry,
    };

    // Print the request body
    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      Uri.parse('${baseUrl}add_project_enquiry'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Print the response body
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to submit enquiry');
    }
  }

  static Future<List<Enquiry>> fetchProjectEnquiries() async {
    final response =
        await http.get(Uri.parse('${baseUrl}fetch_project_enquiries'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Enquiry.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load enquiries');
    }
  }

  static Future<bool> addBooking({
    required int userId,
    required int projectId,
    required String name,
    required String mobileNo,
    required String emailId,
  }) async {
    // Prepare request body
    final requestBody = jsonEncode({
      'user_id': userId,
      'project_id': projectId,
      'name': name,
      'mobile_no': mobileNo,
      'email_id': emailId,
    });

    // Print the request body
    print('Request Body: $requestBody');

    final response = await http.post(
      Uri.parse('${baseUrl}add_booking'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    // Print the response body and status code
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Booking>> fetchBookings() async {
    final response = await http.get(Uri.parse('${baseUrl}fetch_booking'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      // Parse the response and convert it to a list of Booking objects
      return jsonData.map((item) => Booking.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}
