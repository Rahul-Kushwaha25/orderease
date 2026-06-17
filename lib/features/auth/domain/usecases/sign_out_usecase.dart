import '../repositories/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() async {
    return _repository.signOut();
  }
}
