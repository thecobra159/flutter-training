import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _alcoolController = TextEditingController();
  var _gasolinaController = TextEditingController();
  var _textoResultado = "";

  void _calcular() {
    var _precoAlcool = double.tryParse(_alcoolController.text);
    var _precoGasolina = double.tryParse(_gasolinaController.text);

    if (_precoAlcool == null || _precoGasolina == null) {
      setState(() {
        _textoResultado = "Número inválido, digite números maiores que 0 e com ponto.";
      });
    } else {
      if ((_precoAlcool / _precoGasolina) >= 0.7) {
        setState(() {
          _textoResultado = "Melhor abastecer com gasolina!";
        });
      } else {
        setState(() {
          _textoResultado = "Melhor abastecer com álcool!";
        });
      }
    }
    _limparCampos();
  }

  void _limparCampos() {
    _gasolinaController.text = "";
    _alcoolController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Álcool ou Gasolina"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
          child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Image.asset("images/logo.png"),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Saiba qual a melhor opção para abastecimento do seu veículo!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                maxLengthEnforced: true,
                decoration: InputDecoration(labelText: "Preço Álcool, ex: 1.59"),
                style: TextStyle(fontSize: 22),
                controller: _alcoolController,
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                maxLengthEnforced: true,
                decoration: InputDecoration(labelText: "Preço Gasolina, ex: 3.59"),
                style: TextStyle(fontSize: 22),
                controller: _gasolinaController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Calcular",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  onPressed: _calcular,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  _textoResultado,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
