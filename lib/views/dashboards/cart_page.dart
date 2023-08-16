import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/providers/cart_provider.dart';
import 'package:simple_shop/providers/common_provider.dart';
import 'package:simple_shop/providers/order_provider.dart';
import 'package:get/get.dart';
import 'package:simple_shop/views/dashboards/order_history.dart';

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final cartData = ref.watch(cartProvider);
    final totalData = ref.watch(cartProvider.notifier).total;
    final auth = ref.watch(authProvider);
    final isLoad = ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cartData.isEmpty ?  const Center(child: Text("Empty! Add Items to Cart", style: TextStyle(color: Colors.grey),),) :  Column(
          children: [
            Expanded(
              child:   ListView.builder(
                physics: const BouncingScrollPhysics(),
                  itemCount: cartData.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Card(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),

                            height: 120,
                            child: Row(
                              children: [
                                Image.network(cartData[index].imageUrl, width: 160,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(cartData[index].title, style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18 ),),
                                      Container(
                                          margin: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('Rs.${cartData[index].price}', style: const TextStyle(fontSize: 12),)),
                                      Row(
                                        children: [
                                          OutlinedButton(
                                              onPressed: () {
                                                ref.read(cartProvider.notifier).singleAddtoCart(cartData[index]);
                                                },
                                              child: const Icon(Icons.add, color: blue,)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Text('${cartData[index].quantity}'),
                                          ),
                                          OutlinedButton(
                                              onPressed: () {
                                                ref.read(cartProvider.notifier).singleRemoveCart(cartData[index]);
                                              },
                                              child: const Icon(Icons.remove, color: blue,))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(icon: const Icon(Icons.clear, color: blue,), onPressed: (){
                                ref.read(cartProvider.notifier).Remove(cartData[index]);
                              },),
                            )),
                      ],
                    );
                  }),
            ),
             Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Total'), Text('Rs. $totalData')],
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: blue),
                    onPressed: isLoad ? null : () async {
                      ref.read(loadingProvider.notifier).toggle();
                      final response =  await ref.read(orderProvider).createOrder(
                          totalData,
                          DateTime.now().toString(),
                          cartData,
                          auth.user[0].id,
                          auth.user[0].token,

                      );
                      ref.read(loadingProvider.notifier).toggle();


                      if(response !='success'){

                       SnackShow.showCommonSnack(context, response);


                     }
                     else{
                       ref.read(cartProvider.notifier).clear();
                       Get.to(OrderHistory());
                     }


                    },
                    child: isLoad ? const Text("Please wait") : const Text('Check Out'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
