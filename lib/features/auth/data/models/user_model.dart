import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.appMetadata,
    required super.userMetadata,
    required super.aud,
    required super.createdAt,
  });

  factory UserModel.fromUser(User user) => UserModel(
      id: user.id,
      appMetadata: user.appMetadata,
      userMetadata: user.userMetadata,
      aud: user.aud,
      createdAt: user.createdAt);
}
