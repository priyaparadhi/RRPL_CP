import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/models/ProjectModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBookingPage extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<AddBookingPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String? selectedProject;
  List<Project> projects = [];
  bool isLoading = true;
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientPhoneController = TextEditingController();
  final TextEditingController clientEmailController = TextEditingController();
  bool isSubmitting = false;

  // Fetch projects from the API
  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

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

  // Submit booking
  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      // Assuming you are storing user ID in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId =
          prefs.getInt('user_id') ?? 1; // Default user_id is 1 if not stored

      bool isSuccess = await ApiCalls.addBooking(
        userId: userId,
        projectId: int.parse(selectedProject!),
        name: clientNameController.text,
        mobileNo: clientPhoneController.text,
        emailId: clientEmailController.text,
      );

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking submitted successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit booking')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Booking",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 600), // Set maximum width for the form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add Booking Title
                Text(
                  "Add Booking",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center, // Center the title
                ),
                SizedBox(height: 24), // Add some space below the title

                // Form starts here
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Select a Project",
                                labelStyle: GoogleFonts.poppins(
                                    color: Colors.grey[600]),
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
                              validator: (value) => value == null
                                  ? 'Please select a project'
                                  : null,
                            ),
                      SizedBox(height: 16),
                      // Client Name Field
                      TextFormField(
                        controller: clientNameController,
                        decoration: InputDecoration(
                          labelText: "Client Name",
                          labelStyle:
                              GoogleFonts.poppins(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter client name' : null,
                      ),
                      SizedBox(height: 16),
                      // Client Phone Field
                      TextFormField(
                        controller: clientPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Client Phone",
                          labelStyle:
                              GoogleFonts.poppins(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter phone number' : null,
                      ),
                      SizedBox(height: 16),
                      // Email Field
                      TextFormField(
                        controller: clientEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle:
                              GoogleFonts.poppins(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter email address' : null,
                      ),
                      SizedBox(height: 16),
                      // Submit Button
                      ElevatedButton(
                        onPressed: isSubmitting ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orangeAccent, // Text color
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: isSubmitting
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Submit",
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
