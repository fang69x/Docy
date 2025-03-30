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

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  void _search() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      String userId = getCurrentUserId();
      ref.read(searchResultsProvider.notifier).searchFilesByUser(userId, query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchResultsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF894AE2), Color(0xFF010A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search Files",
                style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20.h),
              _buildSearchBar(),
              SizedBox(height: 15.h),
              _buildSearchButton(),
              SizedBox(height: 20.h),
              Expanded(
                child: searchState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : searchState.error.isNotEmpty
                        ? _buildError(searchState.error)
                        : searchState.results.isEmpty
                            ? _buildNoResults()
                            : _buildSearchResults(searchState.results),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
      decoration: InputDecoration(
        hintText: 'Search files...',
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
        prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _search,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text('Search',
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Text(
        'No results found.',
        style: TextStyle(fontSize: 18.sp, color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Text(
        error,
        style: TextStyle(fontSize: 18.sp, color: Colors.red.shade600),
      ),
    );
  }

  Widget _buildSearchResults(List<String> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _buildSearchResultItem(results[index]);
      },
    );
  }

  Widget _buildSearchResultItem(String result) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: const Icon(Icons.insert_drive_file,
            color: Colors.deepPurple, size: 28),
        title: Text(result,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
        onTap: () {
          // Handle item tap
        },
      ),
    );
  }
}
