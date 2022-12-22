import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_shopping_cart_1/cart_model.dart';
import 'package:flutter_shopping_cart_1/db_helper.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  DBHelper dbHelper = DBHelper();

  
  @override
  Widget build(BuildContext context) 
  {
     final cart = Provider.of<CartProvider>(context);
     return Scaffold
     (
       appBar: AppBar
      (
        title: const Text("My Products"),
        centerTitle: true,
        actions: 
        [
          Center
          (
            child: Badge
            (
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
              //   onPressed:()=> null,
              //   icon: const Icon(Icons.shopping_cart)
              // ),
            )
          ),
          const SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            FutureBuilder
            (
              future: cart.getData(),
              builder: (context,AsyncSnapshot<List<Cart>>snapshot)
              {
                if(snapshot.hasData)
                {
                  return snapshot.data!.isEmpty
                  ? const Center
                   (
                    child: Text
                     (
                       "No Items found in Cart!!",
                       style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                       )
                     ),
                   )
                  : Expanded
                  (
                    child: ListView.builder
                    (
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index)
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
                                      image: NetworkImage(snapshot.data![index].image!.toString())
                                    ),
                                  ),
                                  Expanded(
                                    child: Column
                                    (
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: 
                                      [
                                        // Text
                                        // (
                                        //   snapshot.data![index].productName.toString(),
                                        //   style: const TextStyle
                                        //   (
                                        //     fontWeight: FontWeight.w500,
                                        //     fontSize: 16
                                        //   ),
                                        // ),
                                        Row
                                        (
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: 
                                          [
                                            Text
                                            (
                                              snapshot.data![index].productName.toString(),
                                              style: const TextStyle
                                              (
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16
                                              ),
                                            ),
                                            IconButton
                                            (
                                              onPressed:()
                                              {
                                                dbHelper.delete(snapshot.data![index].id);
                                                cart.decreaseCounter();
                                                cart.decreaseTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                              }, 
                                              icon: Icon(Icons.delete)
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5.0,),
                                        Text
                                        (
                                          snapshot.data![index].unitTag.toString()+" "+r"$"+snapshot.data![index].productPrice.toString() ,
                                          style: const TextStyle
                                          (
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16
                                          ),
                                        ),
                                        SizedBox(height: 5.0,),
                                        Align
                                        (
                                          alignment: Alignment.centerRight,
                                          child: InkWell
                                          (
                                            onTap: () {
                                              
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
                                              /*
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
                                              ),*/
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Row
                                                (
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: 
                                                  [
                                                    InkWell
                                                    (
                                                      onTap: ()
                                                      {
                                                        int quantity = snapshot.data![index].quantity!;
                                                        int price = snapshot.data![index].initialPrice!;
                                                        quantity++;
                                                        int? newPrice = price * quantity;
                                                        dbHelper.updateQuantity
                                                        (
                                                          Cart
                                                          (
                                                            id: snapshot.data![index].id!, 
                                                            productId: snapshot.data![index].id!.toString(), 
                                                            productName: snapshot.data![index].productName!, 
                                                            initialPrice: snapshot.data![index].initialPrice!, 
                                                            productPrice: newPrice, 
                                                            quantity: quantity, 
                                                            unitTag: snapshot.data![index].unitTag.toString(), 
                                                            image: snapshot.data![index].image.toString()
                                                          )
                                                        ).then
                                                        (
                                                          (value)
                                                          {
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                            print("Data updated successfully");
                                                          }
                                                        )
                                                        .onError((error, stackTrace)
                                                        {
                                                          print(error.toString());
                                                        });
                                                      },
                                                      child: Icon(Icons.add,color: Colors.white,),
                                                    ),
                                                    Text
                                                    (
                                                      snapshot.data![index].quantity.toString() ,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle
                                                      (
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                    InkWell
                                                    (
                                                      onTap: ()
                                                      {
                                                        int quantity = snapshot.data![index].quantity!;
                                                        int price = snapshot.data![index].initialPrice!;
                                                        quantity --;
                                                        int? newPrice = price * quantity;
                                                        if(quantity > 0)
                                                        {
                                                           dbHelper.updateQuantity
                                                            (
                                                              Cart
                                                              (
                                                                id: snapshot.data![index].id!, 
                                                                productId: snapshot.data![index].id!.toString(), 
                                                                productName: snapshot.data![index].productName!, 
                                                                initialPrice: snapshot.data![index].initialPrice!, 
                                                                productPrice: newPrice, 
                                                                quantity: quantity, 
                                                                unitTag: snapshot.data![index].unitTag.toString(), 
                                                                image: snapshot.data![index].image.toString()
                                                              )
                                                            ).then
                                                            (
                                                              (value)
                                                              {
                                                                newPrice = 0;
                                                                quantity = 0;
                                                                cart.decreaseTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                print("Data updated successfully");
                                                              }
                                                            )
                                                            .onError((error, stackTrace)
                                                            {
                                                              print(error.toString());
                                                            }); 
                                                        }
                                                        
                                                      },
                                                      child: Icon(Icons.remove,color: Colors.white,),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
                  );
                }
                return const Center
                (
                  child: CircularProgressIndicator(),
                );
              },
            ),

            Expanded(
              flex: 0,
              child: Consumer<CartProvider>
              (
                builder:(context,value,child)
                {
                  return Visibility
                  (
                    visible: value.getTotalPrice().toStringAsFixed(2).toString() == "0.00" ? false:true,
                    child: Card(
                      elevation: 8.0,
                      shape: const RoundedRectangleBorder
                      (
                        //side: BorderSide(color: Colors.blue,width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            // ReusableWidget(title:'SubTotal', value: r'$'+value.getTotalPrice().toStringAsFixed(2)),
                            // ReusableWidget(title:'Discount 5%', value: r'$'+'20'),
                            ReusableWidget(title:'Total', value: r'$'+value.getTotalPrice().toStringAsFixed(2)),
                            //const Divider(),
                            const SizedBox(height: 5.0,),
                            Row
                            (
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: 
                              [
                                Container
                                (
                                  width: 200,
                                  height: 50,
                                  child: TextFormField
                                  (
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration
                                                      (
                                                        hintText: 'Apply Coupon Code',
                                                        enabledBorder: OutlineInputBorder
                                                        (
                                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                          borderSide: BorderSide(color: Colors.blue,width: 1.5)
                                                        ),
                                                        focusedBorder: OutlineInputBorder
                                                        (
                                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                          borderSide: BorderSide(color: Colors.blue,width: 1.5)
                                                        ),
                                                        disabledBorder: OutlineInputBorder
                                                        (
                                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                          borderSide: BorderSide(color: Colors.blue,width: 1.5)
                                                        )
                                                      ),
                                  ),
                                ),
                                const SizedBox(width: 5.0,),
                                ElevatedButton
                                (
                                  onPressed:(){}, 
                                  style: ElevatedButton.styleFrom
                                  (
                                    shape:RoundedRectangleBorder
                                    (
                                      borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    minimumSize: Size(50, 50)
                                  ),
                                  child:Text("Apply Coupon")
                                )
                              ],
                            ),
                            const SizedBox(height: 5.0,),
                            InkWell
                            (
                              onTap: ()
                              {
                                value.deleteAllTableRecords();
                                value.setCounterToZero();
                                value.setTotalPriceToZero();
                                value.getItemId().then((listOfId) => print(listOfId));
                                Scaffold.of(context).showSnackBar(SnackBar(content:Text("Items deleted on successfully payment")));
                              },
                              child: Container
                                  (
                                    width: 100,
                                    //width: double.infinity,
                                    height: 35,
                                    decoration: BoxDecoration
                                    (
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    child: const Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text
                                      (
                                        "Pay now",
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
                      ),
                    ),
                  );
                }),
            )
          ],
        ),
      ),
     ); 
  }
  
}

class ReusableWidget extends StatelessWidget {
  final String title,value;
  const ReusableWidget({Key? key,required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4.0),
      child: Row
      (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: 
        [
          //const SizedBox(width: 8.0,),
          Text
          (
            title,
            //style: Theme.of(context).textTheme.subtitle2,
            style: const TextStyle
            (
              fontSize: 20.0,
              fontWeight: FontWeight.w600
            ),
          ),
          //const SizedBox(width: 8.0,),
          Text
          (
            value.toString(),
            //style: Theme.of(context).textTheme.subtitle2,
            style: const TextStyle
            (
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}

