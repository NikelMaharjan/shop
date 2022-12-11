


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/services/crud_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:simple_shop/views/dashboards/cart_page.dart';

import 'detail_page.dart';

class HomePage extends ConsumerWidget {

  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, ref) {
    final h = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final w = MediaQuery.of(context).size.width;
    final productDb = ref.watch(productData);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(onPressed: (){

            Get.to(const CartPage());

            }, icon: const Icon(CupertinoIcons.shopping_cart))
        ],
        title: const Text("Products", style: TextStyle(color: Colors.white),)
      ),
        body:  Container(
          child: productDb.when(
              data: (data){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.679
                      ),
                      itemBuilder: (context, index){
                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                Get.to(()=> DetailPage(data[index]), transition: Transition.leftToRight);
                              },
                              child: Card(
                                elevation: 2,

                                child: SizedBox(
                                  height: h*0.25,
                                  width: w*0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: CachedNetworkImage(
                                      placeholder: (c, s) => Center(child: const CircularProgressIndicator()),
                                      imageUrl: data[index].image, fit: BoxFit.fitWidth,),
                                  ),

                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Text(data[index].product_name, style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis,)),
                            Text("Rs ${data[index].price.toString()}", style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis,),
                          ],
                        );
                      }
                  ),
                );
              },
              error: (err, stack) => Center(child: Text('$err')),
              loading: () => const Center(child: CircularProgressIndicator())
          ),
        )
    );
  }
}
