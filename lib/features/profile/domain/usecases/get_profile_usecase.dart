import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ProfileEntity> call() async {
    return _repository.getProfile();
  }
}
