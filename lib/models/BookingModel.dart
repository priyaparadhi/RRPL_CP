class Booking {
  final int userId;
  final int bookingId;
  final int projectId;
  final String bookingDate;
  final String name;
  final String mobile;
  final String email;

  Booking({
    required this.userId,
    required this.bookingId,
    required this.projectId,
    required this.bookingDate,
    required this.name,
    required this.mobile,
    required this.email,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      userId: json['user_id'],
      bookingId: json['booking_id'],
      projectId: json['project_id'],
      bookingDate: json['booking_date'],
      name: json['name'],
      mobile: json['mobile_no'].toString(),
      email: json['email_id'],
    );
  }
}
