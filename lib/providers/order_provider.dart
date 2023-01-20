import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_shop/api.dart';
import 'package:simple_shop/constants/api.dart';
import 'package:simple_shop/exceptions/api_exceptions.dart';
import '../models/cart_item.dart';
import '../models/order.dart';



final orderHistory = FutureProvider.family.autoDispose((ref, String id) => OrderProviders.getOrder(id));
final orderProvider = Provider((ref) => OrderProviders());

class OrderProviders{

  static final dio = Dio();
  static Future<List<Order>> getOrder(String id) async{
    try{
      final response = await dio.get('${Api.orderHistory}/$id');
      return (response.data as List).map((e) => Order.fromJson(e)).toList();
    } on DioError catch (err){
      throw DioException.fromDioError(err).errorMessage;
    }

  }


  Future<String> createOrder(int amount,String dateTime,List<CartItem> products,String userId, String token) async{
    try{
      final response = await dio.post(Api.orderCreate, data: {
        'amount': amount,
        'dateTime': dateTime,
        'products':products.map((e) => e.toJson()).toList(),   //converting into map to send in server
        'userId': userId
      },options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }
      ));
      return 'success';
    } on DioError catch (err){
      return DioException.fromDioError(err).errorMessage;
    }

  }

}