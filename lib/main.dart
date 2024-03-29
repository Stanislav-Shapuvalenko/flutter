import 'package:flutter/material.dart';
import 'package:foobar/widgets/ProductListBox.dart';
import 'package:foobar/widgets/RegisterBox.dart';

import 'models/User.dart';



void main() {
  var _desc =
      'Airbus A320 — семейство среднемагистральных узкофюзеляжных самолётов для авиалиний малой и средней протяжённости, разработанных европейским консорциумом «Airbus S.A.S». Выпущенный в 1988 году, он стал первым массовым пассажирским самолётом, на котором была применена электродистанционная система управления (ЭДСУ, англ. fly-by-wire).';
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Flubar регистрация'),
      ),
      body: SingleChildScrollView(
          child: RegisterBox()
      ),
    ),
    routes: {
      '/register':(BuildContext context) => RegisterBox(),
      '/productList':(BuildContext context) => ProductListBox(user: User(
        username: '',
        email: '',
      ),)
    },
  ));
}
