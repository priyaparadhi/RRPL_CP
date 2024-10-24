import 'package:flutter/material.dart';

class EnquiryDetailsPage extends StatefulWidget {
  @override
  _ViewEnquiryPageState createState() => _ViewEnquiryPageState();
}

class _ViewEnquiryPageState extends State<EnquiryDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("View Enquiry"),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // Bookmark functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue, // Profile avatar placeholder
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Anurag", // Name
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("ENQ961044"), // Enquiry ID
                    Text("Created on: 04 December 2021"), // Creation date
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildActionButton(Icons.phone, "Call"),
                buildActionButton(Icons.record_voice_over, "Call Recordings"),
                buildActionButton(Icons.phone_android, "WhatsApp"),
                buildActionButton(Icons.sms, "SMS"),
              ],
            ),
            SizedBox(height: 16),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.orange,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Member'),
                        Tab(text: 'Property Pistol'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          buildMemberDetails(),
                          Center(
                            child: Text('Property Pistol Content'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Icon(icon, size: 28, color: Colors.black),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget buildMemberDetails() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        buildDetailRow("Assigned to:", "Nitin Ingole"),
        buildDetailRow("Status:", "Dead"),
        buildDetailRow("Dead Reason:", "Others"),
        buildDetailRow("Dead Reason Comments:",
            "Dead Marked By System at 2022-03-11 13:48:22 +05:30"),
        buildDetailRow("Comment:", "verified lead"),
        buildDetailRow("Project:", "Shapoorji Bavdhan Pune"),
        SizedBox(height: 2),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
