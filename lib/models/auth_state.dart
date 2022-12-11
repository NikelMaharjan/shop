import 'package:simple_shop/models/user.dart';





class AuthState{
  final bool isLoad;
  final String err;
  final bool isSuccess;
  final List<User> user;    //here user will be only one but use List here instead of User user to check user is empty or not in status page


  AuthState({
    required this.user,
    required this.err,
    required this.isLoad,
    required this.isSuccess,
  });

  //AuthState.intiState(): user= User.empty() , isLoad=false, err='';

  AuthState copyWith({bool? isLoad, String? err, List<User>? user, bool? isSuccess }){
    return AuthState(
        err:  err ?? this.err,
        isLoad: isLoad ?? this.isLoad,
        user: user ?? this.user,
        isSuccess: isSuccess ?? this.isSuccess
    );
  }


}