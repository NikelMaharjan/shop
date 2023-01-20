

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_shop/models/cart_item.dart';
import 'package:simple_shop/models/products.dart';
import 'package:simple_shop/views/main.dart';




final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) => CartProvider(ref.watch(boxB)));



class CartProvider extends StateNotifier<List<CartItem>>{
  CartProvider(super.state);


  String addToCart(Product product){

    if(state.isEmpty){     //if no any products in present in cart, state will be empty

      final newCart = CartItem(
          imageUrl: product.image,
          id: product.id,
          price: product.price,
          title: product.product_name,
          quantity: 1,
          total: product.price
      );

      Hive.box<CartItem>('carts').add(newCart);
      state = [newCart];
      return "Successfully added to cart";
    }

    //if products is present in cart. this will check if new products or same products added to cart

    else{
      final isProduct = state.firstWhere((element) => element.id == product.id, orElse: () => CartItem.empty());


      //this will be true when state in not empty (product is present in cart) but different products since we returned cartItem.empty
      if(isProduct.title == 'no-data'){
        final newCart = CartItem(
            imageUrl: product.image,
            id: product.id,
            price: product.price,
            title: product.product_name,
            quantity: 1,
            total: product.price
        );

        Hive.box<CartItem>('carts').add(newCart);
        state = [...state, newCart];   //to display previous added product and new product
        return "successfully added to cart";

      }

      else {
        return 'already added to cart';
      }





    }




  }



  void singleAddtoCart(CartItem cartItem){

    cartItem.quantity = cartItem.quantity + 1;
    cartItem.save();

    //to update realtime... check every cart in state. if  state cart is equal to cartItem , it will return/update cartItem otherwise cart
    state = [
      for(final cart in state) if(cart.id == cartItem.id) cartItem else cart
    ];



  }

  void singleRemoveCart(CartItem cartItem){
    if(cartItem.quantity > 1){
      cartItem.quantity = cartItem.quantity - 1;
    }
    cartItem.save();

    state = [
      for(final cart in state) if (cart.id == cartItem.id) cartItem else cart
    ];

  }



  void Remove(CartItem cartItem){
    cartItem.delete();
    state.remove(cartItem);
    state = [...state];
  }

  void clear(){
    Hive.box<CartItem>('carts').clear();
    state = [];
  }


  int get total{
    int total = 0;
    for(final cart in state){
      total += cart.quantity * cart.price;
    }
    return total;
  }

}