
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/validation.dart';

import '../../common/show_snack.dart';
import '../../providers/auth_provider.dart';
import '../../providers/form_validation_provider.dart';
import 'package:get/get.dart';



class SignUpPage extends ConsumerStatefulWidget with Validation {
   SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {

  final nameController = TextEditingController();
  final passController = TextEditingController();
  final mailController = TextEditingController();

  final _form = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context, ) {

    final deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final devicewidth = MediaQuery.of(context).size.width;

    final isVisible = ref.watch(validateProvider);
    final auth = ref.watch(authProvider);


    ref.listen(authProvider, (previous, next) {    //this is like stream. continuous watching. next is new state value
      if(next.err.isNotEmpty){
        SnackShow.showFailureSnack(context, next.err);
      }

      else if (next.isSuccess){
        Get.back();
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
                color: const Color(0xff4252B5),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Image.asset(
                        'assets/images/shop.png',
                        height: deviceheight * 0.08,
                      ),
                    )),
              ),
              Positioned(
                  right: devicewidth * 0.08,
                  left: devicewidth * 0.08,
                  top: deviceheight * 0.22,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: SizedBox(
                      //  color: Colors.red,
                      height:  deviceheight * 0.56,
                      child: (
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                //  color: Colors.red,
                                height:  deviceheight * 0.49,
                                child: Form(
                                  key: _form,
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 60.0),
                                        child: Text('SignUp',
                                          style: TextStyle(
                                              fontSize: 22, color: Color(0xff4252B5)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),


                                      _buildTextFormField(
                                          obscureText: false,
                                          controller: nameController,
                                          hintText: 'Name',
                                          validator: widget.validateUserName,
                                          prefixIcon: CupertinoIcons.person),


                                      _buildTextFormField(
                                          obscureText: false,
                                          controller: mailController,
                                          hintText: 'Email',
                                          validator: widget.validateEmail,
                                          prefixIcon: CupertinoIcons.mail),

                                      _buildTextFormField(
                                          onTap: (){
                                            ref.read(validateProvider.notifier).visible();
                                          },
                                          controller:  passController,
                                          hintText: "Password",
                                          validator: widget.validatePassword,
                                          obscureText: isVisible,
                                          prefixIcon: CupertinoIcons.padlock,
                                          suffixIcon: isVisible ? Icons.visibility_off : Icons.visibility
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
                                      onPressed:  auth.isLoad ? null : ()  async {
                                        _form.currentState!.save();
                                        if(_form.currentState!.validate()){

                                          await  ref.read(authProvider.notifier).userSignUp(
                                            email: mailController.text.trim(),
                                            password: passController.text.trim(),
                                            username: nameController.text.trim(),
                                          );





                                        }




                                      },

                                      child: auth.isLoad ? const CircularProgressIndicator() : const Text("Submit")))
                            ],
                          )
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text( 'Already Have an account',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {


                              Get.back();


                            },
                            child:  const Text(
                              "Login" ,
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ),
                  )),
            ],
          )),
    );
  }

  Widget _buildTextFormField({required IconData prefixIcon, required bool obscureText,  VoidCallback? onTap, String? Function(String?)? validator, IconData? suffixIcon,  required String hintText, required TextEditingController controller}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            validator: validator,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: hintText,
                prefixIcon: Icon(
                  prefixIcon,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: onTap,
                  color: Colors.black,

                )
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}




