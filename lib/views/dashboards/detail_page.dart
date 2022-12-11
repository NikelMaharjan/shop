import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/colors.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/models/products.dart';
import 'package:simple_shop/providers/cart_provider.dart';



class DetailPage extends StatelessWidget {
  final Product product;
  DetailPage(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [

              Container(
               color: blue,

                child: Container(
                  decoration: BoxDecoration(
                     color: white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  margin: EdgeInsets.only(top: 220),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 20, right: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                              Text(product.product_name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(product.product_detail),
                              ),
                              Text('Rs ${product.price}'),
                            ],
                          ),
                        ),

                        Consumer(
                            builder: (context, ref, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff4252B5),
                                ),
                                  onPressed: () {
                                    final response = ref.read(cartProvider.notifier).addToCart(product);
                                    if(response != 'already added to cart'){
                                      SnackShow.showCommonSnack(context, response, label: "Go to Cart", isADD: true);
                                    }else{
                                      SnackShow.showCommonSnack(context, response, label: "Go to Cart", isADD: true);
                                    }
                                  }, child: Text('Add To Cart'));
                            }
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment(0.8, -0.9),
                child: Container(

                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(imageUrl: product.image, fit: BoxFit.cover, height: 220, width: 200,)),
                ),
              )


            ],
          ),
        )
    );
  }
}