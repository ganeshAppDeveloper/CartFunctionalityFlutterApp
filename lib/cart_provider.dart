import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_1/cart_model.dart';
import 'package:flutter_shopping_cart_1/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier
{
   DBHelper _dbHelper = DBHelper();

   int _counter = 0;
   int get counter => _counter;

   double _totalPrice = 0.0;
   double get totalPrice => _totalPrice;

   late Future<List<Cart>> _cart;
   Future<List<Cart>> get cart => _cart;

   Future<List<Cart>> getData() async
   {
     _cart = _dbHelper.getCartList();
     return _cart;
   }
   
   Future deleteAllTableRecords()async
   {
     _dbHelper.deleteAll();
     notifyListeners();
   }

   void _setPrefItems() async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setInt('cart_item', _counter);
     prefs.setDouble('total_price', _totalPrice);
     notifyListeners();
   }

   void _getPrefItems() async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     _counter = prefs.getInt('cart_item')?? 0;
     _totalPrice = prefs.getDouble('total_price')?? 0.0;
     notifyListeners();
   }

   void addCounter()
   {
     _counter++;
     _setPrefItems();
     notifyListeners();
   }

   void decreaseCounter()
   {
     _counter--;
     _setPrefItems();
     notifyListeners();
   }
   
   void setCounterToZero()
   {
     _counter = 0;
     _setPrefItems();
     notifyListeners();
   }

   void setTotalPriceToZero()
   {
     _totalPrice = 0.00;
     _setPrefItems();
     notifyListeners();
   }
   void addTotalPrice(double productPrice)
   {
     _totalPrice = _totalPrice + productPrice;
     _setPrefItems();
     notifyListeners();
   }

   void decreaseTotalPrice(double productPrice)
   {
     _totalPrice = _totalPrice - productPrice;
     _setPrefItems();
     notifyListeners();
   }
   
  int getCounter()
   {
     _getPrefItems();
     return _counter;
   }

   double getTotalPrice()
   {
     _getPrefItems();
     return _totalPrice;
   }
  
   Future setItemId({required List<String> id}) async {
   final prefs = await SharedPreferences.getInstance();
   prefs.setStringList('listOfItemId', id);
   notifyListeners();
 }
 Future<List<String>> getItemId() async {
   final prefs = await SharedPreferences.getInstance();
   notifyListeners();
   return prefs.getStringList('listOfItemId') ?? [];
 }
 
 removeItemIdsFromSharedPrefList()async
 {
   final prefs = await SharedPreferences.getInstance();
   prefs.remove('listOfItemId');
   notifyListeners();
 }

}