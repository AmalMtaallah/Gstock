// main.dart
import 'package:flutter/material.dart';
import 'package:projet/DatabaseHandler/CategoryHelper.dart';
import 'package:projet/Model/Categorie.dart';

import 'drawer.dart';

class CategorieScreen extends StatefulWidget {
  const CategorieScreen({Key? key}) : super(key: key);

  @override
  _CategorieScreenState createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> {
  // All membres
  List<Map<String, dynamic>> _categories = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshCategories() async {
    final data = await CATEGORYHelper.getAll();
    setState(() {
      _categories = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    CATEGORYHelper.db();
    _refreshCategories(); // Loading the diary when the app starts
  }

  final TextEditingController _categorieController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingMembre =
          _categories.firstWhere((element) => element['id'] == id);
      _categorieController.text = existingMembre['categorie'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 170,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _categorieController,
                      decoration: const InputDecoration(hintText: 'Categorie'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ))),
                      onPressed: () async {
                        // Save new membre
                        if (id == null) {
                          await _add();
                        }

                        if (id != null) {
                          await _update(id);
                        }

                        // Clear the text fields
                        _categorieController.text = '';

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    )
                  ],
                ),
              ),
            ));
  }

// Insert a new Categorie to the database
  Future<void> _add() async {
    Categorie cat = Categorie(_categorieController.text);
    await CATEGORYHelper.create(cat);
    _refreshCategories();
  }

  // Update an existing Categorie
  Future<void> _update(int id) async {
    Categorie cat = Categorie(_categorieController.text);
    await CATEGORYHelper.update(id, cat);
    _refreshCategories();
  }

  // Delete a Categorie
  void _delete(int id) async {
    await CATEGORYHelper.delete(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted !'),
    ));
    _refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                color: Colors.grey[300],
                margin: const EdgeInsets.all(10),
                child: ListTile(
                    title: Text(_categories[index]['categorie']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showForm(_categories[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _delete(_categories[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
