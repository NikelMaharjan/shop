


class Product{
  final  String id;
  final  String imageId;
  final  String product_name;
  final  String product_detail;
  final  int price;
  final  String image;


  Product({
    required this.id,
    required this.imageId,
    required this.price,
    required this.product_detail,
    required this.product_name,
    required this.image
  });


  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
        id: json['_id'],
        imageId: json['public_id'],
        price: json['price'],
        product_detail: json['product_detail'],
        product_name: json['product_name'],
        image: json['image']
    );
  }
}
