import 'package:flutter/material.dart';

import '../dto/profile.dart';
import '../requests/request_f.dart';



class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final ScrollController _scrollController = ScrollController();
  final _friends = <Profile>[];

  final int batchSize = 15;

  Future _updateFriends(String accessToken) async {
    //TODO: СДЕЛАТЬ РЕСУРС НА ЗАПРОС ДРУЗЕЙ
    // getProductOrders(accessToken, _friends.length, batchSize).then((orders) => {
    //   setState(() {
    //     _friends.addAll(orders);
    //   })
    // });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      makeRequestWithAuth(context, _updateFriends);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => makeRequestWithAuth(context, _updateFriends),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _friends.length,
          itemBuilder: (context, i) {
            //TODO: СДЕЛАТЬ ВИДЖЕТ ДЛЯ ОТОБРАЖЕНИЯ ДРУГА
            // return OrderWidget(
            //     productName: _orders[i].productName,
            //     address: _orders[i].address,
            //     scheduledDate: formatter.format(_orders[i].scheduledDate!),
            //     createdAt: formatter.format(_orders[i].createdAt!),
            //     status: _orders[i].status!);
          }),
    );
  }
}

class FriendsWidget extends StatelessWidget {
  const FriendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Друзья"),
      ),
      body: FriendsList(),
    );
  }

}