import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/lib/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/lib/state/posts/typedefs/user_id.dart';

final userIdProvider = Provider<UserId?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.userId;
});