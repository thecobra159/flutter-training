import 'package:anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    }

    return _db = await _inicializaDb();
  }

  _inicializaDb() async {
    final caminhoDb = await getDatabasesPath();
    final localDb = join(caminhoDb, "banco_anotacoes");

    var db = await openDatabase(localDb, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    return await bancoDados.insert(nomeTabela, anotacao.toMap());
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    return await bancoDados.update(
      nomeTabela,
      anotacao.toMap(),
      where: "id = ?",
        whereArgs: [anotacao.id]
    );
  }

  Future<int> removerAnotacao(int id) async {
    var bancoDados = await db;
    return await bancoDados.delete(
      nomeTabela,
      where: "id = ?",
      whereArgs: [id]
    );
  }

  recuperarAnotacoes() async {
    var bancoDados = await db;
    var sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    return await bancoDados.rawQuery(sql);
  }

  _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, descricao TEXT, data DATETIME)";
    await db.execute(sql);
  }
}
