import 'package:flutter/material.dart';
import 'package:mad/auth/login.dart';
import 'package:mad/pages/searched_profile.dart';
import 'package:mad/services/auth_service.dart';
import 'package:mad/services/users_collection.dart';
import 'package:mad/themes/custom_scaffold.dart';
import 'package:mad/themes/custom_scaffold.dart';
import 'package:mad/themes/theme_provider.dart';
import 'package:mad/pages/notifications_page.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _searchController = TextEditingController();
  final UsersCollection _usersCollection = UsersCollection();
  List<Map<String, dynamic>> _searchResults = [];
  bool _showDropdown = false;
  final AuthService _authService = AuthService();

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _showDropdown = false;
      });
      return;
    }

    print("Searching for users with query: $query");
    List<Map<String, dynamic>> results =
    await _usersCollection.searchByUsername(query);
    print("Search results: $results");

    setState(() {
      _searchResults = results;
      _showDropdown = _searchResults.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary, // Set the background color of the Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary, // This can be kept as is or changed
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            SwitchListTile(
              title: const Text("Toggle Theme"),
              value: Theme
                  .of(context)
                  .brightness == Brightness.dark,
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              secondary: const Icon(Icons.brightness_6),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await _authService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user['profilePicture'] != null
                            ? NetworkImage(user['profilePicture'])
                            : const AssetImage(
                          'assets/avatar.png',
                        ) as ImageProvider,
                      ),
                      title: Text(user['username']),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        if (user['id'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchedProfile(userId: user['id']),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User ID is not available'),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
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