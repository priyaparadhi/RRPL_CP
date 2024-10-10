import 'package:flutter/material.dart';
import 'package:rrpl_app/Widget/EnquiryDetails.dart';
import 'package:rrpl_app/Widget/EnquiryForm.dart';

class CRMPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRM"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search enquiries',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Wrap the Row of filter buttons in SingleChildScrollView
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildFilterButton('Site Visit 3'),
                  SizedBox(width: 8),
                  buildFilterButton('Qualified 14'),
                  SizedBox(width: 8),
                  buildFilterButton('Pro Enquiries'),
                  // You can add more buttons here if needed
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Showing 30 out of 98 enquiries',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildEnquiryCard(
                    context,
                    'Anurag',
                    'Shapoorji Bavdhan Pune',
                    'Nitin Ingole',
                    'Dead',
                    'Dead',
                    '04 December 2021',
                  ),
                  buildEnquiryCard(
                    context,
                    'Prashant S Kadam',
                    'Shapoorji Bavdhan Pune',
                    'Nitin Ingole',
                    'Dead',
                    'Dead',
                    '14 October 2021',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EnquiryForm()));
        },
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildFilterButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.orange),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget buildEnquiryCard(
    BuildContext context,
    String name,
    String location,
    String assignedTo,
    String myStatus,
    String ppStatus,
    String postedOn,
  ) {
    return InkWell(
      // Wrap the card with InkWell to detect taps
      onTap: () {
        // Navigate to the enquiry details page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnquiryDetailsPage(),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 114, 105),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      myStatus,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Location
              Text(
                location,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Details row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildDetailRow('Assigned', assignedTo),
                  buildDetailRow('My Status', myStatus),
                  buildDetailRow('PP Status', ppStatus),
                ],
              ),
              SizedBox(height: 8),
              // Posted on
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[700], size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Posted on: $postedOn',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }
}
