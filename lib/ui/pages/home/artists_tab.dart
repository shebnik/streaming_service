import 'package:flutter/material.dart';
import 'package:streaming_service/services/auth_service.dart';

class ArtistsTab extends StatefulWidget {
  const ArtistsTab({Key? key}) : super(key: key);

  @override
  _ArtistsTabState createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<ArtistsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: const Text(
            'Artists',
            style: TextStyle(color: Colors.white),
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
      body: Container(),
    );
  }
}
