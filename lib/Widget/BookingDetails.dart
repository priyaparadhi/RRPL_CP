import 'package:flutter/material.dart';
import 'package:rrpl_app/Widget/CommentLog.dart';

class BookingDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rajashri Dhiraj Makhamale",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Godrej Park Ridge Pune",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey[700]),
              SizedBox(height: 16),
              buildDoubleLabelRow("Unit", "Ag. Value"),
              buildDoubleValueRow("T3-2506", "₹ 63,64,197"),
              Divider(color: Colors.grey[700]),
              buildDoubleLabelRow("Revenue", "Released"),
              buildDoubleValueRow("₹ 1,27,283.94", "₹ 1,27,284"),
              Divider(color: Colors.grey[700]),
              buildDoubleLabelRow("Client Payment %", "Reg. Status"),
              buildDoubleValueRow("20.79", "Yes"),
              Divider(color: Colors.grey[700]),
              buildDoubleLabelRow("Booking Date", "Broker Side Referral Bonus"),
              buildDoubleValueRow("2021-04-21", "₹ 0"),
              Divider(color: Colors.grey[700]),
              buildDoubleLabelRow("PRPL Side Referral Bonus", ""),
              buildDoubleValueRow("₹ 0", ""),
              Divider(color: Colors.grey[700]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CommentLogPage()));
        },
        child: Icon(
          Icons.comment,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildDoubleLabelRow(String label1, String label2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            label2,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDoubleValueRow(String value1, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            value1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value2,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
