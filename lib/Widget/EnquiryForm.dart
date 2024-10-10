import 'package:flutter/material.dart';

class EnquiryForm extends StatefulWidget {
  @override
  _EnquiryFormState createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<EnquiryForm> {
  bool referForLoan = false;
  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Enquiry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select a Project",
                border: OutlineInputBorder(),
              ),
              items: ['Project A', 'Project B', 'Project C']
                  .map((project) => DropdownMenuItem<String>(
                        value: project,
                        child: Text(project),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Client Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Client Phone",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Source",
                border: OutlineInputBorder(),
              ),
              items: ['Referral', 'Social Media', 'Other']
                  .map((source) => DropdownMenuItem<String>(
                        value: source,
                        child: Text(source),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Comment",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text("Refer For Loan"),
              value: referForLoan,
              onChanged: (value) {
                setState(() {
                  referForLoan = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: RichText(
                text: TextSpan(
                  text: "I accept the ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Terms and Conditions",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              value: acceptTerms,
              onChanged: (value) {
                setState(() {
                  acceptTerms = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white),
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
