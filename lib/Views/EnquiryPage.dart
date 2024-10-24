import 'package:flutter/material.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/models/EnquiryModel.dart';
import 'package:rrpl_app/models/ProjectModel.dart';
import 'package:rrpl_app/Widget/AddEnquiry.dart';

class EnquiryPage extends StatefulWidget {
  @override
  _EnquiryPageState createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  List<Enquiry> enquiries = [];
  List<Enquiry> filteredEnquiries = [];
  bool isLoading = true; // Loading state
  String? errorMessage;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEnquiries();

    searchController.addListener(() {
      _filterEnquiries();
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Clean up the controller
    super.dispose();
  }

  Future<void> _fetchEnquiries() async {
    try {
      List<Enquiry> fetchedEnquiries = await ApiCalls.fetchProjectEnquiries();
      setState(() {
        enquiries = fetchedEnquiries;
        filteredEnquiries = enquiries;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load enquiries';
      });
    }
  }

  void _filterEnquiries() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEnquiries = enquiries.where((enquiry) {
        return enquiry.name.toLowerCase().contains(query) ||
            enquiry.email.toLowerCase().contains(query) ||
            enquiry.mobile.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enquiries',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name, email, or mobile',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredEnquiries.length,
                        itemBuilder: (context, index) {
                          final enquiry = filteredEnquiries[index];
                          return EnquiryCard(enquiry: enquiry);
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEnquiry()),
          ).then((_) {
            _fetchEnquiries();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}

class EnquiryCard extends StatelessWidget {
  final Enquiry enquiry;

  const EnquiryCard({Key? key, required this.enquiry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              enquiry.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              enquiry.projectName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${enquiry.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Mobile: ${enquiry.mobile}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Enquiry: ${enquiry.enquiry}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
