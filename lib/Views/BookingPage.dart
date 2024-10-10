import 'package:flutter/material.dart';
import 'package:rrpl_app/Widget/BookingDetails.dart';

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            AppBar(
              title: Text("Booking "),
            ), // Tabs outside the AppBar
            TabBar(
              indicatorColor:
                  Colors.orange, // Indicator color for the active tab
              labelColor: Colors.black, // Text color for selected tab
              unselectedLabelColor:
                  Colors.grey, // Text color for unselected tabs
              tabs: [
                Tab(text: 'My Bookings'),
                Tab(text: 'Retain'),
                Tab(text: 'Cancelled'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab - My Bookings
                  _buildBookingsSection(),
                  // Second Tab - Retain (Placeholder for now)
                  Center(child: Text('Retain')),
                  // Third Tab - Cancelled (Placeholder for now)
                  Center(child: Text('Cancelled')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsSection() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search bookings',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),

        DefaultTabController(
          length: 2,
          child: TabBar(
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Approved'),
              Tab(text: 'Unapproved'),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildBookingCard(
                context: context,
                unit: 'T3-2506',
                date: '2021-04-21',
                revenue: '₹ 1,27,283.94',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard({
    required BuildContext context,
    required String unit,
    required String date,
    required String revenue,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsPage(),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rajashri Dhiraj Makham...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Godrej Park Ridge Pune',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Unit', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Booking Date',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Revenue',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(unit),
                  Text(date),
                  Text(revenue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
