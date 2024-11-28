import 'package:bloc_test/bloc/role_bloc/role.state.dart';
import 'package:bloc_test/bloc/role_bloc/role_event.dart';
import 'package:bloc_test/data/role/role_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(RoleInitialState()) {
    on<RoleAssignRoleEvent>((event, emit) async {
      try {
        emit(RoleLoadingState());
        final roleModel = await RoleRepository().getRoleFromFirebase();
        emit(RoleAssignRoleSuccessState(roleModel: roleModel));
      } catch (e) {
        emit(RoleAssignRoleFailedState());
      }
    });

    on<RoleChangeRoleEvent>((event, emit) {});
  }
}
