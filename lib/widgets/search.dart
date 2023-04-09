import 'package:client/dto/profile.dart';
import 'package:client/requests/card_requests.dart';
import 'package:client/requests/request_f.dart';
import 'package:client/widgets/profile.dart';
import 'package:client/widgets/registration.dart';
import 'package:client/widgets/transfer_money.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../dto/debit_card.dart';
import '../requests/profile_request.dart';
import '../utils/validators.dart';
import '../vars/decorations.dart';
import 'card.dart';
import 'custom_text_field.dart';

class NextTransferButton extends StatelessWidget {
  final void Function()? onPressed;

  const NextTransferButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 60,
      margin: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xff08B0EC)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ))),
        onPressed: onPressed,
        // onPressed: () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => TransferMoneyWidget(
        //           selectedCardFrom: selectedCardFrom,
        //           selectedCardNumberTo: selectedCardNumberTo,
        //           profile: profile,
        //         ),
        //       ));
        // },
        child: const Text('Далее'),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Color(0xff08B0EC)),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
      ),
    );
  }
}

class SearchByPhoneWidget extends StatefulWidget {
  final DebitCard cardNumberFrom;

  const SearchByPhoneWidget({super.key, required this.cardNumberFrom});

  @override
  State<SearchByPhoneWidget> createState() => _SearchByPhoneWidgetState();
}

class _SearchByPhoneWidgetState extends State<SearchByPhoneWidget> {
  final phoneNumber = FieldState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("По номеру телефона"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 100,
              margin: const EdgeInsets.only(top: 100),
              child: CustomTextField(
                  labelText: "Номер телефона",
                  controller: phoneNumber.controller,
                  validator: phoneNumberValidator,
                  errorText: phoneNumber.error,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '+# (###) ###-##-##',
                        filter: {"#": RegExp(r'\d')},
                        type: MaskAutoCompletionType.lazy),
                  ]),
            ),



            NextTransferButton(
              onPressed: () async {

                Profile? profile = await makeRequestWithAuth(
                    context,
                        (accessToken) => findProfileByPhoneNumber(accessToken, phoneNumber.controller.text));

                if (profile == null) {
                  // TODO: сделать подпись
                  return;
                }

                List<String> cardNumbers = await makeRequestWithAuth(
                    context, (accessToken) => getAllCardNumbersByUserSub(accessToken, profile.sub)
                );

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectCardPage(cardFrom: widget.cardNumberFrom,cardNumbers: cardNumbers, profile: profile,)));
              },
            )
          ],
        ),
      ),
    );
  }
}


class SelectCardPage extends StatelessWidget {

  final DebitCard cardFrom;
  final Profile profile;
  final List<String> cardNumbers;

  static String? selectedCard;

  const SelectCardPage({
    super.key,
    required this.cardNumbers,
    required this.profile, required this.cardFrom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Выбор карты получателя"),),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 120),
              child: CardShape(
                width: 300,
                  height: 200,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(profile: profile)));
                    },
                    tileColor:
                    Theme.of(context).primaryColor.withOpacity(0.9),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    title: Text(
                        "${profile.lastName} ${profile.firstName}"),
                    subtitle: Center(child: FoundCardsDropdownList(cardNumbers: cardNumbers)),
                    leading: const CircleAvatar(),
                  )),
            ),
          ),
          NextTransferButton(
            onPressed: () {
              if (selectedCard == null) {
                return;
              }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransferMoneyWidget(
                            selectedCardFrom: cardFrom,
                            selectedCardNumberTo: selectedCard!,
                            profile: profile)));
              },
          )
        ],
      ),
    );
  }

}


class FoundCardsDropdownList extends StatefulWidget {
  final List<String> cardNumbers;

  const FoundCardsDropdownList({
    super.key,
    required this.cardNumbers
  });

  @override
  State<FoundCardsDropdownList> createState() => _FoundCardsDropdownListState();
}

class _FoundCardsDropdownListState extends State<FoundCardsDropdownList> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: const Text("Выберите карту"),
        borderRadius:
        const BorderRadius.all(Radius.circular(25)),
        dropdownColor:
        Theme.of(context).colorScheme.primary,
        style: TextStyle(
            color:
            Theme.of(context).colorScheme.onPrimary,
            fontSize: 16),
        itemHeight: 80,
        value: SelectCardPage.selectedCard,
        items: widget.cardNumbers
            .map((e) => DropdownMenuItem(
            value: e,
            child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(e)
            )))
            .toList(),
        onChanged: (item) => setState(() {
          SelectCardPage.selectedCard = item;
        }));
  }
}

class SearchByCardNumberWidget extends StatefulWidget {
  final DebitCard cardNumberFrom;

  const SearchByCardNumberWidget({super.key, required this.cardNumberFrom});

  @override
  State<SearchByCardNumberWidget> createState() =>
      _SearchByCardNumberWidgetState();
}

class _SearchByCardNumberWidgetState extends State<SearchByCardNumberWidget> {
  final cardNumber = FieldState();
  String notFountProfile = "";

  @override
  Widget build(BuildContext context) {
    var card = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 340,
        height: 220,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 100),
        decoration: beigeGoldFieldDecoration,
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: CustomTextField(
                    labelText: "Номер карты",
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: '#### #### #### ####',
                          filter: {"#": RegExp(r'\d')},
                          type: MaskAutoCompletionType.lazy),
                    ],
                    controller: cardNumber.controller))
          ],
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text("По номеру карты"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: card),
              Text(notFountProfile, style: const TextStyle(color: Colors.red)),
              NextTransferButton(
                onPressed: () {
                  var cardNumberTo =
                      cardNumber.controller.text.replaceAll(" ", "");

                  makeRequestWithAuth(
                          context,
                          (context) =>
                              findProfileByCardNumber(context, cardNumberTo))
                      .then((profile) {
                    if (profile == null) {
                      setState(() {
                        notFountProfile = "Нет пользователя с данной картой.";
                      });
                      return;
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransferMoneyWidget(
                                selectedCardFrom: widget.cardNumberFrom,
                                selectedCardNumberTo: cardNumberTo,
                                profile: profile)));
                  });

                  setState(() {
                    notFountProfile = "";
                  });
                },
              ),
            ],
          ),
        ));
  }
}
