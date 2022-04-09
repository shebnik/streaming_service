import 'package:flutter/material.dart';
import 'package:streaming_service/services/napster_service.dart';
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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const AppAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBar(
              textFieldController: textFieldController,
              onSubmitted: _doSearch,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doSearch(String query) async {
    print("Searching for $query");
    await NapsterService.searchArtist(query, 0);
  }
}
