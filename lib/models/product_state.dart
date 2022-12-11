


class ProductState{

  final bool isLoad;
  final bool isSuccess;
  final String err;

  ProductState({required this.isSuccess, required this.err, required this.isLoad});

  ProductState.initState(): isLoad=false, err='', isSuccess=false;

  ProductState copyWith({bool? isLoad, String? err, bool? isSuccess }){
    return ProductState(
        err:  err ?? this.err,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess
    );
  }



}