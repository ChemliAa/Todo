import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project/services/CategoryDAO.dart';

import '../Categories.dart';
import '../Home.dart';
import '../todoCategory.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  final CategoryService _cs = CategoryService();
  final List<Widget> _categoryList = [];

  @override
  void initState() {
    super.initState();
    _getAllCategories();
  }

  _getAllCategories() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String id = user.uid;
      var categories = await _cs.readCategoriesByUserId(id);
      setState(() {
        _categoryList.clear(); // Clear existing category list
        for (var c in categories) {
          _categoryList.add(
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => todoCategory(category: c.name)),
              ),
              child: ListTile(
                title: Text(
                  c.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
                ),
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userName = user?.displayName;
    final String? userEmail = user?.email;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  userName ?? 'Unknown',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 4),
                Text(
                  userEmail ?? 'Unknown',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Homepage())),
          ),
          ListTile(
            leading: const Icon(Icons.view_list),
            title: const Text('Categories'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Categories())),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Your Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: _categoryList.isEmpty
                ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ]
                : _categoryList,
          ),
        ],
      ),
    );
  }
}
