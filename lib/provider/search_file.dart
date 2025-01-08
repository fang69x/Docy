import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchResultsProvider =
    StateNotifierProvider<SearchResultsNotifier, SearchResultsState>(
  (ref) => SearchResultsNotifier(),
);

class SearchResultsState {
  final List<String> results;
  final bool isLoading;
  final String error;

  SearchResultsState({
    required this.results,
    required this.isLoading,
    required this.error,
  });

  factory SearchResultsState.initial() {
    return SearchResultsState(
      results: [],
      isLoading: false,
      error: '',
    );
  }

  SearchResultsState copyWith({
    List<String>? results,
    bool? isLoading,
    String? error,
  }) {
    return SearchResultsState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SearchResultsNotifier extends StateNotifier<SearchResultsState> {
  SearchResultsNotifier() : super(SearchResultsState.initial());

  // Function to search files for a specific user by their ID
  Future<void> searchFilesByUser(String userId, String query) async {
    if (query.isEmpty) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }

    final storageRef = FirebaseStorage.instance.ref();
    try {
      state = state.copyWith(
          isLoading: true); // Set loading state to true while fetching data

      // Search all files in the storage and filter by user ID and query
      final result = await storageRef.listAll(); // Fetch all files
      final matchingFiles = result.items
          .where((file) =>
              file.name.toLowerCase().contains(userId.toLowerCase()) &&
              file.name.toLowerCase().contains(query.toLowerCase()))
          .map((file) => file.name)
          .toList();

      // Update state with the matching files and set loading state to false
      state = state.copyWith(results: matchingFiles, isLoading: false);
    } catch (e) {
      state =
          state.copyWith(isLoading: false, error: 'Error fetching files: $e');
      print('Error fetching files: $e');
    }
  }
}
