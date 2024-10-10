import 'package:flutter/material.dart';

class FilterProjectPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterProjectPage> {
  List<String> projects = [
    'Lodha Supremo Mira Road',
    'Other',
    'Piramal Mahalaxmi - Mahalaxmi East',
    'Mahindra Kalyan',
    'Birla Alokya Bangalore',
    'Godrej RK Studio',
    'Piramal Vaikunth Thane',
    'Mahindra Happinest KALYAN',
    'Godrej Mahalunge',
    'Godrej Upavan Thane Extension',
    'Shapoorji Bavdhan Pune',
  ];

  Map<String, bool> selectedProjects = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected projects map
    projects.forEach((project) {
      selectedProjects[project] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedProjects.updateAll((key, value) => false);
              });
            },
            child: Text('Clear All', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 120,
            color: Colors.grey[200],
            child: ListView(
              children: [
                _buildSidebarItem('Projects', selected: true),
                _buildSidebarItem('My Status'),
                _buildSidebarItem('PP Status'),
                _buildSidebarItem('Budget'),
                _buildSidebarItem('Lead Source'),
                _buildSidebarItem('Dead Reason'),
                _buildSidebarItem('Visited'),
                _buildSidebarItem('Date Filter'),
                _buildSidebarItem('NCD'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search a project',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.orange),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      String project = projects[index];
                      return CheckboxListTile(
                        title: Text(project,
                            style: TextStyle(color: Colors.black)),
                        value: selectedProjects[project],
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() {
                            selectedProjects[project] = value!;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                        ),
                        child: Text('Close'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 10),
                        ),
                        child: Text('Apply Filters'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, {bool selected = false}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.orange : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {},
    );
  }
}
