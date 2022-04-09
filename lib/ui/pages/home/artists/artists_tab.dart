import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:streaming_service/models/artist.dart';
import 'package:streaming_service/services/auth_service.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artist_detail/artist_detail.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';

class ArtistsTab extends StatefulWidget {
  const ArtistsTab({Key? key}) : super(key: key);

  @override
  _ArtistsTabState createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<ArtistsTab> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  int currentOffset = 0;
  List<Artist> artists = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadArtists();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          toolbarHeight: 80.0,
          title: const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              'Artists',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'logout') {
                  AuthService.signOut();
                }
              },
              itemBuilder: (BuildContext context) => const [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Log out'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              padding: const EdgeInsets.all(15),
              itemCount: artists.length,
              itemBuilder: (BuildContext context, int index) {
                final Artist artist = artists[index];
                return artistCard(artist);
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (_, _isLoading, __) {
                return _isLoading
                    ? const LoadingIndicator()
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget artistCard(Artist artist) {
    return GestureDetector(
      onTap: () => _showArtistDetail(artist),
      child: Hero(
        tag: artist.id,
        child: Card(
          elevation: 16,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.all(8.0),
          color: AppTheme.deepBlack,
          child: Column(
            children: [
              Image.network(
                NapsterService.getArtistImage(artist.id),
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(artist.name),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  void _showArtistDetail(Artist artist) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArtistDetail(artist: artist),
      ),
    );
  }

  Future<void> _loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    currentOffset += 10;
    await _loadArtists();
  }

  Future<void> _loadArtists() async {
    artists.addAll(
      await NapsterService.getTopArtists(currentOffset),
    );
    isLoading = ValueNotifier(false);
    setState(() {});
  }
}
