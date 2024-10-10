import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'date': '16 February 2024',
      'message':
          '🚨BREAKING NEWS🚨 Most awaited plotted launch in the heart of India by Godrej at Nagpur is RERA APPROVED. Stay Tuned',
      'new': 'true',
    },
    {
      'date': '15 January 2024',
      'message':
          'Introducing New Slabs! Refer for Home Loans now and Unlock Thrilling Benefits. Don\'t Miss Out!',
      'new': 'true',
    },
    {
      'date': '17 June 2023',
      'message':
          'Earn BIG BIGGER BIGGEST !!! With the best Partner Incentive Plan in the market.',
      'new': 'true',
    },
    {
      'date': '24 April 2023',
      'message':
          'Partner Incentive Scheme for FY 23–24 is now live. Check out the latest incentive structure.',
      'new': 'true',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Showing ${notifications.length} out of ${notifications.length} notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notification['date']!,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            if (notification['new'] == 'true')
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'New',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            notification['message']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
