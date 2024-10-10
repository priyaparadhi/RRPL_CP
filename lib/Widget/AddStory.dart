import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'dart:io';

class AddStoryForm extends StatefulWidget {
  @override
  _AddStoryFormState createState() => _AddStoryFormState();
}

class _AddStoryFormState extends State<AddStoryForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? title;
  String? description;
  String? link;
  File? _thumbnailImage;
  File? _fullImage;

  Future<void> _pickImage(bool isThumbnail) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isThumbnail) {
          _thumbnailImage = File(pickedFile.path);
        } else {
          _fullImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _takeImage(bool isThumbnail) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        if (isThumbnail) {
          _thumbnailImage = File(pickedFile.path);
        } else {
          _fullImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _addStatusUpdate() async {
    if (_thumbnailImage == null || _fullImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both images.')),
      );
      return;
    }

    final success = await ApiCalls.addStatusUpdate(
      userId: '1', // Replace with dynamic user ID if needed
      title: title ?? '',
      description: description ?? '',
      link: link,
      thumbnailImage: _thumbnailImage!,
      fullImage: _fullImage!,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Story added successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add story.')),
      );
    }
  }

  // Method to show the full image in a new screen
  void _showFullImage(File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullImageScreen(imageFile: imageFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField('Title', (value) {
                      title = value;
                      return null;
                    }),
                    SizedBox(height: 16),
                    _buildTextField('Description', (value) {
                      description = value;
                      return null;
                    }),
                    SizedBox(height: 16),
                    _buildImagePicker('Thumbnail Image', _thumbnailImage, true),
                    SizedBox(height: 16),
                    _buildImagePicker('Full Image', _fullImage, false),
                    SizedBox(height: 16),
                    _buildTextField('Link (optional)', (value) {
                      link = value;
                      return null;
                    }),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _addStatusUpdate(); // Call API on submit
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: Text('Submit Story'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to build text fields
  Widget _buildTextField(String label, String? Function(String?) validator) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildImagePicker(String label, File? imageFile, bool isThumbnail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (imageFile != null) {
              _showFullImage(imageFile); // Show full image on tap
            }
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    image: imageFile != null
                        ? DecorationImage(
                            image: FileImage(imageFile),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageFile == null
                      ? Center(
                          child: Text('No Image Selected',
                              textAlign: TextAlign.center))
                      : null,
                ),
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => _takeImage(isThumbnail),
                    color: Colors.orange,
                  ),
                  IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () => _pickImage(isThumbnail),
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// New screen for displaying full image
class FullImageScreen extends StatelessWidget {
  final File imageFile;

  FullImageScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Image'),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
