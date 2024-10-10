import 'package:flutter/material.dart';

class Cityfilterpage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<Cityfilterpage> {
  List<String> cities = [
    'Banglore',
    'Pune',
    'Mumbai',
    'Nagpur',
  ];

  Map<String, bool> selectedCities = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected projects map
    cities.forEach((project) {
      selectedCities[project] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Cities',
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
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      String project = cities[index];
                      return CheckboxListTile(
                        title: Text(project,
                            style: TextStyle(color: Colors.black)),
                        value: selectedCities[project],
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() {
                            selectedCities[project] = value!;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
