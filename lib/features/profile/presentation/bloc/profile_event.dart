import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

final class UpdateProfileEvent extends ProfileEvent {
  const UpdateProfileEvent({required this.profile});
  final ProfileEntity profile;

  @override
  List<Object?> get props => [profile];
}
