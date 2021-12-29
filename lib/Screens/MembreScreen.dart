// main.dart
import 'package:flutter/material.dart';
import 'package:projet/DatabaseHandler/MembreHelper.dart';
import 'package:projet/Model/Membre.dart';

import 'drawer.dart';

class MembreScreen extends StatefulWidget {
  const MembreScreen({Key? key}) : super(key: key);

  @override
  _MembreScreenState createState() => _MembreScreenState();
}

class _MembreScreenState extends State<MembreScreen> {
  // All membres
  List<Map<String, dynamic>> _membres = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshMembres() async {
    final data = await MEMBREHelper.getItems();
    setState(() {
      _membres = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    MEMBREHelper.db();
    _refreshMembres(); // Loading the diary when the app starts
  }

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tel1Controller = TextEditingController();
  final TextEditingController _tel2Controller = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingMembre =
          _membres.firstWhere((element) => element['id'] == id);
      _nomController.text = existingMembre['nom'];
      _emailController.text = existingMembre['email'];
      _tel1Controller.text = existingMembre['telephone_1'].toString();
      _tel2Controller.text = existingMembre['telephone_2'].toString();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _nomController,
                      decoration: const InputDecoration(hintText: 'Nom'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'email'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _tel1Controller,
                        decoration: const InputDecoration(
                            hintText: 'Numéro téléphone 1'),
                        keyboardType: TextInputType.number),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _tel2Controller,
                        decoration: const InputDecoration(
                            hintText: 'Numéro téléphone 2'),
                        keyboardType: TextInputType.number),
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
                          await _addMembre();
                        }

                        if (id != null) {
                          await _updateMembre(id);
                        }

                        // Clear the text fields
                        _nomController.text = '';
                        _emailController.text = '';
                        _tel1Controller.text = '';
                        _tel2Controller.text = '';

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

// Insert a new membre to the database
  Future<void> _addMembre() async {

    if(_tel2Controller.text != null){
      Membre mbr = Membre(_nomController.text, _emailController.text,
          int.parse(_tel1Controller.text),null);
      await MEMBREHelper.createMembre(mbr);
    }
    else{
      Membre mbr = Membre(_nomController.text, _emailController.text,
          int.parse(_tel1Controller.text), int.parse(_tel2Controller.text));
      await MEMBREHelper.createMembre(mbr);
    }

    _refreshMembres();
  }

  // Update an existing membre
  Future<void> _updateMembre(int id) async {
    if(_tel2Controller.text != null){
      Membre mbr = Membre(_nomController.text, _emailController.text,
          int.parse(_tel1Controller.text),null);
      await MEMBREHelper.updateMembre(id, mbr);
    }
    else{
      Membre mbr = Membre(_nomController.text, _emailController.text,
          int.parse(_tel1Controller.text), int.parse(_tel2Controller.text));
      await MEMBREHelper.updateMembre(id, mbr);
    }

    _refreshMembres();
  }

  // Delete a membre
  void _deleteMembre(int id) async {
    await MEMBREHelper.deleteMembre(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a member!'),
    ));
    _refreshMembres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Membres'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _membres.length,
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                color: Colors.grey[300],
                margin: const EdgeInsets.all(10),
                child: ListTile(
                    title: Text(_membres[index]['nom'] +
                        "\n" +
                        _membres[index]['email']),
                    subtitle: Text(" Premier numéro: " +
                        _membres[index]['telephone_1'].toString() +
                        "\n Deuxième numéro: " +
                        _membres[index]['telephone_2'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_membres[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteMembre(_membres[index]['id']),
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
