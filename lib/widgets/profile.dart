import 'package:client/dto/profile.dart';
import 'package:client/notifications/socket.dart';
import 'package:client/widgets/friends.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../requests/keycloak_requests.dart';
import '../vars/decorations.dart';
import '../vars/my_colors_dev.dart';
import 'action_tile_button.dart';
import 'card.dart';
import 'login.dart';

class ProfileField extends StatelessWidget {
  final String fieldName;
  final String value;

  const ProfileField({super.key, required this.fieldName, required this.value});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(lightGold),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              fieldName,
              style: TextStyle(color: Colors.black45),
            ),
            SizedBox(
              width: 20,
            ),
            Text(value,
                style: TextStyle(color: Theme.of(context).colorScheme.primary))
          ],
        ));
  }
}

class ProfileActionBar extends StatelessWidget {
  const ProfileActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    var actionsButtons = [
      Flexible(
        child: TextButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group_add,
                  color: Theme.of(context).colorScheme.primary),
              Text("Добавить в друзья",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      ),
      Flexible(
        child: TextButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_circle_right,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text("Перевести деньги",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      ),
      Flexible(
        child: TextButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat, color: Theme.of(context).colorScheme.primary),
              Text("Написать сообщение",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: beigeGoldFieldDecoration,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: actionsButtons),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final Profile profile;

  const ProfilePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
              ),
              Text(
                "${profile.lastName} ${profile.firstName}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                profile.email!, // TODO:исправить
                style: const TextStyle(fontSize: 18),
              ),

              //
              // Container(
              //   padding: const EdgeInsets.all(10),
              //   decoration: beigeGoldFieldDecoration,
              //   child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: actionsButtons),
              // ),
              const ProfileActionBar()
            ],
          ),
        ),
      ),
    );
  }
}

class MyProfilePage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;

  void _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    KeycloakAuth.clear();
    cardsNotifier.clear();
    channel?.sink.close();
  }

  const MyProfilePage(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email});

  @override
  Widget build(BuildContext context) {
    var quitDialog = Dialog(
      child: Container(
        padding: const EdgeInsets.all(18.0),
        width: 300,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Вы действительно хотите выйти? Данные о сессии будут удалены.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _logOut();

                      Navigator.popUntil(context, (route) => false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginWidget()));
                    },
                    child: const Text(
                      'Да',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Нет'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // leading: Container(
        //   margin: const EdgeInsets.all(8),
        //   child: const CircleAvatar(
        //     radius: 10,
        //     backgroundImage: NetworkImage("https://www.bethowen.ru/upload/iblock/63f/63f2f01ca6828d9574995f549d89a2e0.jpeg"),
        //   ),
        // ),
        title: const Text("Профиль"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  // backgroundColor: Theme.of(context).colorScheme.primary,
                  // child: Icon(Icons.account_circle, size: 100, color: Theme.of(context).primaryColor,),
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
              ),
              Text(
                "$lastName $firstName",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 18),
              ),

              Container(
                margin: EdgeInsets.all(30),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(30),
                        child: const Text("Документы"))),
              ),

              Container(
                margin: EdgeInsets.all(30),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendsWidget()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(30),
                        child: const Text("Друзья"))),
              ),

              // Container(
              //   padding: const EdgeInsets.all(10),
              //   decoration: beigeGoldFieldDecoration,
              //   child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: actionsButtons),
              // ),
              // const ProfileActionBar()
              const Divider(),
              ActionTileButton(
                title: "Выйти",
                icon: Icons.exit_to_app,
                onTap: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => quitDialog);
                },
                textColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
