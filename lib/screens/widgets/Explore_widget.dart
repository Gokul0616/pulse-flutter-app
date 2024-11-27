import 'package:Pulse/screens/widgets/component/VideoListScreen_widget.dart';
import 'package:Pulse/screens/widgets/component/post_widget.dart';
import 'package:Pulse/screens/widgets/component/tweaks_widget.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';

  // Your categories list
  List<String> categories = [
    'Trending',
    'Foods',
    'Technology',
    'Music',
    'Sports',
    'Movies',
    'Fitness',
    'Travel',
    'Gaming',
    'News',
    'Health',
    'Fashion',
    'Art',
  ];

  List<PostWidget> posts = [
    PostWidget(
      userName: "Username",
      postTime: "10 minutes ago",
      userProfileUrl:
          "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
      postUrl: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
      isLiked: false,
      onLikeToggle: () {},
      onCommentPressed: () {},
    ),
    PostWidget(
      userName: "Username",
      postTime: "10 minutes ago",
      userProfileUrl:
          "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
      postUrl:
          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_640.jpg",
      isLiked: false,
      onLikeToggle: () {},
      onCommentPressed: () {},
    ),
    // Add more posts
  ];

  List<VideoItem> videos = [
    VideoItem(
      url: 'https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4',
      thumbnailUrl:
          'https://images.ctfassets.net/hrltx12pl8hq/28ECAQiPJZ78hxatLTa7Ts/2f695d869736ae3b0de3e56ceaca3958/free-nature-images.jpg?fit=fill&w=1200&h=630',
      title: 'Sample Video 2',
      userProfileUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      userName: 'John Doe',
      userHandle: 'johndoe',
      uploadTime: '2 hours ago',
      viewCount: '1.2K',
      duration: '3:45',
    ),
    VideoItem(
      url: 'https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4',
      thumbnailUrl:
          'https://images.ctfassets.net/hrltx12pl8hq/28ECAQiPJZ78hxatLTa7Ts/2f695d869736ae3b0de3e56ceaca3958/free-nature-images.jpg?fit=fill&w=1200&h=630',
      title: 'Sample Video 2',
      userProfileUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      userName: 'John Doe',
      userHandle: 'johndoe',
      uploadTime: '2 hours ago',
      viewCount: '1.2K',
      duration: '3:45',
    ),
    // Add more videos
  ];

  List<TweakWidget> tweaks = [
    TweakWidget(
      userName: "John Doe",
      handle: "johndoe",
      timeAgo: "2h",
      userProfileUrl:
          "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
      tweakContent:
          "Your new home for real-time updates, quick thoughts, and engaging conversations.",
      tweakImageUrl:
          "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      isLiked: false,
      likeCount: 123,
      commentCount: 45,
      retweakCount: 20,
      onLikeToggle: () {},
      onCommentPressed: () {},
      onRetweakPressed: () {},
      onSharePressed: () {},
    ),
    TweakWidget(
      userName: "John Doe",
      handle: "johndoe",
      timeAgo: "2h",
      userProfileUrl:
          "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
      tweakContent: "This is a sample tweak content!",
      tweakImageUrl:
          "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      isLiked: false,
      likeCount: 123,
      commentCount: 45,
      retweakCount: 20,
      onLikeToggle: () {
        // Toggle like action
      },
      onCommentPressed: () {
        // Navigate to comments
      },
      onRetweakPressed: () {
        // Retweak action
      },
      onSharePressed: () {
        // Share action
      },
    ),
    // Add more tweaks
  ];

  // Filter content based on the search query
  List<PostWidget> _filterPosts() {
    return posts
        .where((post) =>
            post.userName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<VideoItem> _filterVideos() {
    return videos
        .where((video) =>
            video.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<TweakWidget> _filterTweaks() {
    return tweaks
        .where((tweak) =>
            tweak.userName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Explore'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  searchQuery: _searchQuery,
                  onSearchQueryChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Sticky Category Header
          SliverPersistentHeader(
            delegate: _StickyHeaderDelegate(categories),
            pinned: true,
          ),

          // Display filtered posts
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _filterPosts()[index],
              childCount: _filterPosts().length,
            ),
          ),

          // Display filtered videos
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => VideoListScreen(
                videoItems: [_filterVideos()[index]],
                onVideoClicked: (VideoItem) {},
              ),
              childCount: _filterVideos().length,
            ),
          ),

          // Display filtered tweaks
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _filterTweaks()[index],
              childCount: _filterTweaks().length,
            ),
          ),
        ],
      ),
    );
  }

  // Custom method to create category items with icons
  Widget _categoryItem(String categoryName) {
    // Define icons for each category
    Map<String, Icon> categoryIcons = {
      'Trending': const Icon(Icons.trending_up, color: Colors.black),
      'Foods': const Icon(Icons.fastfood, color: Colors.black),
      'Technology': const Icon(Icons.computer, color: Colors.black),
      'Music': const Icon(Icons.music_note, color: Colors.black),
      'Sports': const Icon(Icons.sports, color: Colors.black),
      'Movies': const Icon(Icons.movie, color: Colors.black),
      'Fitness': const Icon(Icons.fitness_center, color: Colors.black),
      'Travel': const Icon(Icons.airplanemode_active, color: Colors.black),
      'Gaming': const Icon(Icons.videogame_asset, color: Colors.black),
      'News': const Icon(Icons.article, color: Colors.black),
      'Health': const Icon(Icons.health_and_safety, color: Colors.black),
      'Fashion': const Icon(Icons.checkroom, color: Colors.black),
      'Art': const Icon(Icons.brush, color: Colors.black),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Chip(
        avatar: categoryIcons[
            categoryName], // Set the icon here with the correct color
        label: Text(categoryName),
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}

// Custom delegate for sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;

  _StickyHeaderDelegate(this.categories);

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            categories.map((category) => _categoryItem(category)).toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.categories != categories;
  }
}

Widget _categoryItem(String categoryName) {
  // Define icons for each category
  Map<String, Icon> categoryIcons = {
    'Trending': const Icon(Icons.trending_up,color: Colors.black,),
    'Foods': const Icon(Icons.fastfood,
      color: Colors.black,
    ),
    'Technology': const Icon(Icons.computer,
      color: Colors.black,
    ),
    'Music': const Icon(Icons.music_note,
      color: Colors.black,
    ),
    'Sports': const Icon(Icons.sports,
      color: Colors.black,
    ),
    'Movies': const Icon(Icons.movie,
      color: Colors.black,
    ),
    'Fitness': const Icon(Icons.fitness_center,
      color: Colors.black,
    ),
    'Travel': const Icon(Icons.airplanemode_active,
      color: Colors.black,
    ),
    'Gaming': const Icon(Icons.videogame_asset,
      color: Colors.black,
    ),
    'News': const Icon(Icons.article,
      color: Colors.black,
    ),
    'Health': const Icon(Icons.health_and_safety,
      color: Colors.black,
    ),
    'Fashion': const Icon(Icons.checkroom,
      color: Colors.black,
    ),
    'Art': const Icon(Icons.brush,
      color: Colors.black,
    ),
  };

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Chip(
      avatar: categoryIcons[categoryName], // Set the icon
      label: Text(categoryName),
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
    ),
  );
}

// Custom search delegate for handling the search input and result filtering
class CustomSearchDelegate extends SearchDelegate {
  final String searchQuery;
  final Function(String) onSearchQueryChanged;

  CustomSearchDelegate(
      {required this.searchQuery, required this.onSearchQueryChanged});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
          onSearchQueryChanged('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // You can customize the results view here if needed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // You can show suggestions if needed
  }
}
