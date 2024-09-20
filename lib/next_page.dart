import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アルケール'),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: ListView(
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text('地図'),
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Album'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
            ),
            ListTile(
              leading: Icon(Icons.cottage),
              title: Text('home'),
            ),
            ListTile(
              leading: Icon(Icons.table_rows_rounded),
              title: Text('menu'),
            ),
            ListTile(
              leading: Icon(Icons.forum_rounded),
              title: Text('コメント'),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('log in'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('log out'),
            ),
            ListTile(
              leading: Icon(Icons.thumb_up_alt),
              title: Text('good'),
            ),
            ListTile(
              leading: Icon(Icons.thumb_down_alt),
              title: Text('bad'),
            ),
            ListTile(
              leading: Icon(Icons.cloudy_snowing),
              title: Text('weather'),
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward_ios_rounded),
              title: Text('next'),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('search'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('settings'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('account'),
            ),
          ],
        ),
      ),
    );
  }
}