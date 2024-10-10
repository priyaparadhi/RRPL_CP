import 'package:flutter/material.dart';
import 'package:rrpl_app/ApiCalls/ApiCalls.dart';
import 'package:rrpl_app/Views/AddProject.dart';
import 'package:rrpl_app/Widget/FilterProject.dart';
import 'package:rrpl_app/Widget/ProjectDetails.dart';
import 'package:rrpl_app/models/ProjectModel.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<dynamic> featuredProjects = [];
  List<dynamic> allProjects = [];
  bool isLoadingFeatured = true;
  bool isLoadingAll = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    try {
      // Fetch all projects at once
      final allProjectsData = await ApiCalls.fetchProject();

      setState(() {
        // Separate featured and non-featured projects
        featuredProjects = allProjectsData
            .where((project) => project['is_featured'] == 1)
            .toList();

        // Filter non-featured projects
        allProjects = allProjectsData
            .where((project) => project['is_featured'] != 1)
            .toList();

        isLoadingFeatured = false;
        isLoadingAll = false;
      });
    } catch (error) {
      // Handle error
      print('Error fetching projects: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Projects',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          bottom: TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Featured Projects'),
              Tab(text: 'All Projects'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Featured Projects Tab
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoadingFeatured
                  ? Center(child: CircularProgressIndicator())
                  : _buildProjectsList(featuredProjects),
            ),
            // All Projects Tab
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoadingAll
                  ? Center(child: CircularProgressIndicator())
                  : _buildProjectsList(allProjects),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProject()),
            );
          },
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
          tooltip: 'Add Project or Filter Projects',
        ),
      ),
    );
  }

  // Build Project List based on whether it's for Featured or All Projects
  Widget _buildProjectsList(List<dynamic> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar with Filter Icon
        Row(
          children: [
            // Search Bar
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search a project',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        // Handle search
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Filter Icon outside the container
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {
                //Navigate to the filter page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterProjectPage()),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),

        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Bangalore', true),
              _buildFilterChip('Delhi', false),
              _buildFilterChip('Nagpur', false),
              _buildFilterChip('Dubai', false),
              _buildFilterChip('PUNE', false),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Showing ${projects.length} project${projects.length > 1 ? 's' : ''}',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return _buildProjectCard(context, projects[index]);
            },
          ),
        ),
      ],
    );
  }

  // Filter Chip Widget
  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
        backgroundColor: Colors.grey[300],
        selectedColor: Colors.orange,
        selected: isSelected,
        onSelected: (bool value) {
          // Handle chip selection
        },
      ),
    );
  }

  Widget _buildProjectCard(
      BuildContext context, Map<String, dynamic> projectData) {
    // Convert the Map into a Project object
    Project project = Project.fromJson(projectData);

    String imageUrl = project.projectThumbnailImg!.isNotEmpty
        ? 'https://rrpl-dev.portalwiz.in/api/storage/app/${project.projectThumbnailImg}'
        : 'fallback_image_url';

    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetails(project: project),
                ),
              );
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.propertyName ?? 'property name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  project.address ?? 'address',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  project.pricingDesc ?? 'price',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
