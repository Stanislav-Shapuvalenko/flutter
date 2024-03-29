import 'package:flutter/material.dart';

import '../models/User.dart';
import 'ProductListBox.dart';

enum GenderList {male,female}


class RegisterBox extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterBoxState();
  }

}


class RegisterBoxState extends State<RegisterBox> {
  final _formKey = GlobalKey<FormState>();
  GenderList? _gender;
  bool _agreement = false;
  String? _username;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Имя пользователя', style: TextStyle(fontSize: 20)),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return 'Пожалуйста введите имя';
                  },
                  onChanged: (value) {
                    _username = value;
                  },
                ),
                SizedBox(height: 20),
                Text('Email', style: TextStyle(fontSize: 20)),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Пожалуйства введите почту';
                    }
                    String p =
                        "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                    RegExp regExp = new RegExp(p);
                    if (regExp.hasMatch(value)) return null;
                    return 'Это не E-mail';
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: 20),
                Text('Ваш пол', style: TextStyle(fontSize: 20)),
                RadioListTile(
                  title: const Text('Мужской'),
                  value: GenderList.male,
                  groupValue: _gender,
                  onChanged: (GenderList? value) {
                    setState(() {
                      print('Value:$value');
                      _gender = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Женский'),
                  value: GenderList.female,
                  groupValue: _gender,
                  onChanged: (GenderList? value) {
                    setState(() {
                      print('Value:$value');
                      _gender = value!;
                    });
                  },
                ),
                SizedBox(height: 15),
                CheckboxListTile(
                  value: _agreement,
                  title: Text('Я согласен'),
                  onChanged: (bool? value) {
                    setState(() {
                      _agreement = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _gender != null &&
                        _agreement) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Форма успешно заполнена'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Создаем пользователя
                      User user = User(username: _username, email: _email);

                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListBox(user: user),
                          ),
                        );
                      });
                    } else if (!_agreement) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Необходимо принять условия соглашения'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (_gender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Выберите свой пол'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Проверить', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}