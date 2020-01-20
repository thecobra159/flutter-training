import 'package:anotacoes/helper/AnotacaoHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'model/Anotacao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  var _anotacoes = List<Anotacao>();

  _exibirTelaCadastro({Anotacao anotacao}) {
    var textoSalvarAtualizar = "";
    if(anotacao == null) {
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$textoSalvarAtualizar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Título", hintText: "Digite um título"),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: "Descrição", hintText: "Digite uma descrição"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                    Navigator.pop(context);
                  },
                  child: Text("$textoSalvarAtualizar")),
            ],
          );
        });
  }

  _salvarAtualizarAnotacao({Anotacao anotacaoSelecionada}) async {
    var titulo = _tituloController.text;
    var descricao = _descricaoController.text;

    if(anotacaoSelecionada == null) {
      var anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);
      print("Anotação salva com id: $resultado");
    } else {
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloController.text = "";
    _descricaoController.text = "";

    _recuperarAnotacoes();
  }

  _recuperarAnotacoes() async {
    var anotacoesRecuperadas = await _db.recuperarAnotacoes();
    var anotacoesTemporarias = List<Anotacao>();
    for (var item in anotacoesRecuperadas) {
      var anotacao = Anotacao.fromMap(item);
      anotacoesTemporarias.add(anotacao);
    }

    setState(() {
      _anotacoes = anotacoesTemporarias;
    });
    anotacoesTemporarias = null;
    print("Lista anotações: $anotacoesRecuperadas");
  }

  _formatarData(String data) {
    initializeDateFormatting('pt_BR');
    var formatador = DateFormat.yMMMMd("pt_BR");
    return formatador.format(DateTime.parse(data));
  }

  _removerAnotacao(int id) async {
    await _db.removerAnotacao(id);
    _recuperarAnotacoes();
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: _anotacoes.length,
            itemBuilder: (context, index) {
              final item = _anotacoes[index];
              return Card(
                child: ListTile(
                  title: Text(item.titulo),
                  subtitle: Text("${_formatarData(item.data)} - ${item.descricao}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                        onTap: () {
                          _exibirTelaCadastro(anotacao: item);
                        },
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          _removerAnotacao(item.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        child: Icon(Icons.add_circle_outline),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
