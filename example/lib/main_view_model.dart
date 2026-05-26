import 'package:jaspr/dom.dart';
import 'package:jaspr_current/jaspr_current.dart';

class MainViewModel extends CurrentViewModel {
  final favColor = CurrentProperty<Color>(Colors.transparent);

  @override
  Iterable<CurrentProperty> get currentProps => [favColor];
}
