
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/providers/order_provider.dart';
import 'package:intl/intl.dart';






class OrderHistory extends ConsumerWidget {


  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    final order = ref.watch(orderHistory(auth.user[0].id));
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        elevation: 0,
      ),
        body:  order.when(
            data: (data){
              return data.isEmpty ? Center(child: Text("No Orders"),) : ListView.builder(
                physics: BouncingScrollPhysics(),
                  itemCount:  data.length,
                  itemBuilder: (context, index){

                    final date = DateTime.parse(data[index].dateTime);
                    final  formatDate = DateFormat("dd/MM/yyyy hh:mm").format(date);
                    return ExpansionTile(
                      iconColor: Colors.blue,
                      textColor: Colors.blue,
                      title: Text(formatDate),
                      children: data[index].products.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Card(child: Image.network(e.imageUrl, height: 200, width: 200,)),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(e.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                                        Text('Quantity ${e.quantity}'),
                                        Text('price: Rs.${e.price}'),
                                      ],
                                    ),

                                  )
                                ],
                              ),
                              if(data[index].products.indexOf(data[index].products.last) == data[index].products.indexOf(e)) Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Text('Total ', style: TextStyle(fontWeight: FontWeight.w600),),
                                    Text('${data[index].amount}'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),

                    );
                  }
              );
            },
            error: (err, stack) => Center(child: Text('$err')),
            loading: () => Center(child: CircularProgressIndicator())
        )
    );
  }
}