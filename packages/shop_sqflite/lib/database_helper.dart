part of 'shop_sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "ShoppingCart.db";
  static const _databaseVersion = 1;

  static const table = 'MyCart';

  static const columnId = '_id';
  static const columnProductName = 'productName';
  static const columnProductPrice = 'productPrice';
  static const columnGrandTotal = 'productGrandTotal';
  static const columnQuantity = 'productQuantity';
  static const columnProductImage = 'productImage';
  static const columnProductId = 'productId';

  // make this a singleton class
  DatabaseHelper._privateConstructor() {
    _initializeInstance();
  }

  void _initializeInstance() async {
    _database = await database;
  }

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(documentsDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY,
            $columnProductId INTEGER NOT NULL,
            $columnProductName TEXT NOT NULL,
            $columnProductImage TEXT NOT NULL,
            $columnProductPrice INTEGER NOT NULL,
            $columnQuantity INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  //Inserting Product row
  Future<int> insert(Map<String, dynamic> row) async {
    return await _database!.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _database!.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    return Sqflite.firstIntValue(
        await _database!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //Check data is available or not
  //Checking product is existing or not
  Future<int?> queryRowIdCount(int id) async {
    return Sqflite.firstIntValue(await _database!
        .rawQuery('SELECT COUNT(*) FROM $table WHERE $columnProductId = $id'));
  }

  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _database!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _database!
        .delete(table, where: '$columnProductId = ?', whereArgs: [id]);
  }
}
