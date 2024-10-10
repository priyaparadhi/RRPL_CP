import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProject extends StatefulWidget {
  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = []; // Initialize with an empty list

  // Sample options for broker slabs and configurations
  final List<String> brokerSlabs = ['1%', '2%', '3%', '4%'];
  final List<String> configurations = ['1BHK', '2BHK', '3BHK', '4BHK'];

  String propertyName = '';
  String description = '';
  String amenities = '';
  String builder = '';
  String address = '';
  String mapLocation = '';
  String selectedBrokerSlab = '1%';
  String selectedConfiguration = '1BHK';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Project',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      _buildTextField('Project Name', (value) {
                        propertyName = value!;
                      }),
                      _buildTextField('Description', (value) {
                        description = value!;
                      }),
                      _buildTextField('Amenities', (value) {
                        amenities = value!;
                      }),
                      _buildTextField('Builder', (value) {
                        builder = value!;
                      }),
                      _buildTextField('Address', (value) {
                        address = value!;
                      }),
                      _buildTextField('Map Location', (value) {
                        mapLocation = value!;
                      }),
                      // Dropdown fields
                      _buildDropdownField('Broker Slab', brokerSlabs, (value) {
                        setState(() {
                          selectedBrokerSlab = value!;
                        });
                      }),
                      _buildDropdownField('Configuration', configurations,
                          (value) {
                        setState(() {
                          selectedConfiguration = value!;
                        });
                      }),
                      _buildTextField('Link', (value) {
                        // Handle link input
                      }),
                      _buildUploadContainer(),
                      SizedBox(height: 20),
                      _buildImagePreview(), // Display selected images
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Submit the form
                              print('Property Name: $propertyName');
                              print('Description: $description');
                              print('Amenities: $amenities');
                              print('Builder: $builder');
                              print('Address: $address');
                              print('Map Location: $mapLocation');
                              print('Broker Slab: $selectedBrokerSlab');
                              print('Configuration: $selectedConfiguration');
                            }
                          },
                          child: Text('Add Project',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?)? onSaved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          filled: true,
          fillColor: Colors.white,
        ),
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Upload Photos Container
  Widget _buildUploadContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.black),
              onPressed: () async {
                // Capture image from camera
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _imageFileList!.add(image);
                  });
                }
              },
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.photo_library, color: Colors.black),
              onPressed: () async {
                final List<XFile>? pickedFileList =
                    await _picker.pickMultiImage();
                if (pickedFileList != null) {
                  setState(() {
                    _imageFileList!.addAll(pickedFileList);
                  });
                }
              },
            ),
            SizedBox(width: 8),
            Text('Upload Photos', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Display selected images
  Widget _buildImagePreview() {
    if (_imageFileList!.isEmpty) {
      return Container(); // Return an empty container if no images are selected
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Display 3 images per row
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _imageFileList!.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(
              File(_imageFileList![index].path),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  // Dropdown field widget
  Widget _buildDropdownField(
      String label, List<String> options, Function(String?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: options[0],
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  // Flat number input widget
  Widget _buildFlatField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Flat Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter Flat Number';
          }
          return null;
        },
      ),
    );
  }
}
