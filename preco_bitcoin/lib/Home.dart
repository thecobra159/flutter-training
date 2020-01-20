import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _precoReal = "";
  String _symbolReal = "";
  String _precoUsd = "";
  String _symbolUsd = "";
  String _precoEur = "";
  String _symbolEur = "";

  void _recuperarPreco() async {
    String _url = "https://blockchain.info/ticker";
    http.Response response = await http.get(_url);

    Map<String, dynamic> result = json.decode(response.body);

    setState(() {
      _precoReal = result["BRL"]["buy"].toString();
      _symbolReal = result["BRL"]["symbol"].toString();
      _precoUsd = result["USD"]["buy"].toString();
      _symbolUsd = result["USD"]["symbol"].toString();
      _precoEur = result["EUR"]["buy"].toString();
      _symbolEur = result["EUR"]["symbol"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/bitcoin.png"),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  "$_symbolReal $_precoReal",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  "$_symbolUsd $_precoUsd",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  "$_symbolEur $_precoEur",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              RaisedButton(
                child: Text(
                  "Atualizar",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                color: Colors.orange,
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                onPressed: _recuperarPreco,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
