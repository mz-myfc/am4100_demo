// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ear Temp`
  String get ear_temp {
    return Intl.message(
      'Ear Temp',
      name: 'ear_temp',
      desc: '',
      args: [],
    );
  }

  /// `Body Temp`
  String get body_temp {
    return Intl.message(
      'Body Temp',
      name: 'body_temp',
      desc: '',
      args: [],
    );
  }

  /// `Room Temp`
  String get ambient_temp {
    return Intl.message(
      'Room Temp',
      name: 'ambient_temp',
      desc: '',
      args: [],
    );
  }

  /// `Object Temp`
  String get object_temp {
    return Intl.message(
      'Object Temp',
      name: 'object_temp',
      desc: '',
      args: [],
    );
  }

  /// `Status S-1`
  String get status_one {
    return Intl.message(
      'Status S-1',
      name: 'status_one',
      desc: '',
      args: [],
    );
  }

  /// `Status S-2`
  String get status_two {
    return Intl.message(
      'Status S-2',
      name: 'status_two',
      desc: '',
      args: [],
    );
  }

  /// `Status S-3`
  String get status_three {
    return Intl.message(
      'Status S-3',
      name: 'status_three',
      desc: '',
      args: [],
    );
  }

  /// `Wait for 37°C calibration`
  String get thirty_seven_wait {
    return Intl.message(
      'Wait for 37°C calibration',
      name: 'thirty_seven_wait',
      desc: '',
      args: [],
    );
  }

  /// `Calibrated at 37°C`
  String get thirty_seven_complete {
    return Intl.message(
      'Calibrated at 37°C',
      name: 'thirty_seven_complete',
      desc: '',
      args: [],
    );
  }

  /// `Wait for 42°C calibration`
  String get forty_two_wait {
    return Intl.message(
      'Wait for 42°C calibration',
      name: 'forty_two_wait',
      desc: '',
      args: [],
    );
  }

  /// `Calibrated at 42°C`
  String get forty_two_complete {
    return Intl.message(
      'Calibrated at 42°C',
      name: 'forty_two_complete',
      desc: '',
      args: [],
    );
  }

  /// `Calibration Complete`
  String get calibration_complete {
    return Intl.message(
      'Calibration Complete',
      name: 'calibration_complete',
      desc: '',
      args: [],
    );
  }

  /// `Temp Calibration`
  String get temp_calibration {
    return Intl.message(
      'Temp Calibration',
      name: 'temp_calibration',
      desc: '',
      args: [],
    );
  }

  /// `Ear Temp Mode`
  String get ear_temp_mode {
    return Intl.message(
      'Ear Temp Mode',
      name: 'ear_temp_mode',
      desc: '',
      args: [],
    );
  }

  /// `Object Temp Mode`
  String get object_temp_mode {
    return Intl.message(
      'Object Temp Mode',
      name: 'object_temp_mode',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit the APP.`
  String get exit_app {
    return Intl.message(
      'Press again to exit the APP.',
      name: 'exit_app',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
