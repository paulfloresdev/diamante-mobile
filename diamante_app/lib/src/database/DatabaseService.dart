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
    // Crear tabla de Grupos
    await db.execute('''
      CREATE TABLE grupos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      )
    ''');

    // Crear tabla de Subgrupos
    await db.execute('''
      CREATE TABLE subgrupos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        grupo_id INTEGER NOT NULL,
        FOREIGN KEY (grupo_id) REFERENCES grupos (id) ON DELETE CASCADE
      )
    ''');

    // Crear tabla de Productos
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        concepto TEXT NOT NULL,
        tipo_unidad TEXT NOT NULL,
        precio_unitario REAL NOT NULL,
        cantidad INTEGER NOT NULL,
        importe_total REAL NOT NULL,
        is_selected BOOLEAN NOT NULL DEFAULT 0,
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

  Future<int> updateSubgrupo(int id, String nombre) async {
    final db = await instance.database;
    return await db.update(
      'subgrupos',
      {
        'nombre': nombre,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSubgrupo(int id) async {
    final db = await instance.database;
    return await db.delete('subgrupos', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD para Productos
  Future<int> createProducto({
    required String concepto,
    required String tipoUnidad,
    required double precioUnitario,
    required int cantidad,
    required double importeTotal,
    bool isSelected = false,
    required int subgrupoId,
  }) async {
    final db = await instance.database;

    return await db.insert('productos', {
      'concepto': concepto,
      'tipo_unidad': tipoUnidad,
      'precio_unitario': precioUnitario,
      'cantidad': cantidad,
      'importe_total': importeTotal,
      'is_selected': isSelected ? 1 : 0, // Convertimos booleano a 0/1.
      'subgrupo_id': subgrupoId,
    });
  }

  Future<int> updateProducto({
    required int id,
    required String concepto,
    required String tipoUnidad,
    required double precioUnitario,
    required int cantidad,
    required double importeTotal,
    required int subgrupoId,
  }) async {
    final db = await instance.database;

    return await db.update(
      'productos', // Nombre de la tabla
      {
        'concepto': concepto,
        'tipo_unidad': tipoUnidad,
        'precio_unitario': precioUnitario,
        'cantidad': cantidad,
        'importe_total': importeTotal,
        'subgrupo_id': subgrupoId,
      },
      where: 'id = ?', // Condición para encontrar el producto
      whereArgs: [id], // Argumentos para la condición
    );
  }

  Future<List<Map<String, dynamic>>> getProductosBySubgrupo(
      int subgrupoId) async {
    final db = await instance.database;
    return await db
        .query('productos', where: 'subgrupo_id = ?', whereArgs: [subgrupoId]);
  }

  Future<int> updateProductoSeleccion(int id, bool isSelected) async {
    final db = await instance.database;
    return await db.update(
      'productos',
      {'is_selected': isSelected ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getProductosSeleccionados(
      int subgrupoId) async {
    final db = await instance.database;
    return await db.query(
      'productos',
      where: 'subgrupo_id = ? AND is_selected = ?',
      whereArgs: [subgrupoId, 1],
    );
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
