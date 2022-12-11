


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/colors.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/models/products.dart';
import 'package:simple_shop/providers/common_provider.dart';
import 'package:simple_shop/providers/crud_provider.dart';
import 'package:simple_shop/validation.dart';



class EditPage extends ConsumerStatefulWidget with Validation {
  final Product product;
  EditPage(this.product, {Key? key}) : super(key: key);


  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {

  final _form = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  @override
  void initState() {
    titleController..text = widget.product.product_name;
    detailController..text = widget.product.product_detail;
    priceController..text = widget.product.price.toString();
    super.initState();
  }





  @override
  Widget build(BuildContext context) {

    final deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final devicewidth = MediaQuery.of(context).size.width;

    final image = ref.watch(imageProvider);
    final crud = ref.watch(crudProvider);


    ref.listen(crudProvider, (previous, next) {    //this is like stream. continuous watching. next is new state value
      if(next.err.isNotEmpty){
        SnackShow.showFailureSnack(context, next.err);
      }

      else if (next.isSuccess){
        Navigator.of(context).pop();

      }


    });

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          //  backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: deviceheight * 0.33,
                    color: const Color(0xff4252B5),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Image.asset(
                            'assets/images/shop.png',
                            height: deviceheight * 0.1,
                          ),
                        )),
                  ),


                ],
              ),

              Positioned(
                  right: devicewidth * 0.08,
                  left: devicewidth * 0.08,
                  top: deviceheight * 0.21,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: SizedBox(
                      //  color: Colors.red,
                      height:   deviceheight * 0.612,
                      child: (
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                //  color: Colors.red,
                                height: deviceheight * 0.55  ,
                                child: Form(
                                  key: _form,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 40.0),
                                        child: Text("Edit Post",
                                          style: TextStyle(
                                              fontSize: 22, color: blue),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      _buildTextFormField(
                                        controller: titleController,
                                        hintText: 'Name',
                                        validator: widget.validateTile,
                                      ),

                                      _buildTextFormField(
                                        maxLines: 3,
                                        controller: detailController,
                                        hintText: 'detail',
                                        validator: widget.validateDescription,
                                      ),

                                      _buildTextFormField(
                                        controller: priceController,
                                        hintText: 'price',
                                        validator: widget.validatePrice,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),



                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            //color: Colors.green,

                                              border: Border.all(color: Colors.grey)
                                          ),
                                          //   height: deviceheight * 0.15,

                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white
                                              ),
                                              onPressed: (){
                                                showDialog(context: context, builder: (context){
                                                  return AlertDialog(
                                                    title: Text('choose option'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                            ref.read(imageProvider.notifier).pickAnImage(true);
                                                          }, child: Text('camera')),
                                                      TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                            ref.read(imageProvider.notifier).pickAnImage(false);
                                                          }, child: Text('gallery')),
                                                    ],
                                                  );
                                                });
                                              },
                                              child: image != null ? Image.file(File(image.path)) : Image.network(widget.product.image)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),



                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(
                                                  15)), // <-- Radius
                                        ),
                                        backgroundColor: blue,
                                        minimumSize: const Size(double.infinity, 0),
                                      ),
                                      onPressed:  crud.isLoad ? null : ()  async {
                                        _form.currentState!.save();
                                        if(_form.currentState!.validate()){


                                          if(image == null){
                                            ref.read(crudProvider.notifier).updateProduct(

                                                title: titleController.text.trim(),
                                                detail: detailController.text.trim(),
                                                id: widget.product.id,
                                                price: int.parse(priceController.text.trim()),
                                            );
                                          }

                                          else{

                                            ref.read(crudProvider.notifier).updateProduct(
                                              title: titleController.text.trim(),
                                              detail: detailController.text.trim(),
                                              image: image,
                                              id: widget.product.id,
                                              imageId: widget.product.imageId,
                                              price: int.parse(priceController.text.trim()),

                                            );

                                          }

                                        }






                                      },
                                      child: crud.isLoad ? CircularProgressIndicator() : const Text("Submit")))
                            ],
                          )
                      ),
                    ),
                  )),



            ],
          )),
    );
  }

  Widget _buildTextFormField({  String? Function(String?)? validator, int? maxLines,  required String hintText, required TextEditingController controller}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            maxLines: maxLines ?? 1,
            textInputAction: TextInputAction.next,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              labelText: hintText,

              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintText: hintText,

            ),
          ),
        ),


      ],
    );
  }

}
