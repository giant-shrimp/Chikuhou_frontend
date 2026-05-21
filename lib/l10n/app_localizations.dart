import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko')
  ];

  /// No description provided for @menu.
  ///
  /// In ja, this message translates to:
  /// **'メニュー'**
  String get menu;

  /// No description provided for @home.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get home;

  /// No description provided for @language.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get language;

  /// No description provided for @use_language.
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get use_language;

  /// No description provided for @account_information.
  ///
  /// In ja, this message translates to:
  /// **'アカウント情報'**
  String get account_information;

  /// No description provided for @username.
  ///
  /// In ja, this message translates to:
  /// **'ユーザー名'**
  String get username;

  /// No description provided for @email.
  ///
  /// In ja, this message translates to:
  /// **'メール'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In ja, this message translates to:
  /// **'電話番号'**
  String get phone;

  /// No description provided for @settings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @status.
  ///
  /// In ja, this message translates to:
  /// **'ステータス'**
  String get status;

  /// No description provided for @status_small.
  ///
  /// In ja, this message translates to:
  /// **'ステータス'**
  String get status_small;

  /// No description provided for @gradient.
  ///
  /// In ja, this message translates to:
  /// **'勾配計算'**
  String get gradient;

  /// No description provided for @gradient_calculation.
  ///
  /// In ja, this message translates to:
  /// **'勾配計算'**
  String get gradient_calculation;

  /// No description provided for @sub.
  ///
  /// In ja, this message translates to:
  /// **'サブ機能'**
  String get sub;

  /// No description provided for @sub_extension.
  ///
  /// In ja, this message translates to:
  /// **'サブ機能拡張'**
  String get sub_extension;

  /// No description provided for @rain_cloud_radar.
  ///
  /// In ja, this message translates to:
  /// **'雨雲レーダー'**
  String get rain_cloud_radar;

  /// No description provided for @marathon_course.
  ///
  /// In ja, this message translates to:
  /// **'マラソンコース'**
  String get marathon_course;

  /// No description provided for @calorie_count.
  ///
  /// In ja, this message translates to:
  /// **'カロリー計算'**
  String get calorie_count;

  /// No description provided for @faq.
  ///
  /// In ja, this message translates to:
  /// **'よくある質問'**
  String get faq;

  /// No description provided for @app_version.
  ///
  /// In ja, this message translates to:
  /// **'アプリのバージョン'**
  String get app_version;

  /// No description provided for @swap.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを切り替える'**
  String get swap;

  /// No description provided for @sign_out.
  ///
  /// In ja, this message translates to:
  /// **'サインアウト'**
  String get sign_out;

  /// No description provided for @sign_out_confirmation.
  ///
  /// In ja, this message translates to:
  /// **'サインアウト確認'**
  String get sign_out_confirmation;

  /// No description provided for @are_you_sure_sign_out.
  ///
  /// In ja, this message translates to:
  /// **'本当にサインアウトしますか？'**
  String get are_you_sure_sign_out;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @sign_in.
  ///
  /// In ja, this message translates to:
  /// **'サインイン'**
  String get sign_in;

  /// No description provided for @sign_in_error.
  ///
  /// In ja, this message translates to:
  /// **'メールまたはパスワードが\n正しくありません。\n入力し直してください。'**
  String get sign_in_error;

  /// No description provided for @ok.
  ///
  /// In ja, this message translates to:
  /// **'了解'**
  String get ok;

  /// No description provided for @password.
  ///
  /// In ja, this message translates to:
  /// **'パスワード'**
  String get password;

  /// No description provided for @password_confirmation.
  ///
  /// In ja, this message translates to:
  /// **'パスワード 確認'**
  String get password_confirmation;

  /// No description provided for @current_password.
  ///
  /// In ja, this message translates to:
  /// **'現在のパスワード'**
  String get current_password;

  /// No description provided for @new_password.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワード'**
  String get new_password;

  /// No description provided for @new_password_confirmation.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワード 確認'**
  String get new_password_confirmation;

  /// No description provided for @change_password.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを変更'**
  String get change_password;

  /// No description provided for @change_password_success.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを変更しました。'**
  String get change_password_success;

  /// No description provided for @change_password_error.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを\n変更できませんでした。\n入力し直してください。'**
  String get change_password_error;

  /// No description provided for @sign_up.
  ///
  /// In ja, this message translates to:
  /// **'新規登録'**
  String get sign_up;

  /// No description provided for @sign_up_error.
  ///
  /// In ja, this message translates to:
  /// **'パスワードが\n正しくありません。\n入力し直してください。'**
  String get sign_up_error;

  /// No description provided for @multiple_route_search.
  ///
  /// In ja, this message translates to:
  /// **'複数ルート検索'**
  String get multiple_route_search;

  /// No description provided for @route_search.
  ///
  /// In ja, this message translates to:
  /// **'ルート検索'**
  String get route_search;

  /// No description provided for @number_of_routes_being_acquired.
  ///
  /// In ja, this message translates to:
  /// **'取得中のルート数'**
  String get number_of_routes_being_acquired;

  /// No description provided for @departure_point.
  ///
  /// In ja, this message translates to:
  /// **'出発地'**
  String get departure_point;

  /// No description provided for @destination.
  ///
  /// In ja, this message translates to:
  /// **'目的地'**
  String get destination;

  /// No description provided for @simple_gradient_calculation.
  ///
  /// In ja, this message translates to:
  /// **'単純勾配計算'**
  String get simple_gradient_calculation;

  /// No description provided for @quadrature_by_pieces.
  ///
  /// In ja, this message translates to:
  /// **'区分求積法'**
  String get quadrature_by_pieces;

  /// No description provided for @linear_calculations.
  ///
  /// In ja, this message translates to:
  /// **'線形計算'**
  String get linear_calculations;

  /// No description provided for @vector_product.
  ///
  /// In ja, this message translates to:
  /// **'ベクトル積'**
  String get vector_product;

  /// No description provided for @taylor_expansion.
  ///
  /// In ja, this message translates to:
  /// **'テイラー展開'**
  String get taylor_expansion;

  /// No description provided for @simpson_act.
  ///
  /// In ja, this message translates to:
  /// **'シンプソン法'**
  String get simpson_act;

  /// No description provided for @fourier_transform.
  ///
  /// In ja, this message translates to:
  /// **'フーリエ変換'**
  String get fourier_transform;

  /// No description provided for @helmholtz_decomposition.
  ///
  /// In ja, this message translates to:
  /// **'ヘルムホルツ分解'**
  String get helmholtz_decomposition;

  /// No description provided for @riemannian_metric.
  ///
  /// In ja, this message translates to:
  /// **'リーマン計量'**
  String get riemannian_metric;

  /// No description provided for @formula.
  ///
  /// In ja, this message translates to:
  /// **'数式'**
  String get formula;

  /// No description provided for @overview.
  ///
  /// In ja, this message translates to:
  /// **'概要'**
  String get overview;

  /// No description provided for @compatible_types.
  ///
  /// In ja, this message translates to:
  /// **'相性の良いタイプ'**
  String get compatible_types;

  /// No description provided for @advantages.
  ///
  /// In ja, this message translates to:
  /// **'メリット'**
  String get advantages;

  /// No description provided for @disadvantages.
  ///
  /// In ja, this message translates to:
  /// **'デメリット'**
  String get disadvantages;

  /// No description provided for @confirm.
  ///
  /// In ja, this message translates to:
  /// **'決定'**
  String get confirm;

  /// No description provided for @walker.
  ///
  /// In ja, this message translates to:
  /// **'ウォーカー'**
  String get walker;

  /// No description provided for @runner.
  ///
  /// In ja, this message translates to:
  /// **'ランナー'**
  String get runner;

  /// No description provided for @senior.
  ///
  /// In ja, this message translates to:
  /// **'シニア'**
  String get senior;

  /// No description provided for @bike.
  ///
  /// In ja, this message translates to:
  /// **'自転車'**
  String get bike;

  /// No description provided for @wheelchair.
  ///
  /// In ja, this message translates to:
  /// **'車イス'**
  String get wheelchair;

  /// No description provided for @stroller.
  ///
  /// In ja, this message translates to:
  /// **'ベビーカー'**
  String get stroller;

  /// No description provided for @traveler.
  ///
  /// In ja, this message translates to:
  /// **'トラベラー'**
  String get traveler;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
