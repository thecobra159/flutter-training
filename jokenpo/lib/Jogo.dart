import 'dart:math';

import 'package:flutter/material.dart';

class Jogo extends StatefulWidget {
  @override
  _JogoState createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  var _imagemApp = AssetImage("images/padrao.png");
  var _mensagem = "Escolha uma opção abaixo";
  var _pedra = AssetImage("images/pedra.png");
  var _papel = AssetImage("images/papel.png");
  var _tesoura = AssetImage("images/tesoura.png");

  void _opcaoSelecionada(int escolhaDoUsuario) {
    var _opcoes = ["pedra", "papel", "tesoura"];
    var numero = Random().nextInt(_opcoes.length);
    var escolhaApp = _opcoes[numero];

    print("Escolha do App: " + escolhaApp + "!");
    print("Escolha do Usuário: " + _opcoes[escolhaDoUsuario] + "!");

    // set imagem escolha do app
    switch (escolhaApp) {
      case "pedra":
        setState(() {
          this._imagemApp = _pedra;
        });
        break;
      case "papel":
        setState(() {
          this._imagemApp = _papel;
        });
        break;
      case "tesoura":
        setState(() {
          this._imagemApp = _tesoura;
        });
        break;
    }

    // validação do ganhador
    if ((_opcoes[escolhaDoUsuario] == "pedra" && escolhaApp == "tesoura") ||
        (_opcoes[escolhaDoUsuario] == "tesoura" && escolhaApp == "papel") ||
        (_opcoes[escolhaDoUsuario] == "papel" && escolhaApp == "pedra")) {
      _mensagem = "Usuário ganhou!";
    } else if ((escolhaApp == "pedra" && _opcoes[escolhaDoUsuario] == "tesoura") ||
        (escolhaApp == "tesoura" && _opcoes[escolhaDoUsuario] == "papel") ||
        (escolhaApp == "papel" && _opcoes[escolhaDoUsuario] == "pedra")) {
      _mensagem = "App ganhou!";
    } else {
      _mensagem = "Empate!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Joken Po"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 35, bottom: 15),
                child: Text(
                  "Escolha do App:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image(image: _imagemApp),
              Padding(
                padding: EdgeInsets.only(top: 35, bottom: 15),
                child: Text(
                  _mensagem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _opcaoSelecionada(0),
                    child: Image.asset(
                      "images/pedra.png",
                      height: 100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _opcaoSelecionada(1),
                    child: Image.asset(
                      "images/papel.png",
                      height: 100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _opcaoSelecionada(2),
                    child: Image.asset(
                      "images/tesoura.png",
                      height: 100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
