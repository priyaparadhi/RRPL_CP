import 'package:flutter/material.dart';

class BookingSummaryPage extends StatefulWidget {
  @override
  _BookingSummaryPageState createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  final List<Map<String, dynamic>> bookings = [
    {
      'bookingID': 'BK001',
      'projectName': 'Project A',
      'bookingDate': 'Oct 15, 2023',
      'bookingAmount': 150000,
      'estimatedCommission': 5000,
      'projectedCommission': 8000,
      'status': 'Confirmed',
      'progress': 0.7,
    },
    {
      'bookingID': 'BK002',
      'projectName': 'Project B',
      'bookingDate': 'Oct 18, 2023',
      'bookingAmount': 200000,
      'estimatedCommission': 6000,
      'projectedCommission': 10000,
      'status': 'Pending',
      'progress': 0.4,
    }
  ];

  int numberOfBookings = 0;
  double projectedCommission = 0.0;

  @override
  void initState() {
    super.initState();
    projectedCommission =
        bookings[0]['projectedCommission'].toDouble(); // Default
  }

  void _calculateProjectedCommission(int bookings) {
    // Example Slab structure: Increase based on number of bookings
    if (bookings < 5) {
      projectedCommission = 8000;
    } else if (bookings < 10) {
      projectedCommission = 10000;
    } else if (bookings < 20) {
      projectedCommission = 15000;
    } else {
      projectedCommission = 20000;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Summary',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: bookings.length,
          padding: EdgeInsets.symmetric(vertical: 20),
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _buildBookingCard(booking);
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['projectName'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildStatusBadge(booking['status']),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Booking ID: ${booking['bookingID']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Amount: ₹${booking['bookingAmount']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.grey[400]),
              ],
            ),
            SizedBox(height: 16),
            _buildCommissionSection(
              booking['estimatedCommission'],
              projectedCommission.toInt(), // Update projected commission
            ),
            SizedBox(height: 16),
            _buildProgressIndicator(booking['progress']),
            SizedBox(height: 16),
            _buildBookingInput(), // Add input for number of bookings
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Number of Bookings:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Number of Bookings',
          ),
          onChanged: (value) {
            final int input = int.tryParse(value) ?? 0;
            _calculateProjectedCommission(input);
          },
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    if (status == 'Confirmed') {
      statusColor = Colors.green;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCommissionSection(int estimated, int projected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              'Estimated Commission:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Text(
              '₹$estimated',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Text(
              'Projected Commission:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Text(
              '₹$projected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.grey[300],
          height: 24,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress to next milestone',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
            minHeight: 8,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${(progress * 100).toInt()}% towards higher commission',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
