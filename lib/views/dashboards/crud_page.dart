

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/providers/crud_provider.dart';
import 'package:simple_shop/services/crud_services.dart';
import 'package:get/get.dart';
import 'package:simple_shop/views/dashboards/edit_page.dart';



class CrudPage extends ConsumerWidget {

  const CrudPage({Key? key}) : super(key: key);


  

  @override
  Widget build(BuildContext context, ref) {

    final productDb = ref.watch(productData1);
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize"),
        elevation: 0,
      ),
      body: Container(
        child: productDb.when(
            data: (data){
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ListTile(
                          leading:Card(child: CachedNetworkImage(imageUrl: data[index].image, width: 80)),
                          title: Text(data[index].product_name,),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(onPressed: (){
                                  Get.to(EditPage(data[index]), transition: Transition.leftToRight);
                                }, icon: Icon(Icons.edit)),
                                IconButton(onPressed: ()  {

                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      elevation: 0,
                                      title: Text('Delete'),
                                      actions: [
                                        TextButton(
                                            onPressed: () async{
                                              Navigator.pop(context);

                                              await ref.read(crudProvider.notifier).removeProduct(imageId: data[index].imageId, id: data[index].id);

                                            }, child: Text('Yes')),
                                        TextButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text('No')),
                                      ],
                                    );
                                  });


                                }, icon: Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
            },
            error: (err, stack) => Center(child: Text('$err')),
            loading: () => Center(child: CircularProgressIndicator())
        ),
      ),
    );
  }
}