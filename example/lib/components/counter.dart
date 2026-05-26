import 'package:example/components/counter_view_model.dart';
import 'package:example/main_view_model.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_current/jaspr_current.dart';

import '../constants/theme.dart';

class Counter extends CurrentComponent<CounterViewModel> {
  const Counter({super.key, required super.viewModel});

  @override
  CurrentState<CurrentComponent<CounterViewModel>, CounterViewModel> createCurrent() => CounterState(viewModel);
}

class CounterState extends CurrentState<Counter, CounterViewModel> {
  CounterState(super.viewModel);

  @override
  Component build(BuildContext context) {
    // Access application-wide state using Current.viewModelOf, which will look up the component tree for the nearest MainViewModel
    // bound to a Current component. In this case, it will find the MainViewModel provided in the App component.
    final mainViewModel = Current.viewModelOf<MainViewModel>(context);

    return div(
      [
        div(classes: 'counter', [
          button(
            onClick: viewModel.decrement,
            [.text('-')],
          ),
          span([.text('${viewModel.count}')]),
          button(
            onClick: viewModel.increment,
            [.text('+')],
          ),
        ]),
        div(
          classes: 'background-options',
          [
            h2([.text('Background color')]),
            select(
              onChange: (value) {
                switch (value) {
                  case ['none']:
                    mainViewModel.favColor.value = Colors.transparent;
                  case ['green']:
                    mainViewModel.favColor.value = Colors.green;
                  case ['blue']:
                    mainViewModel.favColor.value = Colors.blue;
                }
              },
              [
                option(
                  value: 'none',
                  selected: mainViewModel.favColor.value == Colors.transparent,
                  [.text('None')],
                ),
                option(value: 'green', selected: mainViewModel.favColor.value == Colors.green, [
                  .text('Green'),
                ]),
                option(value: 'blue', selected: mainViewModel.favColor.value == Colors.blue, [
                  .text('Blue'),
                ]),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.counter', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 10.px),
        border: .symmetric(
          vertical: .solid(color: primaryColor, width: 2.px),
        ),
        alignItems: .center,
      ),
      css('button', [
        css('&').styles(
          display: .flex,
          width: 2.em,
          height: 2.em,
          border: .unset,
          radius: .all(.circular(2.em)),
          cursor: .pointer,
          justifyContent: .center,
          alignItems: .center,
          fontSize: 2.rem,
          backgroundColor: Colors.transparent,
        ),
        css('&:hover').styles(
          backgroundColor: const Color('#0001'),
        ),
      ]),
      css('span').styles(
        minWidth: 2.5.em,
        padding: .symmetric(horizontal: 2.rem),
        boxSizing: .borderBox,
        color: primaryColor,
        textAlign: .center,
        fontSize: 4.rem,
      ),
    ]),
    css('.background-options').styles(
      display: .flex,
      justifyContent: .center,
      alignItems: .center,
      gap: Gap(column: 10.px),
    ),
  ];
}
