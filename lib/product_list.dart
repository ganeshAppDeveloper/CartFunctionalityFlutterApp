import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_1/cart_model.dart';
import 'package:flutter_shopping_cart_1/cart_provider.dart';
import 'package:flutter_shopping_cart_1/cart_screen.dart';
import 'package:flutter_shopping_cart_1/db_helper.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
 
  DBHelper dbHelper = DBHelper();

  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;
  
  List<String> _listOfItemId = [];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text("Product List"),
        centerTitle: true,
        actions: 
        [
          InkWell
          (
            onTap: ()
            {
              Navigator.of(context).push(MaterialPageRoute
                  (
                    builder:(context)
                    {
                      return CartScreen();
                    }
                  ));
              cart.setItemId(id:_listOfItemId);
            },
            child: Center
            (
              child: Badge
              (
                // badgeContent: const Text
                // (
                //   '0',
                //   style: TextStyle(color: Colors.white),
                // ),
                badgeContent: Consumer<CartProvider>(builder:(context,value,child)
                {
                  return Text
                      (
                        value.getCounter().toString(),
                        style: TextStyle(color: Colors.white),
                      );
                }),
                animationDuration: const Duration(milliseconds: 300),
                child: const Icon(Icons.shopping_cart),
                // child: IconButton
                // (
                //   onPressed:()
                //   {
                //     Navigator.of(context).push(MaterialPageRoute
                //     (
                //       builder:(context)
                //       {
                //         return CartScreen();
                //       }
                //     ));
                //   }, 
                //   icon: const Icon(Icons.shopping_cart)
                // ),
              )
            ),
          ),
          const SizedBox(width: 20,)
        ],
      ),

      body: Column(children: 
      [
        Expanded
        (
          child: ListView.builder
          (
            itemCount: productName.length,
            itemBuilder:(context,index)
            {
              return Card
              (
               elevation: 2.0,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column
                 (
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: 
                   [
                    Row
                    (
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: 
                      [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image
                          (
                            height: 100,
                            width: 100,
                            image: NetworkImage(productImage[index].toString())
                          ),
                        ),
                        Expanded(
                          child: Column
                          (
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: 
                            [
                              Text
                              (
                                productName[index].toString(),
                                style: const TextStyle
                                (
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
                                ),
                              ),
                              const SizedBox(height: 5.0,),
                              Text
                              (
                                productUnit[index].toString()+" "+r"$"+productPrice[index].toString() ,
                                style: const TextStyle
                                (
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
                                ),
                              ),
                              SizedBox(height: 5.0,),
                              /*
                              Align
                              (
                                alignment: Alignment.centerRight,
                                child: InkWell
                                (
                                  onTap: () {
                                    dbHelper.insert
                                    (
                                       Cart
                                       (
                                        id: index, 
                                        productId: index.toString(), 
                                        productName: productName[index].toString(), 
                                        initialPrice: productPrice[index], 
                                        productPrice: productPrice[index], 
                                        quantity: 1, 
                                        unitTag: productUnit[index].toString(), 
                                        image: productImage[index].toString()
                                        )
                                    ).then((value)
                                    {
                                      print("Product added successfully");
                                      cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                      cart.addCounter();
                                    }).onError((error, stackTrace) 
                                    {
                                      print(error.toString());
                                    });
                                  },
                                  child: Container
                                  (
                                    width: 100,
                                    height: 35,
                                    decoration: BoxDecoration
                                    (
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    child: const Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: const Text
                                      (
                                        "Add to Cart",
                                        textAlign: TextAlign.center,
                                        style: TextStyle
                                        (
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )*/
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row
                                (
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: 
                                  [
                                    InkWell
                                      (
                                        onTap: () {
                                        
                                              dbHelper.insert
                                              (
                                                Cart
                                                (
                                                  id: index, 
                                                  productId: index.toString(), 
                                                  productName: productName[index].toString(), 
                                                  initialPrice: productPrice[index], 
                                                  productPrice: productPrice[index], 
                                                  quantity: 1, 
                                                  unitTag: productUnit[index].toString(), 
                                                  image: productImage[index].toString()
                                                  )
                                              ).then((value)
                                              {
                                                print("Product added successfully");
                                                cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                                cart.addCounter();
                                                //cart.setItemId(id: index.toString());
                                                _listOfItemId.add(index.toString());
                                              }).onError((error, stackTrace) 
                                              {
                                                print(error.toString());
                                              });
                                        },
                                        child: Container
                                        (
                                          width: 100,
                                          height: 35,
                                          decoration: BoxDecoration
                                          (
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(5.0)
                                          ),
                                          child: const Padding(
                                            padding:  EdgeInsets.all(8.0),
                                            child: const Text
                                            (
                                              "Add to Cart",
                                              textAlign: TextAlign.center,
                                              style: TextStyle
                                              (
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.0,),
                                      InkWell
                                      (
                                        onTap: () {
                                          dbHelper.insert
                                          (
                                            Cart
                                            (
                                              id: index, 
                                              productId: index.toString(), 
                                              productName: productName[index].toString(), 
                                              initialPrice: productPrice[index], 
                                              productPrice: productPrice[index], 
                                              quantity: 1, 
                                              unitTag: productUnit[index].toString(), 
                                              image: productImage[index].toString()
                                              )
                                          ).then((value)
                                          {
                                            print("Product added successfully");
                                            cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                            cart.addCounter();
                                            //cart.setItemId(id: index.toString());
                                            _listOfItemId.add(index.toString());
                                            Navigator.of(context).push
                                            (
                                              MaterialPageRoute(builder:(context)
                                              {
                                                return const CartScreen();
                                              })
                                            );
                                          }).onError((error, stackTrace) 
                                          {
                                            print(error.toString());
                                          });
                                        },
                                        child: Container
                                        (
                                          width: 100,
                                          height: 35,
                                          decoration: BoxDecoration
                                          (
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(5.0)
                                          ),
                                          child: const Padding(
                                            padding:  EdgeInsets.all(8.0),
                                            child: const Text
                                            (
                                              "Buy now",
                                              textAlign: TextAlign.center,
                                              style: TextStyle
                                              (
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                   ],
                 ),
               )
              );
            } 
          )
        )
      ],)
    );
  }
}