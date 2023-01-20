import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_shop/services/auth_services.dart';
import '../models/auth_state.dart';
import '../models/user.dart';
import '../views/main.dart';




final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {

  return AuthProvider(AuthState(user: ref.watch(boxA), err: '', isLoad: false, isSuccess: false));

});

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(super.state);

  Future<void> userSignUp({required String email, required String password, required String username}) async {

    state = state.copyWith( isLoad: true, err: '' , isSuccess:  false);
    final response = await AuthService.userSignUp(email: email, password: password, username: username);

    response.fold((l) {
      state = state.copyWith(isLoad: false, err: l, isSuccess: false);
    }, (r) {
      state = state.copyWith( isLoad: false, err: '', user: [] , isSuccess: true);
    });
  }



  Future<void> userLogin({required String email,required String password}) async {
    state = state.copyWith(isLoad: true, err: '', isSuccess: false);
    final response = await AuthService.userLogin(email: email, password: password);

    response.fold((l) {
      state = state.copyWith(isLoad: false, err: l);
    }, (r) {
      Hive.box<User>('user').add(r);   //added to userBox. boxA will get the value. so user will not be empty
      state = state.copyWith(isLoad: false, err: '', user: [r]);  //added to List<User> so user will not be empty..we do this to test realtime. by using hive only, no realtime
    });
  }



  void userLogOut() async {
    Hive.box<User>('user').clear();
    state = state.copyWith(isLoad: false, err: '', user: []);
  }





}