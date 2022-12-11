




import 'package:hive/hive.dart';
part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject{

  @HiveField(0)
  String title;

  @HiveField(1)
  String id;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  int price;

  @HiveField(5)
  int total;


  CartItem({
    required this.imageUrl,
    required this.id,
    required this.price,
    required this.title,
    required this.quantity,
    required this.total
  });


  factory CartItem.empty(){
    return CartItem(
        title: 'no-data',
        price: 0,
        id: '',
        imageUrl: '',
        quantity: 0,
        total: 0
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json){
    return CartItem(
        imageUrl: json['imageUrl'],
        id: json['id'],
        price: json['price'],
        title: json['title'],
        quantity: json['quantity'],
        total: json['total']
    );
  }


  Map<String, dynamic> toJson(){     //converting into map to send to server
    return {
      'imageUrl': this.imageUrl,
      'id': this.id,
      'price': this.price,
      'title': this.title,
      'quantity': this.quantity,
      'total': this.total
    };
  }

}