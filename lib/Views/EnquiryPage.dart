import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool isLoading = true; // Loading state
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEnquiries(); // Fetch enquiries when the page is initialized
  }

  // Fetch enquiries from the API
  Future<void> _fetchEnquiries() async {
    try {
      List<Enquiry> fetchedEnquiries = await ApiCalls.fetchProjectEnquiries();
      setState(() {
        enquiries = fetchedEnquiries;
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load enquiries'; // Handle error state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enquiries',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Show error message
              : ListView.builder(
                  itemCount: enquiries.length,
                  itemBuilder: (context, index) {
                    final enquiry = enquiries[index];
                    return EnquiryCard(enquiry: enquiry);
                  },
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
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${enquiry.email}',
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 4),
            Text(
              'Mobile: ${enquiry.mobile}',
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 8),
            Text(
              'Enquiry: ${enquiry.enquiry}',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ),
    );
  }
}
