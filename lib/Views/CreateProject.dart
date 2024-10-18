import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this package for image picking
import 'dart:io';

import 'package:rrpl_app/ApiCalls/ApiCalls.dart'; // For handling file system operations

class CreateProjectPage extends StatefulWidget {
  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  String? _projectName;
  String? _address;
  String? _pricingDesc;
  String? _description;
  String? _uploadedImage;
  List<bool> _selections = [true, false, false];
  List<File> _uploadedImages = [];
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
  List<int> _cpTypeIds = [];
// For the entered link

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Project',
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
              SizedBox(height: 16),

              // Upload Single Photo Section
              GestureDetector(
                onTap: _pickSingleImage, // Picking only one image
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: _uploadedImage != null
                        ? DecorationImage(
                            image: FileImage(File(_uploadedImage!)),
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
                }),
                value: _projectName ?? 'Enter Project Name',
                isBold: true, // Make text bold
                fontSize: 22, // Set font size to 22
              ),

              // Address Field
              _buildTextField(
                label: 'Address',
                onTap: () => _showTextInputDialog('Address', (value) {
                  setState(() {
                    _address = value;
                  });
                }),
                value: _address ?? 'Enter Address',
                fontSize: 16, // Default font size
              ),

              // Pricing Description Field
              _buildTextField(
                label: 'Pricing Details',
                onTap: () => _showTextInputDialog('Pricing Details', (value) {
                  setState(() {
                    _pricingDesc = value;
                  });
                }),
                value: _pricingDesc ?? 'Enter Pricing Details',
                isPricingField: true, // Special styling for pricing details
                fontSize: 20, // Set font size to 22
              ),

              // Project Description Field
              _buildTextField(
                label: 'Project Description',
                onTap: () =>
                    _showTextInputDialog('Project Description', (value) {
                  setState(() {
                    _description = value;
                  });
                }),
                value: _description ?? 'Enter Project Description',
                fontSize: 16, // Default font size
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
                width: double.infinity, // Makes the container full width
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
                    ..._brokerageSlabs.map((slab) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Aligns text to the start
                            children: [
                              Expanded(
                                child:
                                    Text(slab, style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
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
                    // Show upload document button only if no document is selected
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
                    // Display the selected document with an icon
                    if (_selectedDocument != null)
                      Row(
                        children: [
                          Icon(Icons.insert_drive_file,
                              size: 20, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text('Selected Document: $_selectedDocument',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    if (_selectedDocument == null)
                      Text('No document selected.',
                          style: TextStyle(color: Colors.grey)),
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
                            child: Text(' $_selectedLink',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    if (_selectedLink == null)
                      Text('No link added.',
                          style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              SizedBox(height: 20), // Space before the toggle switch
              // Toggle Switch for Featured Projects
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
                    if (_projectName != null &&
                        _address != null &&
                        _pricingDesc != null &&
                        _description != null &&
                        _uploadedImage != null) {
                      File projectThumbnail = File(_uploadedImage!);

                      // Call the API
                      await ApiCalls.addProjectDetails(
                        userId: '1',
                        projectName: _projectName!,
                        description: _description!,
                        address: _address!,
                        mapLocation: _directions,
                        pricingDesc: _pricingDesc!,
                        isFeatured: _isFeatured ? 1 : 0,
                        website: _websiteUrl,
                        projectThumbnailImg: projectThumbnail,
                        configurations: _configurations,
                        projectImages: _uploadedImages,
                        projectAttachments: [],
                        projectLink: _link ?? '',
                        brokerageSlabs: _brokerageSlabs,
                        cpTypeIds: _cpTypeIds,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Project created successfully!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all the fields')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text('Create Project'),
                ),
              ),

              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadDocument() async {
    // Logic to upload documents (use file picker or any other method)
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedDocument =
            result.files.single.path; // Store the selected document path
      });
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
              onPressed: () {
                if (link != null && link!.isNotEmpty) {
                  setState(() {
                    _selectedLink = link; // Store the entered link
                  });
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
    String? slabValue;
    String? selectedSlabType; // Track the selected slab type
    int? selectedCpTypeId; // To store the selected cp_type_id

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text('Add Brokerage Slab'),
              content: SizedBox(
                height: 150,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: ApiCalls.fetchCpTypes(), // Fetch CP types from API
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load CP Types'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No CP Types available'));
                    }

                    final cpTypes = snapshot.data!;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.grey[400]!, width: 1),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(
                              'Select Slab Type',
                              style: TextStyle(fontSize: 16),
                            ),
                            value: selectedSlabType, // Set the current value
                            isExpanded: true,
                            underline: SizedBox(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                selectedSlabType = newValue;
                                selectedCpTypeId = cpTypes.firstWhere(
                                    (cpType) =>
                                        cpType['cp_type'] ==
                                        newValue)['cp_type_id'];

                                print(
                                    'Selected CP Type ID: $selectedCpTypeId'); // Debugging
                              });
                            },
                            items:
                                cpTypes.map<DropdownMenuItem<String>>((cpType) {
                              return DropdownMenuItem<String>(
                                value: cpType['cp_type'],
                                child: Text(
                                  cpType['cp_type'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          onChanged: (value) {
                            slabValue = value;
                            print('Slab Value: $slabValue'); // Debugging
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter slab value',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey[400]!,
                                width: 1,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (slabValue != null &&
                        slabValue!.isNotEmpty &&
                        selectedCpTypeId != null) {
                      setState(() {
                        _brokerageSlabs.add(slabValue!);
                        _cpTypeIds.add(selectedCpTypeId!);
                        print('Added Brokerage Slab: $slabValue');
                        print('Added CP Type ID: $selectedCpTypeId');
                      });
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
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
    double fontSize = 16,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
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
            onTap: () {
              _showConfigurationDialog();
            },
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
              newConfiguration = value;
            },
            decoration: InputDecoration(hintText: "Enter Configuration"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newConfiguration.isNotEmpty) {
                  setState(() {
                    _configurations.add(newConfiguration);
                  });
                  Navigator.of(context).pop();
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

  void _showTextInputDialog(String title, Function(String) onSubmitted) {
    showDialog(
      context: context,
      builder: (context) {
        String inputValue = '';

        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) {
              inputValue = value;
            },
            decoration: InputDecoration(hintText: 'Enter $title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSubmitted(inputValue);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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

  Widget _buildImageCard(File imageFile) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: FileImage(imageFile),
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
        _uploadedImage = pickedFile.path; // Store image path
      });
    }
  }

  // Function to pick multiple images
  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _uploadedImages =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
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
          });
          break;
        case 1: // Share
          // Logic for sharing can be implemented here
          break;
        case 2: // Directions
          _showTextInputDialog('Enter Directions', (value) {
            setState(() {
              _directions = value;
            });
          });
          break;
      }
    });
  }
}
