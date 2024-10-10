import 'package:flutter/material.dart';
import 'package:rrpl_app/Widget/CityFilterPage.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double minPrice = 100;
  double maxPrice = 1000;
  int _selectedIndex = 0; // Index to track selected filter section

  // List of pages to switch between based on sidebar selection
  final List<Widget> _filterPages = [
    PriceFilterPage(),
    Cityfilterpage(),
    RegionFilterPage(),
    LocationFilterPage(),
    ConfigurationFilterPage(),
    PossessionFilterPage(),
    TagsFilterPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          TextButton(
            onPressed: () {
              // Clear all selected filters
              setState(() {
                minPrice = 100;
                maxPrice = 1000;
              });
            },
            child: Text('Clear All', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar with categories
          Container(
            width: 150,
            color: Colors.grey[200],
            child: ListView(
              children: [
                _buildSidebarItem('Price', 0),
                _buildSidebarItem('City', 1),
                _buildSidebarItem('Region', 2),
                _buildSidebarItem('Location', 3),
                _buildSidebarItem('Configuration', 4),
                _buildSidebarItem('Possession', 5),
                _buildSidebarItem('Tags', 6),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: _filterPages[
                _selectedIndex], // Display content based on selection
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                // Close filter page
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              ),
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply selected filters
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              ),
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(String title, int index) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.orange : Colors.black,
          fontWeight:
              _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        // Change the selected filter section
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}

// Price Filter Page
class PriceFilterPage extends StatefulWidget {
  @override
  _PriceFilterPageState createState() => _PriceFilterPageState();
}

class _PriceFilterPageState extends State<PriceFilterPage> {
  double minPrice = 100;
  double maxPrice = 1000;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Minimum', style: TextStyle(color: Colors.black)),
          Slider(
            value: minPrice,
            min: 100,
            max: 1000,
            divisions: 9,
            activeColor: Colors.orange,
            inactiveColor: Colors.grey,
            label: minPrice.round().toString(),
            onChanged: (double value) {
              setState(() {
                minPrice = value;
              });
            },
          ),
          Text(minPrice.round().toString(),
              style: TextStyle(color: Colors.black)),
          SizedBox(height: 20),
          Text('Maximum', style: TextStyle(color: Colors.black)),
          Slider(
            value: maxPrice,
            min: 100,
            max: 1000,
            divisions: 9,
            activeColor: Colors.orange,
            inactiveColor: Colors.grey,
            label: maxPrice.round().toString(),
            onChanged: (double value) {
              setState(() {
                maxPrice = value;
              });
            },
          ),
          Text(maxPrice.round().toString(),
              style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}

class RegionFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Region filter options will go here.'));
  }
}

class LocationFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Location filter options will go here.'));
  }
}

class ConfigurationFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Configuration filter options will go here.'));
  }
}

class PossessionFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Possession filter options will go here.'));
  }
}

class TagsFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tags filter options will go here.'));
  }
}
