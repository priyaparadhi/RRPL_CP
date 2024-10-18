class Enquiry {
  final String name;
  final String email;
  final String mobile;
  final String enquiry;

  Enquiry({
    required this.name,
    required this.email,
    required this.mobile,
    required this.enquiry,
  });

  // From JSON constructor
  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      name: json['name'] ?? 'Unknown',
      email: json['email_id'] ?? 'No email',
      mobile: json['mobile_no'].toString(),
      enquiry: json['enquiry'] ?? 'No enquiry',
    );
  }
}
