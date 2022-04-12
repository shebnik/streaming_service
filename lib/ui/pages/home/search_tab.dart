import 'package:flutter/material.dart';
import 'package:streaming_service/models/artist.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artists/artists_list.dart';
import 'package:streaming_service/ui/widgets/app_app_bar.dart';
import 'package:streaming_service/ui/widgets/search_bar.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textFieldController = TextEditingController();

  String? query;

  ValueNotifier<List<Artist>> artists = ValueNotifier([]);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
        child: Column(
          children: [
            SearchBar(
              textFieldController: textFieldController,
              onSubmitted: _doSearch,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ArtistsList(
                loadArtists: _loadArtists,
                artists: artists,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doSearch(String query) async {
    this.query = query;
    artists.value = [];
    setState(() {});
  }

  Future<List<Artist>> _loadArtists(int offset) {
    if (query == null) {
      return Future.value([]);
    }
    return NapsterService.searchArtists(query!, offset);
  }
}
