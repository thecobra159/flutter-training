import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _list = [];
  var _ultimaTerefaRemovida = Map();
  var _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    print("Caminho: " + diretorio.path);
    return File("$diretorio.path/dados.json");
  }

  _salvarTarefa() {
    var textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;
    setState(() {
      _list.add(tarefa);
    });

    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    final file = await _getFile();
    var dados = json.encode(_list);
    file.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final file = await _getFile();
      file.readAsString();
    } catch (ex) {
      print("Problema ao ler arquivo: " + ex.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        _list = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Itens: " + DateTime.now().millisecondsSinceEpoch.toString());
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                  background: Container(
                    color: Colors.green,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    _ultimaTerefaRemovida = _list[index];
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        _list.removeAt(index);
                      });
                    }
                    final snackBar = SnackBar(
                      content: Text("Tarefa removida!"),
                      action: SnackBarAction(
                          label: "Desfazer",
                          onPressed: () {
                            setState(() {
                              _list.insert(index, _ultimaTerefaRemovida);
                            });
                          }),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                    _salvarArquivo();
                  },
                  child: CheckboxListTile(
                    title: Text(_list[index]['titulo']),
                    value: _list[index]['realizada'],
                    onChanged: (valorAlterado) {
                      setState(() {
                        _list[index]['realizada'] = valorAlterado;
                      });
                      _salvarArquivo();
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: <Widget>[
                    FlatButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
                    FlatButton(
                        onPressed: () {
                          _salvarTarefa();
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")),
                  ],
                );
              });
          print("botão pressionado");
        },
      ),
    );
  }
}
