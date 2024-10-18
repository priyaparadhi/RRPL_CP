import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/models/BookingModel.dart';
import 'package:rrpl_app/Widget/AddBooking.dart';

class BookingDetails extends StatefulWidget {
  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late Future<List<Booking>> _bookingListFuture;

  @override
  void initState() {
    super.initState();
    // Fetch bookings from API when the screen is initialized
    _bookingListFuture = ApiCalls.fetchBookings();
  }

  // Method to refresh bookings list
  void _refreshBookings() {
    setState(() {
      _bookingListFuture = ApiCalls.fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Details',
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error
            return Center(child: Text('Failed to load bookings'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle empty data
            return Center(child: Text('No bookings available'));
          } else {
            // Data is available, build the list
            List<Booking> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(booking: booking);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookingPage()),
          ).then((_) {
            // Refresh the booking list when navigating back
            _refreshBookings();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
        tooltip: 'Add New Booking',
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Date: ${booking.bookingDate}',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Name: ${booking.name}',
              style: GoogleFonts.lato(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Mobile: ${booking.mobile}',
              style: GoogleFonts.lato(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Email: ${booking.email}',
              style: GoogleFonts.lato(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
