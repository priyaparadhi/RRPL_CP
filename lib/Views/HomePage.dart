import 'package:flutter/material.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/Views/BookingPage.dart';
import 'package:rrpl_app/Views/CrmPage.dart';
import 'package:rrpl_app/Views/EventPage.dart';
import 'package:rrpl_app/Views/Notification.dart';
import 'package:rrpl_app/Views/PassbookPage.dart';
import 'package:rrpl_app/Views/ProjectPage.dart';
import 'package:rrpl_app/Widget/AddStory.dart';
import 'package:rrpl_app/Widget/Filters.dart';
import 'package:rrpl_app/Widget/ProjectDetails.dart';
import 'package:rrpl_app/Widget/StoryView.dart';
import 'package:rrpl_app/models/ProjectModel.dart';
import 'package:rrpl_app/models/StoryModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Index for the selected tab

  // Define the list of pages
  final List<Widget> _pages = [
    Dashboard(),
    CRMPage(),
    ProjectsPage(),
    PassbookPage(),
    BookingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page based on index
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.orange,
        currentIndex: _currentIndex, // Highlight the selected item
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined), label: 'CRM'),
          BottomNavigationBarItem(
              icon: Icon(Icons.apartment), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Passbook'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booking'),
        ],
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<StatusUpdate> statusUpdates = [];
  bool isLoading = true;
  List<bool> isStoryViewed = [];
  List<Project> _projects = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadProjects();
    _fetchStatusUpdates();
  }

  Future<void> _loadProjects() async {
    try {
      List<Project> projects = await ApiCalls.fetchProjects();
      setState(() {
        _projects = projects;
        _isLoading = false; // Stop loading once data is fetched
      });
    } catch (e) {
      // Handle errors here (e.g., show a message)
      print('Error fetching projects: $e');
    }
  }

  void _fetchStatusUpdates() async {
    try {
      final updates = await ApiCalls.fetchStatusUpdates();
      setState(() {
        statusUpdates = updates;
        isLoading = false;
        isStoryViewed = List.filled(updates.length, false);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load status updates')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Dashboard', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.black, // Change icon color if needed
            onPressed: () {
              //Navigate to the Notification Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 179, 64),
              ),
              child: Text(
                'Welcome to RRPL Channel Partner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Event'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Filters'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.library_books_outlined),
              title: Text('CRM'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CRMPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.apartment),
              title: Text('Projects'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.wallet),
              title: Text('Passbook'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PassbookPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Booking'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Hello, Priya Paradhi',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator()) // Show loader while fetching data
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            List.generate(statusUpdates.length + 1, (index) {
                          if (index == 0) {
                            return _buildAddStoryCard(context);
                          }

                          final statusUpdate = statusUpdates[index - 1];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                final statusDetails =
                                    await ApiCalls.fetchSingleStatus(
                                        statusUpdate.statusUpdateId ?? 0);

                                if (statusDetails != null) {
                                  // Construct the full image URL
                                  final fullImagePath =
                                      'https://rrpl-dev.portalwiz.in/api/storage/app/${statusDetails["status_full_img"]}';
                                  print(
                                      'Image Path: $fullImagePath'); // Print the image path for debugging

                                  // Check if the path is valid
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoryView(
                                        stories: [
                                          fullImagePath,
                                        ],
                                        onStoryViewed: () {
                                          setState(() {
                                            isStoryViewed[index - 1] = true;
                                          });
                                        },
                                        swipeUpLink:
                                            statusDetails["link"] ?? '',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to load status details')),
                                  );
                                }
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: isStoryViewed[index - 1]
                                              ? LinearGradient(
                                                  colors: [
                                                    Colors.grey,
                                                    Colors.grey.shade400
                                                  ],
                                                )
                                              : LinearGradient(
                                                  colors: [
                                                    Colors.orange,
                                                    Colors.yellow,
                                                  ],
                                                ),
                                        ),
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: statusUpdate
                                                          .statusThumbnailImg !=
                                                      null
                                                  ? NetworkImage(
                                                      'https://rrpl-dev.portalwiz.in/api/storage/app/${statusUpdate.statusThumbnailImg}')
                                                  : AssetImage(
                                                          'assets/images/image.png')
                                                      as ImageProvider, // Fallback to a default image
                                              backgroundColor: Colors.grey[300],
                                            )),
                                      ),
                                      if (!isStoryViewed[index - 1])
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'New',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 80,
                                    child: Text(
                                      statusUpdate.title ?? '',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Bookings Card
                  Expanded(
                    child: Card(
                      color: Colors.orange,
                      child: Container(
                        constraints: BoxConstraints(minHeight: 150), // Set size
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('5',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text('Bookings till date',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              TextButton(
                                onPressed: () {
                                  //Navigate to the filter page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PassbookPage()),
                                  );
                                },
                                child: Text('View Passbook',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  // Earnings Card
                  Expanded(
                    child: Card(
                      color: Colors.blueGrey,
                      child: Container(
                        constraints: BoxConstraints(minHeight: 150), // Set size
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.attach_money, color: Colors.white),
                              Text('₹0',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text('Earned till date',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              TextButton(
                                onPressed: () {},
                                child: Text('View Earnings',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Explore Matches and Projects section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Explore Matches
                  Card(
                    color: Color.fromARGB(255, 109, 174, 227),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Explore Matches',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Projects Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Projects',
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      TextButton(
                        onPressed: () {
                          // Navigate to the ProjectsPage and refresh the dashboard when returning
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectsPage(),
                            ),
                          ).then((_) {
                            _loadProjects(); // Refresh the dashboard when coming back
                          });
                        },
                        child: Text('View All',
                            style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),

                  // Projects List
                  _isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator()) // Show loading indicator while fetching data
                      : Container(
                          height: 300,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _projects.map((project) {
                              return _buildProjectCard(context, project);
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddStoryCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          // Make the onTap handler async
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStoryForm(),
            ),
          );

          // Check if the result is true (story added successfully)
          if (result == true) {
            _fetchStatusUpdates(); // Refresh the status updates
          }
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.yellow],
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              width: 80,
              child: Text(
                'Add Story',
                style: TextStyle(color: Colors.black, fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    // Construct the full image URL using the provided storage base URL
    String imageUrl =
        'https://rrpl-dev.portalwiz.in/api/storage/app/${project.projectThumbnailImg}';

    return GestureDetector(
      onTap: () {
        // Navigate to the ProjectDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetails(project: project),
          ),
        ).then((_) {
          // Refresh the dashboard after returning from ProjectDetails page
          _loadProjects();
        });
      },
      child: Card(
        color: Colors.white,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 180,
                width: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey,
                    child: Center(
                        child:
                            Icon(Icons.error, color: Colors.red)), // Error icon
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                project.propertyName ?? 'Project Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                project.description ?? 'Description not available',
                style: TextStyle(color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
