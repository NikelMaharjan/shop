



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_shop/colors.dart';
import 'package:simple_shop/models/cart_item.dart';
import 'package:simple_shop/models/user.dart';
import 'package:simple_shop/views/status_page.dart';

final boxA = Provider<List<User>>((ref) => []);   //boxA will be empty first
final boxB = Provider<List<CartItem>>((ref) => []);


void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xff4252B5)));
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());
  final userBox = await Hive.openBox<User>('user');
  final cartBox = await Hive.openBox<CartItem>('carts');

  runApp(ProviderScope(
    overrides: [
      boxA.overrideWithValue(userBox.values.toList().cast<User>()),  //when app runs, boxA will get values of userBox (added when logged in)
      boxB.overrideWithValue(cartBox.values.toList().cast<CartItem>())
    ],
      child: const Home()
  )
  );

}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: white,
          inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: blue,
          )
        ),
        appBarTheme: const AppBarTheme(
          color:  blue,
        )
      ),
      debugShowCheckedModeBanner: false,
        home: StatusPage()
    );
  }
}
