import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE grupos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE subgrupos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        grupo_id INTEGER NOT NULL,
        FOREIGN KEY (grupo_id) REFERENCES grupos (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        concepto TEXT NOT NULL,
        tipo_unidad TEXT NOT NULL,
        precio_unitario REAL NOT NULL,
        cantidad INTEGER NOT NULL,
        importe_total REAL NOT NULL,
        subgrupo_id INTEGER NOT NULL,
        FOREIGN KEY (subgrupo_id) REFERENCES subgrupos (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<String> printDatabasePath() async {
    final databasesPath = await getDatabasesPath();
    print('Database path: $databasesPath');
    return databasesPath;
  }

  // CRUD para Grupos
  Future<int> createGrupo(String nombre) async {
    final db = await instance.database;
    return await db.insert('grupos', {'nombre': nombre});
  }

  Future<List<Map<String, dynamic>>> getAllGrupos() async {
    final db = await instance.database;
    return await db.query('grupos');
  }

  Future<int> updateGrupo(int id, String nuevoNombre) async {
    final db = await instance.database;
    return await db.update(
      'grupos',
      {'nombre': nuevoNombre},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteGrupo(int id) async {
    final db = await instance.database;
    return await db.delete('grupos', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD para Subgrupos
  Future<int> createSubgrupo(String nombre, int grupoId) async {
    final db = await instance.database;
    return await db.insert('subgrupos', {
      'nombre': nombre,
      'grupo_id': grupoId,
    });
  }

  Future<List<Map<String, dynamic>>> getSubgruposByGrupo(int grupoId) async {
    final db = await instance.database;
    return await db
        .query('subgrupos', where: 'grupo_id = ?', whereArgs: [grupoId]);
  }

  Future<int> deleteSubgrupo(int id) async {
    final db = await instance.database;
    return await db.delete('subgrupos', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD para Productos
  Future<int> createProducto(Map<String, dynamic> producto) async {
    final db = await instance.database;
    return await db.insert('productos', producto);
  }

  Future<List<Map<String, dynamic>>> getProductosBySubgrupo(
      int subgrupoId) async {
    final db = await instance.database;
    return await db
        .query('productos', where: 'subgrupo_id = ?', whereArgs: [subgrupoId]);
  }

  Future<int> deleteProducto(int id) async {
    final db = await instance.database;
    return await db.delete('productos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
