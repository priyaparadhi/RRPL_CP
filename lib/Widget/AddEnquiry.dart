import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/models/ProjectModel.dart';

class AddEnquiry extends StatefulWidget {
  @override
  _EnquiryFormState createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<AddEnquiry> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String? selectedProject;
  List<Project> projects = [];
  bool isLoading = true; // Loading state
  String? clientName, clientPhone, emailAddress, enquiry;

  @override
  void initState() {
    super.initState();
    _fetchProjects(); // Fetch projects on init
  }

  // Fetch projects from the API
  Future<void> _fetchProjects() async {
    try {
      List<Project> fetchedProjects = await ApiCalls.fetchProjectsDropdown();
      setState(() {
        projects = fetchedProjects;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load projects')),
      );
    }
  }

  // Handle form submission
  // Handle form submission
  Future<void> _submitEnquiry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await ApiCalls.addProjectEnquiry(
          projectId: int.parse(selectedProject!),
          name: clientName!,
          mobileNo: clientPhone!,
          emailId: emailAddress!,
          enquiry: enquiry!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enquiry submitted successfully')),
        );

        // Clear the form fields
        _formKey.currentState!.reset();
        setState(() {
          selectedProject = null;
          clientName = null;
          clientPhone = null;
          emailAddress = null;
          enquiry = null;
        });

        // Optionally navigate back or perform other actions
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit enquiry')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Enquiry",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select a Project",
                        labelStyle:
                            GoogleFonts.poppins(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      items: projects.map((project) {
                        return DropdownMenuItem<String>(
                          value: project.projectId.toString(),
                          child: Text(
                            project.propertyName ?? 'null',
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProject = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a project' : null,
                    ),
              SizedBox(height: 16),
              // Client Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Client Name",
                  labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSaved: (value) => clientName = value,
                validator: (value) =>
                    value!.isEmpty ? 'Enter client name' : null,
              ),
              SizedBox(height: 16),
              // Client Phone Field
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Client Phone",
                  labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSaved: (value) => clientPhone = value,
                validator: (value) =>
                    value!.isEmpty ? 'Enter phone number' : null,
              ),
              SizedBox(height: 16),
              // Email Field
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSaved: (value) => emailAddress = value,
                validator: (value) =>
                    value!.isEmpty ? 'Enter email address' : null,
              ),
              SizedBox(height: 16),
              // Enquiry Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Enquiry",
                  labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 3,
                onSaved: (value) => enquiry = value,
                validator: (value) => value!.isEmpty ? 'Enter enquiry' : null,
              ),
              SizedBox(height: 16),
              // Submit Button
              ElevatedButton(
                onPressed: _submitEnquiry,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orangeAccent, // Text color
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
