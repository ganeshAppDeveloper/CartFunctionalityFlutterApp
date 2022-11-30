import 'package:flutter_shopping_cart_1/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper
{
  static Database? _db;

  Future<Database?> get db async
  {
     if(_db!=null)
     {
      return _db!;
     }
     _db = await initDatabase();
  } 

  initDatabase()async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory(); // creating path for local storage of database inside mobile
    String path = join(documentDirectory.path,"cart.db"); //creating database at specified pathS
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
   await db
        .execute('CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
  }

  Future<Cart> insert(Cart cart) async{
    var dbClient = await db;
    await  dbClient!.insert('cart', cart.toMap());

    return cart;
  }

  Future<List<Cart>> getCartList() async{
    var dbClient = await db;
    final List<Map<String,Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int? id) async
  {
    var dbClient = await db;
    return await dbClient!.delete
    (
      'cart',
      where: "id = ?",
      whereArgs: [id]
    );
  }
  
  Future deleteAll() async {
    var dbClient = await db;
    return await dbClient!.rawQuery('DELETE FROM cart');
  }

  Future<int> updateQuantity(Cart cart) async
  {
    var dbClient = await db;
    return await dbClient!.update
    (
      'cart',
      cart.toMap(),
      where: "id = ?",
      whereArgs: [cart.id]
    );
  }
}