



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:get/get.dart';
import 'package:simple_shop/views/dashboards/order_history.dart';



class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(auth.user[0].username),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text(auth.user[0].email),
          ),

          ListTile(
            leading: Icon(Icons.history),
            title: Text("Order History"),
            onTap: (){
              Get.to(OrderHistory());
            },
          ),
          ListTile(
            onTap: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  elevation: 0,
                  title: Text('Log Out'),
                  actions: [
                    TextButton(
                        onPressed: (){
                          ref.read(authProvider.notifier).userLogOut();
                          Navigator.of(context).pop();
                        }, child: Text('Yes')),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text('No')),
                  ],
                );
              });
              },
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}