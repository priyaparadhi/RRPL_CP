import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/Views/EditProject.dart';
import 'package:rrpl_app/Widget/FullImage.dart';
import 'package:rrpl_app/models/ProjectModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetails extends StatefulWidget {
  late final Project project;
  ProjectDetails({required this.project});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectDetails> {
  List<bool> _selections = [true, false, false];
  List<String> _configurations = []; // Store configurations here

  int _selectedConfigurationIndex = 0;
  late Future<List<dynamic>> _brokerageSlabs;
  late Future<List<dynamic>> _projectImages;
  late Future<List<dynamic>> _attachments;
  late Future<List<dynamic>> _links;
  late Future<Map<String, dynamic>> _projectDetails;
  String websiteUrl = ''; // Dynamic website URL
  String mapLocation = ''; // Dynamic map location
  @override
  void initState() {
    super.initState();
    _fetchConfigurations();
    _fetchBrokerageSlabs();
    _projectImages = ApiCalls.fetchProjectImages(widget.project.projectId ?? 0);
    _attachments =
        ApiCalls.fetchProjectAttachments(widget.project.projectId ?? 0);
    _links = ApiCalls.fetchProjectLinks(widget.project.projectId ?? 0);
    _projectDetails =
        ApiCalls.fetchSingleProject(widget.project.projectId ?? 0);
  }

  void _onTogglePressed(int index, Map<String, dynamic> project) async {
    setState(() {
      for (int i = 0; i < _selections.length; i++) {
        _selections[i] = i == index; // Only one toggle active at a time
      }
    });

    if (index == 0) {
      // Open the website using the fetched URL from the API
      String websiteUrl = project['website'] ?? '';
      _showWebsiteBottomSheet(context, websiteUrl);
    } else if (index == 1) {
      // Handle Share logic here
    } else if (index == 2) {
      // Handle Directions logic using location from API
      String? mapLocation = project['map_location']; // Fetch from API response

      if (mapLocation != null && mapLocation.isNotEmpty) {
        if (!await launchUrl(
          Uri.parse(mapLocation),
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $mapLocation');
        }
      } else {
        // Fallback in case mapLocation is not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Map location not available')),
        );
      }
    }
  }

  void _fetchConfigurations() async {
    try {
      final List<dynamic> configurations =
          await ApiCalls.fetchProjectConfiguration(
              widget.project.projectId ?? 0);
      setState(() {
        _configurations = configurations
            .map((config) => config['configuration'] as String)
            .toList();
      });
    } catch (e) {
      // Handle error (e.g., show a Snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load configurations')));
    }
  }

  Future<void> _fetchProjectDetails() async {
    setState(() {
      _projectDetails =
          ApiCalls.fetchSingleProject(widget.project.projectId ?? 0);
    });
  }

  Future<void> _fetchBrokerageSlabs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? cpTypeId =
        prefs.getInt('cp_type_id'); // Fetch cp_type_id from SharedPreferences

    if (cpTypeId != null) {
      _brokerageSlabs =
          ApiCalls.fetchBrokerageSlab(widget.project.projectId ?? 0, cpTypeId);
    } else {
      // Handle the case where cp_type_id is not available
      // You might want to show an error message or set a default value
      _brokerageSlabs =
          Future.value([]); // Return an empty list if no cp_type_id found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProject(
                    projectId: widget.project.projectId ?? 0,
                  ),
                ),
              ).then((_) {
                _fetchProjectDetails(); // Call the refresh function
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _projectDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final project = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display project thumbnail image
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://rrpl-dev.portalwiz.in/api/storage/app/${project['project_thumbnail_img']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project['property_name'] ?? 'Project Name',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          project['address'] ?? 'Address',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          project['pricing_desc'] ?? 'Pricing Details',
                          style: TextStyle(fontSize: 20, color: Colors.orange),
                        ),
                        SizedBox(height: 16),
                        Text(
                          project['description'] ?? 'Project Description',
                          style: TextStyle(fontSize: 14),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0),
                                    child: Text('Website'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0),
                                    child: Text('Share'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0),
                                    child: Text('Directions'),
                                  ),
                                ],
                                isSelected: _selections,
                                onPressed: (index) =>
                                    _onTogglePressed(index, project),
                                fillColor: Colors.orange, // Color when active
                                selectedColor:
                                    Colors.white, // Text color when active
                                color: Colors.black, // Text color when inactive
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        _buildImagesSection(),
                        SizedBox(height: 16),
                        _buildConfigurationSection(),
                        SizedBox(height: 16),
                        _buildBrokerageSection(),
                        SizedBox(height: 16),
                        _buildDocumentsSection(),
                        SizedBox(height: 16),
                        _buildLinksSection(),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No projects available'));
          }
        },
      ),
    );
  }

  Widget _buildImagesSection() {
    return FutureBuilder<List<dynamic>>(
      future: _projectImages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          List<dynamic> images = snapshot.data!;
          return Container(
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
                  'Images (${images.length})',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      String imageUrl =
                          'https://rrpl-dev.portalwiz.in/api/storage/app/${images[index]['project_image']}'; // Construct the full image URL

                      print('Image URL: $imageUrl');

                      return Row(
                        children: [
                          _buildImageCard(context, imageUrl),
                          SizedBox(width: 8),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No images found'));
        }
      },
    );
  }

  Widget _buildImageCard(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        // Navigate to the FullImagePage when the image is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullImagePage(imageUrl: imageUrl)),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imageUrl), // Use the image URL from the API
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildConfigurationSection() {
    return Container(
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _configurations.map((config) {
                int index = _configurations.indexOf(config);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedConfigurationIndex =
                          index; // Update selected index
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0), // Space between buttons
                    child: _buildConfigButton(
                        config,
                        index ==
                            _selectedConfigurationIndex), // Pass selection state
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Carpet Area',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '562 Sq ft',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '67 Lacs',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildBrokerageSection() {
    return FutureBuilder<List<dynamic>>(
      future: _brokerageSlabs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          List<dynamic> slabs = snapshot.data!;
          return Container(
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
                  'Brokerage Slab',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: slabs.map((slab) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slab['brokerage_slab'],
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                        Divider(),
                      ],
                    );
                  }).toList(),
                ),
                // SizedBox(height: 8),
                // Text(
                //   'Valid till 30th June',
                //   style: TextStyle(color: Colors.black),
                // ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data found'));
        }
      },
    );
  }

  Widget _buildDocumentsSection() {
    return Container(
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
      child: FutureBuilder<List<dynamic>>(
        future: _attachments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<dynamic> attachments = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documents (${attachments.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ...attachments.map((attachment) {
                  String fileUrl =
                      'https://rrpl-dev.portalwiz.in/api/storage/app/${attachment['project_attachment']}'; // Construct full URL
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.picture_as_pdf, color: Colors.red),
                          SizedBox(width: 8),
                          // Change this line to display "Document" instead of the full name
                          Text('Document'),
                        ],
                      ),
                      IconButton(
                          icon: Icon(Icons.open_in_new, color: Colors.black),
                          onPressed: () async {
                            if (!await launchUrl(
                              Uri.parse(fileUrl),
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw Exception('Could not launch $fileUrl');
                            }
                          }),
                    ],
                  );
                }).toList(),
              ],
            );
          } else {
            return Center(child: Text('No documents found.'));
          }
        },
      ),
    );
  }

  Widget _buildLinksSection() {
    return Container(
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
      child: FutureBuilder<List<dynamic>>(
        future: _links,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<dynamic> links = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Links (${links.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ...links.map((link) {
                  String projectLink =
                      link['project_link']; // Extract the project link
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.link, color: Colors.blue),
                          SizedBox(width: 8),
                          // Display the text "Link" instead of the full URL
                          Text('Link'),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.open_in_new, color: Colors.black),
                        onPressed: () async {
                          if (!await launchUrl(
                            Uri.parse(projectLink),
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $projectLink');
                          }
                        },
                      ),
                    ],
                  );
                }).toList(),
              ],
            );
          } else {
            return Center(child: Text('No links found.'));
          }
        },
      ),
    );
  }

  void _showWebsiteBottomSheet(BuildContext context, String websiteUrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Visit Website',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  // Open the website in a browser
                  _launchURL(websiteUrl);
                },
                child: Text(
                  websiteUrl,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Copy Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: websiteUrl));
                      Navigator.pop(context); // Close the bottom sheet
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Link copied to clipboard')),
                      );
                    },
                    icon: Icon(Icons.copy, size: 18),
                    label: Text('Copy'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  // Quick Share Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Share.share(websiteUrl);
                    },
                    icon: Icon(Icons.share, size: 18),
                    label: Text('Quick Share'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchURL(String websiteUrl) async {
    if (websiteUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid URL')),
      );
      return;
    }

    // Ensure the URL starts with http or https
    if (!websiteUrl.startsWith('http://') &&
        !websiteUrl.startsWith('https://')) {
      websiteUrl = 'https://$websiteUrl';
    }

    // Encode the URL
    final encodedUrl = Uri.encodeFull(websiteUrl);

    print('Launching URL: $encodedUrl'); // Debugging output

    if (!await launchUrl(
      Uri.parse(encodedUrl),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $encodedUrl');
    }
  }
}
