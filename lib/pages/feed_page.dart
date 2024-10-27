import 'package:flutter/material.dart';
import 'package:mad/services/firebase_services.dart';
import 'package:mad/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:mad/pages/searched_profile.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _searchController = TextEditingController();
  final UsersCollection _usersCollection = UsersCollection(); // Initialize UsersCollection
  List<Map<String, dynamic>> _searchResults = [];
  bool _showDropdown = false;

  // Method to handle user search
  Future<void> _searchUsers(String query) async {
  if (query.isEmpty) {
  setState(() {
  _searchResults.clear();
  _showDropdown = false;
  });
  return;
  }

  // Call the searchByUsername method from UsersCollection
  List<Map<String, dynamic>> results = await _usersCollection.searchByUsername(query);

  setState(() {
  _searchResults = results; // Store the results
  _showDropdown = _searchResults.isNotEmpty; // Show dropdown if there are results
  });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Drawer header color
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            SwitchListTile(
              title: const Text("Toggle Theme"),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              secondary: const Icon(Icons.brightness_6),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) => _searchUsers(query),
            ),
            // Dropdown for search results
            if (_showDropdown)
              Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling for dropdown
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user['profilePicture'] != null
                            ? NetworkImage(user['profilePicture'])
                            : const AssetImage('assets/avatar.png') as ImageProvider,
                      ),
                      title: Text(user['username']),
                      trailing: const Icon(Icons.arrow_forward), // Arrow icon
                      onTap: () {
                        if (user['id'] != null) { // Check if user ID is not null
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchedProfile(userId: user['id']), // Pass user ID
                            ),
                          );
                        } else {
                          // Handle the case where user ID is null
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User ID is not available')),
                          );
                        }

                      },
                    );
                  },
                ),
              ),
            // Center Message
            const Expanded(
              child: Center(
                child: Text(
                  "This is your feed page",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
