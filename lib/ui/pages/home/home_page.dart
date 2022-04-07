import 'package:flutter/material.dart';
import 'package:streaming_service/ui/pages/home/artists_tab.dart';
import 'package:streaming_service/ui/pages/home/favourites_tab.dart';
import 'package:streaming_service/ui/pages/home/search_tab.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        _currentTabIndex = _tabController.index;
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: TabBarView(
        controller: _tabController,
        children: const [
          ArtistsTab(),
          SearchTab(),
          FavouritesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Artists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Collection',
          ),
        ],
        currentIndex: _currentTabIndex,
        selectedItemColor: AppTheme.primaryColor,
        onTap: (int index) {
          _tabController.index = _currentTabIndex;
          _currentTabIndex = index;
          _tabController.animateTo(_currentTabIndex);
          setState(() {});
        },
      ),
    );
  }
}
