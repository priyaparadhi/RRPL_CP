import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Events"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab bar
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
              ],
            ),
            SizedBox(height: 16),
            // Search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by event',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Text(
              'Showing 2 out of 2 Entries',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildEventList(),
                  buildEventList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventList() {
    return ListView(
      children: [
        buildEventCard(
          context,
          'assets/images/events.jpg',
          'RRPL - Pune',
          'Aug. 08 / Thursday, 2:00 PM',
          'Aug. 08 / Thursday, 3:00 PM',
          'Past',
        ),
      ],
    );
  }

  Widget buildEventCard(
    BuildContext context,
    String imagePath,
    String title,
    String startDateTime,
    String endDateTime,
    String status,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.black, size: 16),
                    SizedBox(width: 4),
                    Text(
                      startDateTime,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.black, size: 16),
                    SizedBox(width: 4),
                    Text(
                      endDateTime,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
