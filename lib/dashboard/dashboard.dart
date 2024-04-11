import 'package:ap4_projet/dashboard/addproduct.dart';
import 'package:ap4_projet/dashboard/adduser.dart';
import 'package:ap4_projet/dashboard/information_product.dart';
import 'package:ap4_projet/server/api.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const DashboardPage({Key? key, required this.userData}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _futureUsers;
  late Future<List<dynamic>> _futureItems;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _futureUsers = fetchUsers();
    _futureItems = fetchItems();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Utilisateurs'),
            Tab(text: 'Produits'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<dynamic>>(
            future: _futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var user = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        title: Text('${user['firstname'] ?? ''} "${user['username']}" ${user['lastname'] ?? ''}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.email, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(user['email']),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.language, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(user['country']),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.lock, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  user['perm_level'] == 0 ? 'Utilisateur' : user['perm_level'] == 1 ? 'Staff' : 'Administrateur', 
                                  style: TextStyle(color: user['perm_level'] == 0 ? Colors.green : user['perm_level'] == 1 ? Colors.orange : Colors.red)
                                  ),
                              ],
                            ),
                          ]
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                String? selectedField;
                                TextEditingController newValueController = TextEditingController();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Modifier l\'utilisateur "${user['username']}"'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField(
                                            value: selectedField,
                                            hint: const Text('Choisir le champ à modifier'),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'firstname',
                                                child: Text('Prénom'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'lastname',
                                                child: Text('Nom de famille'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'username',
                                                child: Text('Pseudo'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'email',
                                                child: Text('Email'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'country',
                                                child: Text('Pays'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'perm_level',
                                                child: Text('Permission'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              selectedField = value.toString();
                                            },
                                          ),
                                          TextField(
                                            controller: newValueController,
                                            decoration: const InputDecoration(
                                              labelText: 'Nouvelle valeur',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (selectedField == null || selectedField!.isEmpty || newValueController.text.isEmpty) {
                                              // Afficher une erreur si aucun champ ou aucune valeur n'est sélectionné
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Veuillez choisir un champ et saisir une valeur')),
                                              );
                                              return;
                                            }
                                            // Envoie de la requête de mise à jour
                                            updateUser(user['id'], {
                                              'field': selectedField!,
                                              'value': newValueController.text,
                                            }).then((_) {
                                              // Afficher un SnackBar de succès
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Utilisateur mis à jour avec succès')),
                                              );
                                              setState(() {
                                                _futureUsers = fetchUsers();
                                              });
                                              Navigator.pop(context); // Fermer le AlertDialog
                                            }).catchError((error) {
                                              // Afficher un SnackBar d'erreur
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Erreur lors de la mise à jour de l\'utilisateur')),
                                              );
                                            });
                                          },
                                          child: const Text('Modifier'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmation'),
                                      content: Text('Êtes-vous sûr de vouloir supprimer le produit "${user['username']}" ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteUser(user['id']).then((_) {
                                              // Afficher un SnackBar de confirmation
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Utilisateur supprimé avec succès')),
                                              );
                                              // Rafraîchir la liste des produits en rechargeant la page
                                              setState(() {
                                                _futureUsers = fetchUsers();
                                              });
                                              Navigator.of(context).pop(); // Fermer le AlertDialog
                                            }).catchError((error) {
                                              // En cas d'erreur, afficher un message d'erreur
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Erreur lors de la suppression de l\'utilisateur')),
                                              );
                                            });
                                          },
                                          child: const Text('Supprimer'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
         FutureBuilder<List<dynamic>>(
            future: _futureItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data![index];
                    int remainingStock = item['stocks']; // Stock restant du produit

                    Color stockColor;
                    // ignore: unused_local_variable
                    String stockStatus;

                    if (remainingStock == 0) {
                      stockStatus = 'Hors stock';
                      stockColor = Colors.red;
                    } else if (remainingStock < 20) {
                      stockStatus = 'Critique';
                      stockColor = Colors.orange;
                    } else if (remainingStock <= 50) {
                      stockStatus = 'Modéré';
                      stockColor = Colors.green;
                    } else {
                      stockStatus = 'Suffisant';
                      stockColor = Colors.blue;
                    }

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(item['item_name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.description, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(item['description'].length > 20 ? '${item['description'].substring(0, 20)}...' : item['description'],)
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text('${item['price']} €'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.inventory, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(
                                      remainingStock == 0 ? 'Hors stock' : '$remainingStock',
                                      style: TextStyle(color: remainingStock == 0 ? Colors.red : stockColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductInformationPage(product: item),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    String? selectedField;
                                    TextEditingController newValueController = TextEditingController();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Modifier le produit "${item['item_name']}"'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButtonFormField(
                                                value: selectedField,
                                                hint: const Text('Choisir le champ à modifier'),
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: 'item_name',
                                                    child: Text('Nom'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'description',
                                                    child: Text('Description'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'stocks',
                                                    child: Text('Stocks'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'price',
                                                    child: Text('Prix'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'id_category',
                                                    child: Text('Catégorie'),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  selectedField = value.toString();
                                                },
                                              ),
                                              TextField(
                                                controller: newValueController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Nouvelle valeur',
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Annuler'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (selectedField == null || selectedField!.isEmpty || newValueController.text.isEmpty) {
                                                  // Afficher une erreur si aucun champ ou aucune valeur n'est sélectionné
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Veuillez choisir un champ et saisir une valeur')),
                                                  );
                                                  return;
                                                }
                                                // Envoie de la requête de mise à jour
                                                updateProduct(item['id_items'], {
                                                  'field': selectedField!,
                                                  'value': newValueController.text,
                                                }).then((_) {
                                                  // Afficher un SnackBar de succès
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Produit mis à jour avec succès')),
                                                  );
                                                  setState(() {
                                                    _futureItems = fetchItems();
                                                  });
                                                  Navigator.pop(context); // Fermer le AlertDialog
                                                }).catchError((error) {
                                                  // Afficher un SnackBar d'erreur
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Erreur lors de la mise à jour du produit')),
                                                  );
                                                });
                                              },
                                              child: const Text('Modifier'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirmation'),
                                          content: Text('Êtes-vous sûr de vouloir supprimer le produit "${item['item_name']}" ?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Annuler'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteProduct(item['id_items']).then((_) {
                                                  // Afficher un SnackBar de confirmation
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Produit supprimé avec succès')),
                                                  );
                                                  // Rafraîchir la liste des produits en rechargeant la page
                                                  setState(() {
                                                    _futureItems = fetchItems();
                                                  });
                                                  Navigator.of(context).pop(); // Fermer le AlertDialog
                                                }).catchError((error) {
                                                  // En cas d'erreur, afficher un message d'erreur
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Erreur lors de la suppression du produit')),
                                                  );
                                                });
                                              },
                                              child: const Text('Supprimer'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUserPage(
                  futureUsers: _futureUsers,
                  onUserAdded: () {
                    setState(() {
                      _futureUsers = fetchUsers();
                    });
                  }
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProductPage(
                  futureItems: _futureItems,
                  onProductAdded: () {
                    setState(() {
                      _futureItems = fetchItems();
                    });
                  }
                ),
              ),
            );
          }
        },
        label: const Text('Ajouter'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ignore: unused_element
Widget _buildTextField(String labelText, Map<String, dynamic> userData, String fieldName) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(labelText),
      TextField(
        onChanged: (value) {
          // Mettre à jour les données de l'utilisateur lors de la saisie
          userData[fieldName] = value;
        },
      ),
    ],
  );
}