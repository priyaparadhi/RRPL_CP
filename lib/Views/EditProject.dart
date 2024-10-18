import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class EditProject extends StatefulWidget {
  final int projectId;

  EditProject({required this.projectId});
  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProject> {
  String? _projectName;
  String? _address;
  String? _pricingDesc;
  String? _description;
  String? _uploadedImage;
  List<bool> _selections = [true, false, false];
  List<String> _uploadedImages = [];
  List<File> _localImages = [];
  List<String> _configurations = [];
  int _selectedConfigurationIndex = -1;
  List<String> _brokerageSlabs = [];
  final ImagePicker _picker = ImagePicker();
  String _websiteUrl = '';
  String _directions = '';
  String? _selectedDocument;
  String? _selectedLink;
  String? _document;
  String? _link;
  bool _isFeatured = false;
  List<dynamic> _attachments = [];
  List<dynamic> _projectLinks = [];

// For the entered link

  @override
  void initState() {
    super.initState();
    _fetchProjectDetails();
    _loadProjectImages();
    _fetchConfigurations();
    //_fetchAndSetBrokerageSlabs();
    _fetchAttachments();
    _fetchLinks();
  }

  Future<void> _fetchProjectDetails() async {
    // Make your API call to fetch project details
    final response = await ApiCalls.fetchSingleProject(widget.projectId);

    if (response != null) {
      setState(() {
        _projectName = response['property_name'];
        _address = response['address'];
        _pricingDesc = response['pricing_desc'];
        _description = response['description'];
        _uploadedImage = response['project_thumbnail_img'].startsWith('http')
            ? response[
                'project_thumbnail_img'] // Use full URL if it already starts with 'http'
            : 'https://rrpl-dev.portalwiz.in/api/storage/app/${response['project_thumbnail_img']}';
        _isFeatured = response['is_featured'] == 1;
        _websiteUrl = response['website'] ?? '';
        _directions = response['map_location'] ?? '';
      });
    }
  }

  Future<void> _loadProjectImages() async {
    try {
      final images = await ApiCalls.fetchImages(
          widget.projectId); // Pass the actual project ID here
      setState(() {
        _uploadedImages = images; // This is now a List<String> of URLs
      });
    } catch (error) {
      print('Error fetching project images: $error');
    }
  }

  Future<void> _fetchConfigurations() async {
    try {
      final configurations = await ApiCalls.fetchProjectConfiguration(
          widget.projectId); // Replace with your project ID
      setState(() {
        _configurations = configurations
            .map((config) => config['configuration'] as String)
            .toList(); // Store configurations in _configurations
      });
    } catch (error) {
      print('Error fetching configurations: $error');
    }
  }

  // Future<void> _fetchAndSetBrokerageSlabs() async {
  //   try {
  //     // Call the API to fetch brokerage slabs
  //     List<dynamic> fetchedSlabs =
  //         await ApiCalls.fetchBrokerageSlab(widget.projectId,);
  //     setState(() {
  //       _brokerageSlabs = fetchedSlabs
  //           .map((slab) => slab['brokerage_slab'].toString())
  //           .toList();
  //     });
  //   } catch (error) {
  //     print('Failed to fetch brokerage slabs: $error');
  //   }
  // }

  Future<void> _fetchAttachments() async {
    try {
      // Call the API to fetch project attachments
      List<dynamic> fetchedAttachments =
          await ApiCalls.fetchProjectAttachments(widget.projectId);
      setState(() {
        _attachments = fetchedAttachments;
      });
    } catch (error) {
      print('Failed to load project attachments: $error');
    }
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _fetchLinks() async {
    try {
      // Fetch project links from API
      List<dynamic> fetchedLinks =
          await ApiCalls.fetchProjectLinks(widget.projectId);
      setState(() {
        _projectLinks = fetchedLinks;
      });
    } catch (error) {
      print('Failed to load project links: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Project',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),

// Upload Single Photo Section
              GestureDetector(
                onTap: _pickSingleImage, // Allows the user to pick a new image
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: _uploadedImage != null
                        ? DecorationImage(
                            image: _uploadedImage!.contains('http')
                                ? NetworkImage(
                                    _uploadedImage!) // Use the updated full URL
                                : FileImage(File(_uploadedImage!))
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _uploadedImage == null
                      ? Center(
                          child: Text(
                            'Upload Photo',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        )
                      : null,
                ),
              ),

              SizedBox(height: 16),

// Project Name Field
              _buildTextField(
                label: 'Project Name',
                onTap: () => _showTextInputDialog('Project Name', (value) {
                  setState(() {
                    _projectName = value;
                  });
                }, initialValue: _projectName ?? ''), // Pass the initial value
                value: _projectName ?? 'Enter Project Name',
                isBold: true,
                fontSize: 22,
              ),

// Address Field
              _buildTextField(
                label: 'Address',
                onTap: () => _showTextInputDialog('Address', (value) {
                  setState(() {
                    _address = value;
                  });
                }, initialValue: _address ?? ''), // Pass the initial value
                value: _address ?? 'Enter Address',
                fontSize: 16,
              ),

// Pricing Description Field
              _buildTextField(
                label: 'Pricing Details',
                onTap: () => _showTextInputDialog('Pricing Details', (value) {
                  setState(() {
                    _pricingDesc = value;
                  });
                }, initialValue: _pricingDesc ?? ''), // Pass the initial value
                value: _pricingDesc ?? 'Enter Pricing Details',
                isPricingField: true,
                fontSize: 20,
              ),

// Project Description Field
              _buildTextField(
                label: 'Project Description',
                onTap: () =>
                    _showTextInputDialog('Project Description', (value) {
                  setState(() {
                    _description = value;
                  });
                }, initialValue: _description ?? ''), // Pass the initial value
                value: _description ?? 'Enter Project Description',
                fontSize: 16,
              ),

              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ToggleButtons(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text('Website'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text('Share'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text('Directions'),
                        ),
                      ],
                      isSelected: _selections,
                      onPressed: (index) => _onTogglePressed(index),
                      fillColor: Colors.orange, // Color when active
                      selectedColor: Colors.white, // Text color when active
                      color: Colors.black, // Text color when inactive
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              // Multiple Photos Section
              SizedBox(height: 20),
              Text('Uploaded Photos',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)), // Title
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickMultipleImages,
                child: _buildPhotoUploadSection(),
              ),
              SizedBox(height: 10),

              GestureDetector(
                onTap: _showConfigurationDialog,
                child: _buildConfigurationSection(),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brokerage Slabs',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _showBrokerageSlabDialog, // Open dialog on tap
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10), // Padding for the tap area
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[300], // Background color for the tap area
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('Add Brokerage Slab',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Display fetched brokerage slabs
                    _brokerageSlabs.isEmpty
                        ? Center(
                            child: Text('No brokerage slabs available',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)))
                        : Column(
                            children: _brokerageSlabs.map((slab) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(slab,
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documents',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if (_selectedDocument == null)
                      GestureDetector(
                        onTap: _uploadDocument,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('Upload Document',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    if (_selectedDocument != null)
                      Row(
                        children: [
                          Icon(Icons.insert_drive_file,
                              size: 20, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              path.basename(
                                  _selectedDocument!), // Show only the file name
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    // if (_selectedDocument == null)
                    //   Text('No document selected.',
                    //       style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 20),
                    if (_attachments.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Project Attachments',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ..._attachments.map((attachment) {
                            String fileUrl =
                                'https://rrpl-dev.portalwiz.in/api/storage/app/${attachment['project_attachment']}';
                            String fileName =
                                path.basename(fileUrl); // Extract the file name

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      _launchURL(fileUrl), // Launch URL on tap
                                  child: Row(
                                    children: [
                                      Icon(Icons.attachment,
                                          color: Colors.blue),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          fileName, // Show only the file name
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          }).toList(),
                        ],
                      )
                    else
                      Text('No attachments available.'),
                  ],
                ),
              ),
// Links Section
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Links',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Show enter link button only if no link is added
                    if (_selectedLink == null)
                      GestureDetector(
                        onTap: _showLinkInputDialog,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('Enter Link',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    // Display the added link with an icon
                    if (_selectedLink != null)
                      Row(
                        children: [
                          Icon(Icons.link, size: 20, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text('$_selectedLink',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    // if (_selectedLink == null)
                    //   Text('No link added.',
                    //       style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 20),
                    // Display fetched project links
                    if (_projectLinks.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Project Links',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ..._projectLinks.map((link) {
                            String linkUrl = link['project_link'];
                            Uri uri = Uri.parse(linkUrl);
                            String linkText =
                                uri.host; // Extract the domain name

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => _launchURL(
                                      linkUrl), // Open link with URL launcher
                                  child: Row(
                                    children: [
                                      Icon(Icons.link, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          linkText, // Show only the domain name
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          }).toList(),
                        ],
                      )
                    else
                      Text('No links available.'),
                  ],
                ),
              ),
              SizedBox(width: 8),
              SwitchListTile(
                title: Text(
                  'Featured Project',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_isFeatured ? 'Only Featured' : 'All Projects'),
                value: _isFeatured,
                onChanged: (bool value) {
                  setState(() {
                    _isFeatured = value;
                  });
                },
                secondary: Icon(
                  _isFeatured ? Icons.star : Icons.star_border,
                  color: _isFeatured ? Colors.orange : Colors.grey,
                ),
              ),
              SizedBox(height: 25),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _editProject(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text('Edit Project'),
                ),
              ),

              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editProject(BuildContext context) async {
    try {
      final String? projectThumbnailImg =
          _uploadedImage!.contains('http') ? null : _uploadedImage;

      final response = await ApiCalls.editProjectDetails(
        projectId: widget.projectId,
        userId: '1',
        propertyName: _projectName ?? '',
        description: _description ?? '',
        address: _address ?? '',
        pricingDesc: _pricingDesc ?? '',
        isFeatured: _isFeatured,
        website: _websiteUrl,
        maplocation: _directions,
        projectThumbnailImg: projectThumbnailImg,
      );

      if (response != null && response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?['message'] ?? 'Failed to update project.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;

      setState(() {
        _selectedDocument = filePath;
      });

      int userId = 1;
      int projectId = widget.projectId;

      bool success =
          await ApiCalls.addProjectAttachment(userId, projectId, filePath!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload document.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showLinkInputDialog() async {
    String? link;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Link'),
          content: TextField(
            onChanged: (value) {
              link = value;
            },
            decoration: InputDecoration(hintText: "Enter link here"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                if (link != null && link!.isNotEmpty) {
                  setState(() {
                    _selectedLink = link;
                  });

                  try {
                    await ApiCalls.addProjectLink(1, widget.projectId, link!);
                    // Show a Snackbar indicating success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Link added successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    print('Error adding project link: $e');
                    // Optionally, show an error Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add link. Please try again.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBrokerageSlabDialog() {
    String? slab;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Brokerage Slab'),
          content: TextField(
            onChanged: (value) {
              slab = value;
            },
            decoration: InputDecoration(hintText: 'Enter brokerage slab'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (slab != null && slab!.isNotEmpty) {
                  int userId = 1;
                  int projectId = widget.projectId;

                  List<String> slabs = [slab!];

                  bool success =
                      await ApiCalls.addBrokerageSlab(userId, projectId, slabs);

                  if (success) {
                    setState(() {
                      _brokerageSlabs.add(slab!);
                    });
                    Navigator.pop(context);

                    // Show success snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Brokerage slab added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    print('Failed to add brokerage slab.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add brokerage slab.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required Function onTap,
    required String value,
    bool isBold = false,
    bool isPricingField = false,
    double fontSize = 16, // Default font size
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16.0), // Adjust top margin as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isPricingField ? Colors.orange : Colors.black,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.edit, // Edit icon
              color: Colors.orange,
              size: 20, // Adjust size as per design
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: _showConfigurationDialog,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child:
                    Text('Add Configuration', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _configurations.map((config) {
                int index = _configurations.indexOf(config);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedConfigurationIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildConfigButton(
                      config,
                      index == _selectedConfigurationIndex,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigButton(String label, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showConfigurationDialog() {
    String newConfiguration = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Configuration'),
          content: TextField(
            onChanged: (value) {
              newConfiguration = value; // Capture input
            },
            decoration: InputDecoration(hintText: "Enter Configuration"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (newConfiguration.isNotEmpty) {
                  try {
                    // Call API with the new configuration only
                    final response = await ApiCalls.addProjectConfiguration(
                      userId: 1, // Replace with actual user ID
                      projectId:
                          widget.projectId, // Pass the current project ID
                      configuration: [
                        newConfiguration
                      ], // Send only the new configuration
                    );

                    // Show a message based on the response
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['message']),
                        backgroundColor:
                            response['success'] ? Colors.green : Colors.red,
                      ),
                    );

                    // Optionally, add the new configuration to the local list if successful
                    if (response['success']) {
                      setState(() {
                        _configurations
                            .add(newConfiguration); // Add configuration to list
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    Navigator.of(context).pop(); // Close dialog
                  }
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showTextInputDialog(String title, Function(String) onSubmitted,
      {String initialValue = ''}) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter here'),
              maxLines: 2,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                onSubmitted(controller.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhotoUploadSection() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white, // Background color for the photo section
        borderRadius: BorderRadius.circular(10),
      ),
      child: _uploadedImages.isEmpty
          ? Center(
              child: Text(
                'Upload Images',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _uploadedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImageCard(_uploadedImages[index]),
                );
              },
            ),
    );
  }

  Widget _buildImageCard(String imageUrl) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Function to pick a single image
  void _pickSingleImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedImage = pickedFile.path; // Store the local file path
      });
    }
  }

  // Function to pick multiple images
  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _localImages =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });

      // Now, upload the images to the server
      try {
        await ApiCalls.addProjectImages(
          userId: 1, // Replace with the actual user ID
          projectId:
              widget.projectId, // Assuming you have the project ID from widget
          projectImages: _localImages, // Use the selected local images
        );

        // After successful upload, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Images added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Optionally, you may want to fetch the updated images
        await _loadProjectImages(); // Call to fetch images again to update UI
      } catch (error) {
        print('Error uploading images: $error');
      }
    }
  }

  void _onTogglePressed(int index) {
    setState(() {
      // Update toggle selections
      for (int i = 0; i < _selections.length; i++) {
        _selections[i] = i == index;
      }

      // Show dialog based on the selected index
      switch (index) {
        case 0: // Website
          _showTextInputDialog('Enter Website URL', (value) {
            setState(() {
              _websiteUrl = value;
            });
          }, initialValue: _websiteUrl); // Pass the initial value
          break;
        case 1: // Share
          // Logic for sharing can be implemented here
          break;
        case 2: // Directions
          _showTextInputDialog('Enter Directions', (value) {
            setState(() {
              _directions = value;
            });
          }, initialValue: _directions); // Pass the initial value
          break;
      }
    });
  }
}
