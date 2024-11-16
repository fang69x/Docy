import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = []; // Mock search results

  @override
  void initState() {
    super.initState();
  }

  // Simulated search function to update the search results based on query
  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults.clear();
      } else {
        // Mock search results
        _searchResults = List.generate(10, (index) => '$query Result $index');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Search',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            if (_searchResults.isEmpty)
              _buildNoResults()
            else
              _buildSearchResults(),
          ],
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
      onChanged: (query) {
        _search(query);
      },
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

  Widget _buildSearchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return _buildSearchResultItem(_searchResults[index]);
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
