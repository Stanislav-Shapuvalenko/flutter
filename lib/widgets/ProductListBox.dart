import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Product.dart';
import '../models/User.dart';
import 'DialogBox.dart';
import 'NewProductBox.dart';

class ProductListBox extends StatefulWidget {
  final User user;

  const ProductListBox({required this.user});

  @override
  _ProductListBoxState createState() => _ProductListBoxState();
}

class _ProductListBoxState extends State<ProductListBox> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchData();
  }

  Future<List<Product>> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/products'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:5000/products/$productId'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Продукт удален успешно'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Не удалось удалить продукт'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flubar Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DialogBox()));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Вы авторизованы!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(title: Text('Имя: ${widget.user.username}')),
            ListTile(title: Text('Почта: ${widget.user.email}')),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          title: Text(product.name,
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          subtitle: Text(
                              'Страна: ${product.countryName}, Количество: ${product.quantity}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteProduct(product.id);
                              setState(() {
                                _futureProducts = fetchData();
                              });
                            },
                            style: IconButton.styleFrom(foregroundColor: Colors.red),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewProductBox())).then((value) {
            setState(() {
              _futureProducts = fetchData();
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}