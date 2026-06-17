import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await getProfileUseCase();
      emit(ProfileLoadedState(profile: profile));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      await updateProfileUseCase(event.profile);
      emit(ProfileLoadedState(profile: event.profile));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }
}
