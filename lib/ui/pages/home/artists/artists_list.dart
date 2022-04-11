import 'package:flutter/material.dart';

import 'package:streaming_service/models/artist.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artist_detail/artist_detail.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_image.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';

class ArtistsList extends StatefulWidget {
  const ArtistsList({
    Key? key,
    this.artists,
    required this.loadArtists,
  }) : super(key: key);

  final ValueNotifier<List<Artist>>? artists;
  final Future<List<Artist>> Function(int offset) loadArtists;

  @override
  _ArtistsListState createState() => _ArtistsListState();
}

class _ArtistsListState extends State<ArtistsList> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  final ScrollController _scrollController = ScrollController();

  late ValueNotifier<List<Artist>> artists;

  @override
  void initState() {
    super.initState();
    artists = widget.artists ?? ValueNotifier([]);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadArtists();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Column(
        children: [
          ValueListenableBuilder<List<Artist>>(
            valueListenable: artists,
            builder: (_, _artists, __) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: _artists.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
                        : 5,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (_, index) => artistCard(_artists[index]),
            ),
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
    );
  }

  Widget artistCard(Artist artist) {
    return GestureDetector(
      onTap: () => _showArtistDetail(artist),
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
            Flexible(
              flex: 2,
              child: AppImage(
                url: NapsterService.getArtistImage(artist.id),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  artist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showArtistDetail(Artist artist) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArtistDetail(artist: artist),
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

  Future<void> _loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    await _loadArtists();
  }

  Future<void> _loadArtists() async {
    artists.value = [
      ...artists.value,
      ...await widget.loadArtists(artists.value.length),
    ];
    isLoading.value = false;
  }
}
