import 'package:client/requests/keycloak_requests.dart';
import 'package:client/requests/request_f.dart';
import 'package:client/vars/my_colors_dev.dart';
import 'package:client/widgets/button.dart';
import 'package:client/widgets/card.dart';
import 'package:client/widgets/orders.dart';
import 'package:client/widgets/profile.dart';
import 'package:client/widgets/search.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
    makeRequestWithAuth(context, cardsNotifier.reloadCards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Добро пожаловать, ${KeycloakAuth.getAccessTokenContext()!.firstName}"),
        toolbarHeight: 100,
        centerTitle: true,
      ),
      // resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, color: beige),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat, color: beige),
            label: 'Чат',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: beige),
            label: 'Настройки',
          )
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          makeRequestWithAuth(context, cardsNotifier.reloadCards);
        },
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Expanded(child: SearchWidget()),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyProfilePage(
                                  lastName:
                                      KeycloakAuth.getAccessTokenContext()!
                                          .firstName,
                                  firstName:
                                      KeycloakAuth.getAccessTokenContext()!
                                          .lastName,
                                  email: KeycloakAuth.getAccessTokenContext()!
                                      .email,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    // padding: const EdgeInsets.all(50),
                    shape: const CircleBorder(),
                    backgroundColor: Colors.transparent, // <-- Button color
                    foregroundColor: Colors.transparent, // <-- Splash color
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profile.png"),
                    minRadius: 40,
                  ),
                ),

                // ElevatedButton(
                //   onPressed: () {},
                //   child: CircleAvatar(radius: 15,),
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.all(10),
                //     shape: const CircleBorder(),
                //     backgroundColor: Colors.blue, // <-- Button color
                //     foregroundColor: Colors.red, // <-- Splash color
                //   ),
                // ),
                SizedBox(width: 15),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  MyButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderPage()));
                    },
                  ),
                ],
              ),
            ),
            const CardList()
          ],
        ),
      ),
    );
  }
}
