# Localization (l10n)

This directory contains internationalization and localization files.

## Structure

- ARB files for different languages
- Generated localization code

## Supported Languages

- English (en)
- Japanese (ja)

## Usage

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In widget
Text(AppLocalizations.of(context)!.helloWorld)
```
