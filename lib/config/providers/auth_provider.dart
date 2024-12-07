import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/services/auth_service.dart';

/// 認証サービスのプロバイダー
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
