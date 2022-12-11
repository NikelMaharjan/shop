





import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/services/crud_services.dart';
import '../models/product_state.dart';



final crudProvider = StateNotifierProvider.autoDispose<CrudProvider, ProductState>((ref) => CrudProvider(ProductState.initState(), ref));

class CrudProvider extends StateNotifier<ProductState> {

  final StateNotifierProviderRef ref;
  CrudProvider(super.state, this.ref);


  Future<void> productAdd({required String title, required String detail, required XFile image, required int price }) async {

    final auth = ref.watch(authProvider);   //to get token
    state = state.copyWith( isLoad: true, err: '', isSuccess: false);
    final response = await CrudService.addProduct(title: title, detail: detail, price: price, image: image, token:auth.user[0].token);
    response.fold((l) {
      state = state.copyWith( isLoad: false, err: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, err: '', isSuccess: r);
    });
  }

  Future<void> updateProduct(
      {
        required String title,
        required String detail,
        XFile? image,
        String? imageId,
        required String id,
        required int price,
      }) async {
    final auth = ref.watch(authProvider);
    state = state.copyWith(isLoad: true, err: '', isSuccess: false);
    final response = await CrudService.updateProduct(title: title, detail: detail, id: id, price: price, token: auth.user[0].token, image: image, imageId: imageId);
    response.fold((l) {
      state = state.copyWith( isLoad: false, err: l);
    }, (r) {
      ref.refresh(productData1);
      state = state.copyWith(isLoad: false, err: '', isSuccess: r);
    });
  }



  Future<void> removeProduct(
      {
        required String imageId,
        required String id,
      }) async {
    final auth = ref.watch(authProvider);
    state = state.copyWith(isLoad: true, err: '', isSuccess: false);
    final response = await CrudService.removeProduct(id: id, imageId: imageId, token: auth.user[0].token);
    response.fold((l) {
      state = state.copyWith( isLoad: false, err: l);
    }, (r) {
      ref.refresh(productData1);
      state = state.copyWith(isLoad: false, err: '', isSuccess: r);
    });
  }








}