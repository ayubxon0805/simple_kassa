import 'package:flutter_application_5/service/ordering_products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'addptocard_event.dart';
part 'addptocard_state.dart';

class AddptocardBloc extends Bloc<AddptocardEvent, AddptocardState> {
  AddptocardBloc() : super(AddptocardInitial()) {
    on<AddPtoCardEvent>(addHive);
  }
  Future<void> addHive(
    AddPtoCardEvent event,
    Emitter<AddptocardState> emit,
  ) async {
    bool isAdded = false;
    isAdded = OrderedSingelton.addmyBox();
    if (isAdded == true) {
      emit(AddtoHivedState());
    } else {}
  }
}
