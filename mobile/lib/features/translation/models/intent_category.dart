import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


/// Intent translation categories
enum IntentCategory {
  @JsonValue('greeting')
  greeting,
  @JsonValue('daily')
  daily,
  @JsonValue('business')
  business,
  @JsonValue('emotion')
  emotion,
  @JsonValue('request')
  request;

  String get displayName {
    switch (this) {
      case IntentCategory.greeting:
        return '謖ｨ諡ｶ';
      case IntentCategory.daily:
        return '譌･蟶ｸ';
      case IntentCategory.business:
        return '繝薙ず繝阪せ';
      case IntentCategory.emotion:
        return '諢滓ュ';
      case IntentCategory.request:
        return '萓晞ｼ';
    }
  }

  IconData get icon {
    switch (this) {
      case IntentCategory.greeting:
        return Icons.waving_hand;
      case IntentCategory.daily:
        return Icons.home;
      case IntentCategory.business:
        return Icons.work;
      case IntentCategory.emotion:
        return Icons.emoji_emotions;
      case IntentCategory.request:
        return Icons.handshake;
    }
  }

  String get value {
    switch (this) {
      case IntentCategory.greeting:
        return 'greeting';
      case IntentCategory.daily:
        return 'daily';
      case IntentCategory.business:
        return 'business';
      case IntentCategory.emotion:
        return 'emotion';
      case IntentCategory.request:
        return 'request';
    }
  }
}

