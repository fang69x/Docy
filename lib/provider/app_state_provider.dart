import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a simple state to manage authentication
class AppState {
  final bool isAuthenticated;

  AppState({this.isAuthenticated = false});
}

// Create a StateNotifier to manage the AppState
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void authenticate() {
    state = AppState(isAuthenticated: true);
  }

  void logout() {
    state = AppState(isAuthenticated: false);
  }
}

// Create a provider for the AppStateNotifier
final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});
