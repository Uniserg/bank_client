import 'package:client/dto/product_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../requests/product_order_requests.dart';
import 'card.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [Icon(Icons.add_card), Text("Заказы")],
          ),
        ),
        body: Container(
          // margin: const EdgeInsets.only(top: 100, left: 5, right: 5),
          // height: 100,
          // decoration: const ShapeDecoration(
          //     color: Color(0xffF5F0E5),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(20))
          //     )
          // ),
          child: const Center(
            child: OrderList(),
          ),
        ));
  }
}

class StatusWidget extends StatelessWidget {
  final ProductOrderStatus status;

  final statuses = {
    ProductOrderStatus.CONFIRM_AWAIT: Column(
      children: const [
        Icon(Icons.access_time, color: Colors.amber,),
        Text("В ожидании", style: TextStyle(color: Colors.amber),),
      ],
    ),
    ProductOrderStatus.IN_PROGRESS: Column(
      children: const [
        Icon(Icons.cached_outlined, color: Colors.blue,),
        Text("В процессе", style: TextStyle(color: Colors.blue)),
      ],
    ),
    ProductOrderStatus.COMPLETED: Column(children: const [
      Icon(Icons.check, color: Colors.green,),
      Text("Выполнен", style: TextStyle(color: Colors.green)),
    ]),
    ProductOrderStatus.REFUSED: Column(children: const [
      Icon(Icons.close, color: Colors.red,),
      Text("Отклонен", style: TextStyle(color: Colors.red)),
    ])
  };

  StatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return statuses[status]!;
  }
}

class OrderWidget extends StatelessWidget {
  final String productName;
  final String address;
  final String scheduledDate;
  final String createdAt;
  final ProductOrderStatus status;

  const OrderWidget(
      {super.key,
      required this.productName,
      required this.address,
      required this.scheduledDate,
      required this.createdAt,
      required this.status}
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            CardShape(
              width: 120,
              height: 80,
              color: Colors.blue,
              child: Stack(children: [
                Center(
                    child: Text(productName,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 24)))
              ]),
            ),
            Text("Дата создания $createdAt", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
            Text("Запланированная дата: $scheduledDate", style: TextStyle(color: Theme.of(context).primaryColor)),
            Text("Адрес: $address", style: TextStyle(color: Theme.of(context).primaryColor)),
            StatusWidget(status: status)
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final _orders = <ProductOrder>[];

  final int batchSize = 5;

  final ScrollController _scrollController = ScrollController();

  Future _updateOrders() async {
    getProductOrders(_orders.length, batchSize).then((orders) => {
          setState(() {
            _orders.addAll(orders);
          })
        });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _updateOrders();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateOrders();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    print("Количество заказов: ${_orders.length}");
    DateFormat formatter = DateFormat('dd.MM.yyyy hh:mm');

    return RefreshIndicator(
      onRefresh: _updateOrders,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _orders.length,
          itemBuilder: (context, i) {
            return OrderWidget(
                productName: _orders[i].productName,
                address: _orders[i].address,
                scheduledDate: formatter.format(_orders[i].scheduledDate!),
                createdAt: formatter.format(_orders[i].createdAt!),
                status: _orders[i].status!);
          }),
    );
  }
}
