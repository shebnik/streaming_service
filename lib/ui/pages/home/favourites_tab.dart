import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/firestore_service.dart';
import 'package:streaming_service/services/hive_service.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_app_bar.dart';
import 'package:streaming_service/ui/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';
import 'package:streaming_service/ui/widgets/track_card.dart';
import 'package:streaming_service/services/extensions.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({Key? key}) : super(key: key);

  @override
  _FavouritesTabState createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab>
    with AutomaticKeepAliveClientMixin {
  Box<Track>? favouritesBox;

  ValueNotifier<bool> descending = ValueNotifier(false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    HiveService.getFavouritesBox().then((value) {
      favouritesBox = value;
      setState(() => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: AppTheme.deepBlack,
        appBar: AppAppBar(
          title: "Favourites",
          actions: [
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () => descending.value = !descending.value,
            )
          ],
        ),
        body: favouritesBox == null
            ? const Center(child: LoadingIndicator())
            : favouritesBody());
  }

  Widget favouritesBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: ValueListenableBuilder<Box<Track>>(
          valueListenable: favouritesBox!.listenable(),
          builder: (_, box, __) {
            List<Track> tracks = box.values.toList();
            return ValueListenableBuilder<bool>(
              valueListenable: descending,
              builder: (_, descending, __) {
                tracks.sort((a, b) => descending
                    ? a.timeWhenAddedToFavourites!
                        .compareTo(b.timeWhenAddedToFavourites!)
                    : b.timeWhenAddedToFavourites!
                        .compareTo(a.timeWhenAddedToFavourites!));
                return tracksList(tracks);
              },
            );
          },
        ),
      ),
    );
  }

  Widget tracksList(List<Track> tracks) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tracks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final Track track = tracks[index];
        return ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Dismissible(
            key: Key("track-${track.id}"),
            confirmDismiss: (_) => _onDismissed(track),
            child: TrackCard(
              track: track,
              showArtistName: true,
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onDismissed(Track track) async {
    bool? value =
        await const AreYouSureDialog(message: "Are you sure want to remove track?")
            .showWidgetAsDialog(context);

    if (value != null && value == true) {
      await favouritesBox!.delete(track.id);
      await FirestoreService.removeFromFavourites(track);
      setState(() => {});
      return true;
    }
    return false;
  }
}
