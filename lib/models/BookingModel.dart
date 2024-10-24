class Booking {
  final int bookingId;
  final String name;
  final String projectName;
  final String bookingDate;
  final String unit;
  final int isApproved;
  final String? revenue;

  Booking({
    required this.bookingId,
    required this.name,
    required this.projectName,
    required this.bookingDate,
    required this.unit,
    required this.isApproved,
    this.revenue,
  });

  // Factory constructor to create Booking object from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      name: json['name'],
      projectName: json['project_name'] ?? 'N/A',
      bookingDate: json['booking_date'],
      unit: json['unit'] ?? 'N/A', // Handle null values
      isApproved: json['is_approved'],
      revenue: json['revenue'] ?? 'N/A', // Handle null values
    );
  }
}
