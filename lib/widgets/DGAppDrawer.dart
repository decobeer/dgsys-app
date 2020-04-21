import 'package:dgsys_app/models/app_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DGAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(),
            ListTile(
              title: Text("Balance: kr. " + appState.userInfo.balance.toString()),
            ),
            //screenToggles(appState, ecText),
          ],
        ),
    );
  }
}


class DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final appState = Provider.of<AppState>(context);
    return UserAccountsDrawerHeader(
      accountName: Text(appState.userInfo.firstName + ' ' + appState.userInfo.lastName),
      accountEmail: Text(appState.userInfo.membership),
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(color: Colors.black54),
    );
  }
}

class logoutTile extends StatelessWidget {
  const logoutTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return InkWell(
      onTap: () async {
        appState.logOut();
      },
      child: ListTile(
        title: Text('Log out'),
        leading: Icon(Icons.exit_to_app),
      ),
    );
  }
}
