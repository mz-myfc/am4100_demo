// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ambient_temp": MessageLookupByLibrary.simpleMessage("环境温度"),
        "body_temp": MessageLookupByLibrary.simpleMessage("体温"),
        "calibration_complete":
            MessageLookupByLibrary.simpleMessage("校准完成，设备将自动关机"),
        "ear_temp": MessageLookupByLibrary.simpleMessage("耳温"),
        "ear_temp_mode": MessageLookupByLibrary.simpleMessage("耳温模式"),
        "exit_app": MessageLookupByLibrary.simpleMessage("再按一次退出APP。"),
        "forty_two_complete": MessageLookupByLibrary.simpleMessage("42℃已校准"),
        "forty_two_wait": MessageLookupByLibrary.simpleMessage("等待42℃校准"),
        "object_temp": MessageLookupByLibrary.simpleMessage("物体温度"),
        "object_temp_mode": MessageLookupByLibrary.simpleMessage("物温模式"),
        "status_one": MessageLookupByLibrary.simpleMessage("模块准备校正 S-1"),
        "status_three": MessageLookupByLibrary.simpleMessage("模块准备校正 S-3"),
        "status_two": MessageLookupByLibrary.simpleMessage("模块准备校正 S-2"),
        "temp_calibration": MessageLookupByLibrary.simpleMessage("温度校准"),
        "thirty_seven_complete": MessageLookupByLibrary.simpleMessage("37℃已校准"),
        "thirty_seven_wait": MessageLookupByLibrary.simpleMessage("等待37℃校准")
      };
}
