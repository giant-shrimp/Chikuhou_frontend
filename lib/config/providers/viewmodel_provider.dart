import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../viewmodels/auth/sign_in_viewmodel.dart';
import '../../viewmodels/auth/sign_up_viewmodel.dart';
import '../../viewmodels/settings/password_settings_viewmodel.dart';
import 'auth_provider.dart';

/// サインインViewModelのプロバイダー
final signInViewModelProvider = ChangeNotifierProvider<SignInViewModel>(
      (ref) {
    final authService = ref.read(authServiceProvider);
    return SignInViewModel(authService);
  },
);

/// サインアップViewModelのプロバイダー
final signUpViewModelProvider = ChangeNotifierProvider<SignUpViewModel>(
      (ref) {
    final authService = ref.read(authServiceProvider);
    return SignUpViewModel(authService);
  },
);

/// パスワード変更ViewModelのプロバイダー
final passwordSettingsViewModelProvider = ChangeNotifierProvider<PasswordSettingsViewModel>(
    (ref) {
    final authService = ref.read(authServiceProvider);
    return PasswordSettingsViewModel(authService);
  },
);
