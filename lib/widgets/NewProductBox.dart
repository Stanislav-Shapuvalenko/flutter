import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Product.dart';

class NewProductBox extends StatefulWidget {
  @override
  NewProductBoxState createState() => NewProductBoxState();
}

class NewProductBoxState extends State<NewProductBox> {
  late TextEditingController nameController;
  late TextEditingController countryController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    countryController = TextEditingController();
    quantityController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('http://10.0.2.2:5000/products');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': product.name,
        'country_name': product.countryName,
        'quantity': product.quantity,
      }),
    );

    if (response.statusCode == 201) {
      print('Product added successfully!');
      Navigator.pop(context);
    } else {
      throw Exception('Failed to add product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flubar добавить'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Наименование'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: countryController,
              decoration: InputDecoration(labelText: 'Страна'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Количество'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final country = countryController.text.trim();
                final quantity = int.tryParse(quantityController.text.trim()) ?? 0;

                if (name.isNotEmpty && country.isNotEmpty && quantity > 0) {
                  final newProduct = Product(
                    id: 0,
                    name: name,
                    countryName: country,
                    quantity: quantity,
                  );
                  addProduct(newProduct);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Заполните все поля')),
                  );
                }
              },
              child: Text('Добавить'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green,foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}