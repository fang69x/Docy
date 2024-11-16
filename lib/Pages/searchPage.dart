import 'package:docy/provider/search_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  // Function that is triggered when the search query changes or button is clicked
  void _search() {
    String query = _searchController.text;
    String userId = getCurrentUserId();
    // Calling Riverpod provider function to search for files
    ref.read(searchResultsProvider.notifier).searchFilesByUser(
        userId, query); // Use ref.read instead of context.read
  }

  @override
  Widget build(BuildContext context) {
    final searchState =
        ref.watch(searchResultsProvider); // Watching the search results

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 137, 74, 226),
              Color.fromARGB(255, 1, 10, 26)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 100),

              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSearchButton(), // Add the search button here
              const SizedBox(height: 20),
              if (searchState.isLoading)
                const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator
              else if (searchState.error.isNotEmpty)
                _buildError(searchState.error) // Show error message
              else if (searchState.results.isEmpty)
                _buildNoResults() // Show no results message
              else
                _buildSearchResults(searchState.results), // Show search results
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search here...',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      ),
    );
  }

  // Add the search button
  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _search, // Trigger the search when the button is pressed
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple, // Button color
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text('Search',
          style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildNoResults() {
    return Expanded(
      child: Center(
        child: Text(
          'No results found.',
          style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade600),
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Expanded(
      child: Center(
        child: Text(
          error,
          style: TextStyle(fontSize: 18, color: Colors.red.shade600),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<String> results) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return _buildSearchResultItem(results[index]);
        },
      ),
    );
  }

  Widget _buildSearchResultItem(String result) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        leading: const Icon(Icons.search, color: Colors.deepPurple, size: 28),
        title: Text(result, style: const TextStyle(fontSize: 18)),
        onTap: () {
          // Handle item tap, navigate to result details or perform action
        },
      ),
    );
  }
}
