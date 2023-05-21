import 'package:client/dto/product_order.dart';
import 'package:client/requests/request_f.dart';
import 'package:client/utils/formatters.dart';
import 'package:client/utils/validators.dart';
import 'package:client/widgets/card.dart';
import 'package:client/widgets/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../dto/product.dart';
import '../requests/product_order_requests.dart';
import '../requests/product_requеsts.dart';
import 'custom_text_field.dart';

class ProductWidget extends StatefulWidget {
  final String name;
  final double? rate;
  final List<int>? logo;
  final String? description;
  final int? period;

  const ProductWidget(
      {super.key,
      required this.name,
      this.rate,
      this.logo,
      this.description,
      this.period});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  var address = FieldState();
  var scheduledDate = FieldState();

  final formKey = GlobalKey<FormState>();

  void _makeOrderRequest() async {
    final isValidForm = formKey.currentState!.validate();

    if (!isValidForm) {
      return;
    }

    ProductOrder productOrder = ProductOrder(
        productName: widget.name,
        address: address.controller.text,
        scheduledDate: dateFormatter
            .parse(scheduledDate.controller.text));

    bool success = await makeRequestWithAuth(
        context, (token) => createProductOrder(token, productOrder));

    if (success) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                icon: Column(
                  children: [
                    Icon(Icons.access_time_filled),
                  ],
                ),
                title: Text("Заявка отправлена"),
                content: Text(
                    'Ваша заявка ожидает подтвеждения. Вы можете отследить статус заявки в разделе "Заявки"'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String description = "";
    if (widget.description != null) {
      description += widget.description!;
    }

    String rate = "";
    if (widget.rate != null) {
      rate += "${widget.rate!.toStringAsFixed(0)} руб/мес";
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CardShape(
              color: Colors.blue,
              child: Stack(children: [
                Center(
                    child: Text(widget.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24)))
              ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: Text(
                rate,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(
              width: 250,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 70),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    labelText: "Адрес",
                    controller: address.controller,
                    validator: nameValidator,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp(r'[^[А-Яа-я\d. ]'),
                          allow: false),
                      LengthLimitingTextInputFormatter(130)
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                      labelText: "Дата и время",
                      controller: scheduledDate.controller,
                      validator: dateValidator,
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '##.##.#### ##:##',
                            filter: {"#": RegExp(r'\d')},
                            type: MaskAutoCompletionType.lazy),
                      ]),
                ],
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all<Color>(
                    //     const Color(0xff08B0EC)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.onPrimary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ))),
                onPressed: _makeOrderRequest,
                child: const Text('Заказать'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _products = <Product>[];
  final int batchSize = 5;

  Future _updateProducts() async {
    getProducts(_products.length, batchSize).then((productList) => {
          setState(() {
            _products.addAll(productList);
          })
        });
  }

  @override
  void initState() {
    super.initState();
    _updateProducts();
  }

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CardWidget(
              name: _products[index].name,
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: ProductWidget(
                          name: _products[index].name,
                          description: _products[index].description,
                          rate: _products[index].rate,
                          logo: _products[index].logo,
                        ),
                      )),
            ),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: _products.length);
  }
}
