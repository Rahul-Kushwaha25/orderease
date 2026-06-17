import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    return _dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }
}
