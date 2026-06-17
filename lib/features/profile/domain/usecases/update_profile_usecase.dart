import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<void> call(ProfileEntity profile) async {
    return _repository.updateProfile(profile);
  }
}
