<h1 align="center">This package is still in development! Stay tuned for updates as I work towards a stable release.</h1>

<p align="center">
  <a href="https://pub.dev/packages/current">
    <img src="https://raw.githubusercontent.com/jshep23/jaspr_current/main/images/CurrentLogoSM.png" alt="Current Logo" />
  </a>
</p>

<h1 align="center">Jaspr Current</h1>
<h3 align="center">A simple, lightweight state management library for Jaspr</h3>

## Features

- Typed reactive properties for primitives, nullable values, lists, and maps.
- View-model-driven components with `CurrentComponent` and `CurrentState`.
- Application-wide shared state with `Current`.
- Issue-based validation that keeps localization in the component layer.
- Built-in busy state, change notifications, and event listeners for async flows.

## Getting Started

In your Jaspr project, add the dependency to your `pubspec.yaml`.

```yaml
dependencies:
  jaspr_current: ^0.0.0
```

## Quick Start

A small counter is still the fastest way to see the core pattern: keep state in a `CurrentViewModel`, list reactive properties in `currentProps`, and render that view model through a `CurrentComponent`.

### counter_view_model.dart

```dart
import 'package:jaspr_current/jaspr_current.dart';

class CounterViewModel extends CurrentViewModel {
  final count = CurrentProperty.integer();

  void incrementCounter() {
    count.value += 1;
  }

  void decrementCounter() {
    count.value -= 1;
  }

  @override
  Iterable<CurrentProperty> get currentProps => [count];
}
```

### counter_page.dart

```dart
import 'package:jaspr_current/jaspr_current.dart';
import 'package:jaspr/jaspr.dart';

class CounterPage extends CurrentComponent<CounterViewModel> {
  const CounterPage({super.key, required super.viewModel});

  @override
  CurrentState<CounterPage, CounterViewModel> createCurrent() {
    return _CounterPageState(viewModel);
  }
}

class _CounterPageState extends CurrentState<CounterPage, CounterViewModel> {
  _CounterPageState(super.viewModel);

  @override
  Component build(BuildContext context) {
    return div([
      div(classes: 'counter', [
        button(
          onClick: viewModel.decrementCounter,
          [.text('-')],
        ),
        span([.text('${viewModel.count}')]),
        button(
          onClick: viewModel.incrementCounter,
          [.text('+')],
        ),
      ]),
    ]);
  }
}
```

### main.dart

```dart
import 'package:jaspr/jaspr.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessComponent {
  const MyApp({super.key});

  @override
  Component build(BuildContext context) {
    return Document(
      title: 'Current State Example',
      body: CounterPage(
        viewModel: CounterViewModel(),
      ),
    );
  }
}
```

This keeps business logic out of the component tree without introducing a second state object. When any property in `currentProps` changes, the matching `CurrentState` rebuilds automatically.

## Contributing

This is an open source project, and contributions are welcome. Please feel free to [create a new issue](https://github.com/jshep23/jaspr_current/issues/new/choose) if you encounter any problems, or [submit a pull request](https://github.com/jshep23/jaspr_current/pulls). For community contribution guidelines, please review the [Code of Conduct](CODE_OF_CONDUCT.md).

If submitting a pull request, please ensure the following standards are met:

1. Code files must be well formatted with `dart format .`.
2. Tests must pass with `flutter test`. New test cases to validate your changes are highly recommended.
3. Implementations must not add unnecessary project dependencies.
4. Project must contain zero warnings. Running `flutter analyze` must return zero issues.
5. Keep docstrings and README guidance up to date when public APIs change.

## Additional information

This package has **ZERO** third-party package dependencies. The [current_core](https://pub.dev/packages/current_core) package dependency is the dart-only (No Jaspr) core of the library also maintained by [me](https://github.com/jshep23). This allows me to iterate quickly on the core reactive features for both the Flutter and Jaspr implementations of Current.

You can find the full API documentation [here](https://pub.dev/documentation/jaspr_current/latest/).
