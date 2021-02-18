import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class Bovespa extends StatefulWidget {
  @override
  _Bovespa createState() => _Bovespa();
}

class _Bovespa extends State<Bovespa> {
  final controllerRS = TextEditingController();
  final controllerUS = TextEditingController();
  final controllerEU = TextEditingController();
  final String urlRequest =
      'https://api.hgbrasil.com/finance?format=json&key=e5d9438f';

  double dolar;
  double euro;

  Future<Map> _getApi() async {
    Dio dio = Dio();
    Response response = await dio.get(urlRequest);
    return response.data;
  }

  void cleanControls() {
    controllerRS.clear();
    controllerUS.clear();
    controllerEU.clear();
  }

  void _realChanged(text) {
    double real = double.parse(text);
    controllerUS.text = (real / dolar).toStringAsFixed(2);
    controllerEU.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(text) {
    double dolar = double.parse(text);
    controllerRS.text = (dolar * this.dolar).toStringAsFixed(2);
    controllerEU.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(text) {
    double euro = double.parse(text);
    controllerRS.text = (euro * this.euro).toStringAsFixed(2);
    controllerUS.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Color(0xFFFFFFfF),
              ),
              onPressed: cleanControls)
        ],
        title: Text('BOVESPA',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
            )),
        centerTitle: true,
        backgroundColor: Color(0xFFA9C159),
      ),
      body: _body,
    );
  }

  Widget get _body {
    return FutureBuilder<Map>(
      future: _getApi(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados'));
            } else {
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    BuilderTextField("Real", "R\$", controllerRS, _realChanged),
                    BuilderTextField(
                        "Dolar", "\$", controllerUS, _dolarChanged),
                    BuilderTextField("Euro", "€", controllerEU, _euroChanged),
                  ]));
            }
        }
      },
    );
  }

  Widget BuilderTextField(String coin, String symble,
      TextEditingController controler, Function changeFunction) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          onChanged: changeFunction,
          controller: controler,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: coin,
              prefixText: symble,
              labelStyle: TextStyle(color: Color(0xFFA9C159)),
              border: OutlineInputBorder()),
        ));
  }
}
