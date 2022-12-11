
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_shop/views/dashboards/cart_page.dart';




//
// void showSnackBar(BuildContext context, String content, {String label = "Ok", int duration = 5}) {
//   final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
//   messenger.showSnackBar(
//     SnackBar(behavior: SnackBarBehavior.floating,
//       content: Text(content),
//       duration: Duration(seconds: duration),
//       action: SnackBarAction(label: label, onPressed: messenger.hideCurrentSnackBar),
//     ),
//   );
// }
//



class SnackShow{



  static showFailureSnack(BuildContext context, message){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(message)));
  }

   static showCommonSnack(BuildContext context, message, {bool? isADD, String? label,}){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        action: isADD == true ? SnackBarAction(label: label.toString(), onPressed: (){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Get.to(CartPage());
        }) : null,
        content: Text(message)));
  }


  static popIt(context){
    Navigator.of(context).pop();
  }

}