import 'dart:async';

import 'package:current_core/current_core.dart';
import 'package:jaspr/jaspr.dart';

import 'current_view_model.dart';

///Base class for any component that needs to be updated when the state of your component changes.
///
///Requires a class that extends [CurrentViewModel] to be passed to the [viewModel] argument. The
///[CurrentViewModel] is responsible for notifying this component when the UI needs to be updated.
///By default, [CurrentComponent] also owns the lifecycle of the provided [viewModel] and disposes it
///when the accompanying [CurrentState] is disposed. Set [disposeViewModel] to `false` when using
///an externally managed or shared [CurrentViewModel] instance.
///
///### Usage
///
///```dart
///class MyComponent extends CurrentComponent<MyViewModel> {
///
///    const MyComponent({super.key, required super.viewModel});
///
///    @override
///    CurrentState<CurrentComponent<CurrentViewModel>, MyViewModel> createCurrent() => _MyComponentState(viewModel);
///
///}
///```
abstract class CurrentComponent<T extends CurrentViewModel> extends StatefulComponent {
  final T viewModel;
  final bool debugPrintStateChanges;

  /// Whether this component owns the lifecycle of the provided [viewModel].
  ///
  /// When true, disposing the [CurrentState] will also dispose the
  /// [CurrentViewModel].
  ///
  /// Set this to false when the [viewModel] is managed externally and should
  /// survive component disposal so it can be rebound later.
  final bool disposeViewModel;

  const CurrentComponent({
    super.key,
    required this.viewModel,
    this.debugPrintStateChanges = false,
    this.disposeViewModel = true,
  });

  ///Create an instance of [CurrentState] for this component.
  ///
  ///**IMPORTANT**
  ///This function replaces the default [createState] function. Under the hood, [createCurrent] overrides
  ///the [createState] function. Overriding this function and the [createState] function can have
  ///unintended side affects.
  CurrentState<CurrentComponent, T> createCurrent();

  ///Avoid overriding this function. [createCurrent] handles the creation of the component state.
  ///Overriding this function can have unintended side affects. You've been warned.
  @mustCallSuper
  @override
  State<StatefulComponent> createState() {
    // ignore: no_logic_in_create_state
    return createCurrent();
  }
}

///Base class for your [CurrentComponent]s accompanying State class.
///
///Will automatically trigger a rebuild when any of this objects accompanying [CurrentViewModel]
///properties change.
///
///### Usage
///
///```dart
///class _CounterPageState extends CurrentState<CounterPage, CounterViewModel> {
///  _CounterPageState(super.viewModel);
///
///  @override
///  Component build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(
///        title: Text(component.title),
///      ),
///      body: Center(
///        child: Column(
///          mainAxisAlignment: MainAxisAlignment.center,
///          children: <Component>[
///            const Text(
///              'You have pushed the button this many times:',
///            ),
///            Text(
///              '${viewModel.count}',
///            ),
///          ],
///        ),
///      ),
///      floatingActionButton: FloatingActionButton(
///        onPressed: viewModel.incrementCounter,
///        tooltip: 'Increment',
///        child: const Icon(Icons.add),
///      ),
///    );
///  }
///}
///```
///**IMPORTANT**
///If you expect the parent component of [T] to cause [T] to rebuild while reusing the same
///[CurrentViewModel] instance, you should either use the Flutter [AutomaticKeepAliveClientMixin]
///on the [CurrentState] implementation or set [CurrentComponent.disposeViewModel] to `false` and manage
///the view model lifecycle yourself. Otherwise, the default owned lifecycle will dispose the view
///model with the state.
///
///For example:
///```dart
///class _CounterPageState extends CurrentState<CounterPage, CounterViewModel> with AutomaticKeepAliveClientMixin {
///  _CounterPageState(super.viewModel);
///
///  @override
///  bool get wantKeepAlive => true;
///
///  @override
///  Component build(BuildContext context) {
///    super.build(context);
///    return Scaffold(
///     body: Text('Counter: ${viewModel.count}'),
///    );
///  }
///}
abstract class CurrentState<T extends CurrentComponent, E extends CurrentViewModel> extends State<T> {
  final E viewModel;
  late final StreamSubscription<CurrentStateChanged> _stateChangedSubscription;

  ///Exposes the [viewModel] busy status. Used to determine if the [viewModel] is busy running
  ///a long running task
  bool get isBusy => viewModel.busy;

  CurrentState(this.viewModel) {
    if (mounted) {
      viewModel.assignTo(hashCode);
    }
    _stateChangedSubscription = viewModel.addStateChangedListener<CurrentStateChanged>((event) {
      if (component.debugPrintStateChanges && kDebugMode) {
        // ignore: avoid_print
        print(event);
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  ///Can be used to conditionally show another component if the [viewModel] is busy running a long
  ///running task.
  ///
  ///If the view model is busy, it will show the [busyIndicator] component. If it is not
  ///busy, it will show the [otherwise] component.
  Component ifBusy(Component busyIndicator, {required Component otherwise}) {
    return isBusy ? busyIndicator : otherwise;
  }

  @override
  @mustCallSuper
  void dispose() {
    if (component.disposeViewModel) {
      viewModel.dispose();
    } else {
      viewModel.cancelSubscription(_stateChangedSubscription);
      viewModel.releaseFrom(hashCode);
    }
    super.dispose();
  }
}
