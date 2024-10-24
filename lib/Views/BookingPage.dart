import 'package:flutter/material.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/Widget/AddBooking.dart';
import 'package:rrpl_app/Widget/BookingDetails.dart';
import 'package:rrpl_app/models/BookingModel.dart';
import 'Booking.dart'; // Assuming you have a separate file for the Booking model

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Future<List<Booking>> futureBookings;
  TextEditingController searchController = TextEditingController();
  List<Booking> approvedBookings = [];
  List<Booking> unapprovedBookings = [];
  List<Booking> filteredApprovedBookings = [];
  List<Booking> filteredUnapprovedBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  // Fetch bookings and store in state variables
  void _fetchBookings() async {
    try {
      List<Booking> bookings = await ApiCalls.fetchBookings();
      setState(() {
        approvedBookings = bookings.where((b) => b.isApproved == 1).toList();
        unapprovedBookings = bookings.where((b) => b.isApproved == 0).toList();
        filteredApprovedBookings = approvedBookings;
        filteredUnapprovedBookings = unapprovedBookings;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error if needed
    }
  }

  // Filter bookings based on search query
  void _filterBookings(String query) {
    setState(() {
      filteredApprovedBookings = approvedBookings
          .where((booking) =>
              booking.name.toLowerCase().contains(query.toLowerCase()) ||
              booking.projectName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredUnapprovedBookings = unapprovedBookings
          .where((booking) =>
              booking.name.toLowerCase().contains(query.toLowerCase()) ||
              booking.projectName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of main tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Booking"),
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'My Bookings'),
                Tab(text: 'Retain'),
                Tab(text: 'Cancelled'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBookingsSection(),
                  Center(child: Text('Retain')),
                  Center(child: Text('Cancelled')),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBookingPage()),
            ).then((_) {
              _fetchBookings();
            });
          },
        ),
      ),
    );
  }

  Widget _buildBookingsSection() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: _filterBookings,
            decoration: InputDecoration(
              hintText: 'Search bookings...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.orange,
                  tabs: [
                    Tab(text: 'Approved'),
                    Tab(text: 'Unapproved'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildBookingList(filteredApprovedBookings),
                      _buildBookingList(filteredUnapprovedBookings),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(child: Text('No bookings available.'));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(
          context: context,
          booking: bookings[index],
        );
      },
    );
  }

  Widget _buildBookingCard({
    required BuildContext context,
    required Booking booking,
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
                booking.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                booking.projectName,
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
                  Text(booking.unit),
                  Text(booking.bookingDate),
                  Text(booking.revenue ?? 'N/A'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
