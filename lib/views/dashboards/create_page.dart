import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/colors.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/providers/crud_provider.dart';
import 'package:simple_shop/validation.dart';

import '../../providers/common_provider.dart';


class CreatePage extends ConsumerWidget with Validation {
   CreatePage ({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final detailController = TextEditingController();
  final priceController = TextEditingController();

  final _form = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context, ref) {

    final deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final devicewidth = MediaQuery.of(context).size.width;

;
    final image = ref.watch(imageProvider);
    final crud = ref.watch(crudProvider);


    ref.listen(crudProvider, (previous, next) {    //this is like stream. continuous watching. next is new state value
      if(next.err.isNotEmpty){
        SnackShow.showFailureSnack(context, next.err);

      }

      if(next.isSuccess){
        ref.read(indexProvider.notifier).change(0);
        nameController.clear();
        detailController.clear();
        priceController.clear();
      }


    });

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          //  backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: deviceheight * 0.33,
                color: blue,
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
                      height:  deviceheight * 0.612,
                      child: (
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                //  color: Colors.red,
                                height:  deviceheight * 0.55  ,
                                child: Form(
                                  key: _form,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 40.0),
                                        child: Text('Create Page',
                                          style: TextStyle(
                                              fontSize: 22, color: blue),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),

                                       _buildTextFormField(
                                          controller: nameController,
                                          labelText: 'Product Name',
                                          validator: validateUserName,
                                          suffixIcon: Icons.clear,
                                       ),

                                      _buildTextFormField(
                                         maxLines: 2,
                                          controller: detailController,
                                          labelText: 'Product Detail',
                                          validator: validateDescription,
                                          suffixIcon:  Icons.clear,
                                      ),

                                      _buildTextFormField(
                                          controller: priceController,
                                          isPrice: true,
                                          labelText: 'Price',
                                          validator: validatePrice,
                                          suffixIcon: Icons.clear,
                                      ),

                                       SizedBox(height: 10,),


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
                                              child: image != null ? Image.file(File(image.path)) : Center(child: Text("Select an Image", style: TextStyle(color: Colors.grey),))),
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
                                        backgroundColor: const Color(0xff4252B5),
                                        minimumSize: const Size(double.infinity, 0),
                                      ),
                                      onPressed:  crud .isLoad ? null : ()  async {
                                        _form.currentState!.save();
                                        if(_form.currentState!.validate()){

                                            if(image == null){
                                              showDialog(context: context, builder: (context){

                                                return AlertDialog(
                                                  content: Text("Image is required"),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, child: Text("Close"))
                                                  ],
                                                );

                                              });
                                            }

                                            else{


                                              await ref.read(crudProvider.notifier).productAdd(
                                                  image: image,
                                                  detail: detailController.text.trim(),
                                                  price: int.parse(priceController.text.trim()),
                                                  title: nameController.text.trim()
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
              Container(),

            ],
          )),
    );
  }

  Widget _buildTextFormField({ bool? isPrice, int? maxLines,  String? Function(String?)? validator, required IconData suffixIcon,  String? labelText, required TextEditingController controller}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: isPrice == true ? TextInputType.number : TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: validator,
            controller: controller,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                labelText: labelText,


                suffixIcon: IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: (){
                    controller.clear();
                  },

                  color: Colors.grey,

                )
            ),
          ),
        ),

      ],
    );
  }
}
