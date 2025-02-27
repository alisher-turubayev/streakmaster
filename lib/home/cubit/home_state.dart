part of 'home_cubit.dart';

// Make sure the tab index corresponds to where UI is drawing these
// TODO: see if a better way exists?
enum HomeTab { goalsList, home, settings }

final class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.home,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}