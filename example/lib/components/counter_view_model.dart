import 'package:jaspr_current/jaspr_current.dart';

class CounterViewModel extends CurrentViewModel {
  final count = CurrentProperty.integer();
  final name = CurrentProperty.string(initialValue: 'Unknown');

  void increment() => count.value += 1;

  void decrement() => count.value -= 1;

  @override
  Iterable<CurrentProperty> get currentProps => [count, name];
}
