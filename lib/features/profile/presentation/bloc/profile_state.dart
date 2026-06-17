import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoadedState extends ProfileState {
  const ProfileLoadedState({required this.profile});
  final ProfileEntity profile;

  @override
  List<Object?> get props => [profile];
}

final class ProfileErrorState extends ProfileState {
  const ProfileErrorState({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
