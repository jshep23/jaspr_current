// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:example/components/counter.dart' as _counter;
import 'package:example/components/header.dart' as _header;
import 'package:example/constants/theme.dart' as _theme;
import 'package:example/pages/about.dart' as _about;
import 'package:example/app.dart' as _app;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _app.App: ClientTarget<_app.App>('app'),
    _about.About: ClientTarget<_about.About>('about'),
  },
  styles: () => [
    ..._theme.styles,
    ..._app.App.styles,
    ..._counter.CounterState.styles,
    ..._header.Header.styles,
    ..._about.About.styles,
  ],
);
