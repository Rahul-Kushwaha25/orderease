import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl];
}
