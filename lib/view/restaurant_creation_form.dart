import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_web/model/entities/restaurant.dart';
import 'package:restobook_web/view/restaurant_screen.dart';
import 'package:restobook_web/view_model/restaurant_view_model.dart';

class RestaurantCreationForm extends StatefulWidget {
  const RestaurantCreationForm({super.key});

  @override
  State<RestaurantCreationForm> createState() => _RestaurantCreationFormState();
}

class _RestaurantCreationFormState extends State<RestaurantCreationForm> {
  Future<void> submiting = Future.delayed(Duration.zero);

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController legalEntityNameController =
      TextEditingController();
  final TextEditingController innController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: const Text("Создание ресторана"),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Название*"),
                        validator: _nameValidator,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: legalEntityNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Название юридического лица*"),
                        validator: _nameValidator,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: innController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "ИНН*"),
                        validator: _innValidator,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: commentController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Комментарий"),
                        maxLines: null,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: OutlinedButton(
                            onPressed: submit,
                            child: FutureBuilder(
                              future: submiting,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                return const Text("Создать ресторан");
                              },
                            )))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Обязательное поле";
    }

    if (value.length > 512) {
      return "Максимальная длина 512 символов";
    }
    return null;
  }

  final _digits = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

  String? _innValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Обязательное поле";
    }

    if (value.length != 10) {
      return "Неправильный ИНН. Должно быть 10 цифр";
    }

    for (var ch in value.characters) {
      if (!_digits.contains(ch)) {
        return "Нечисловое значение";
      }
    }

    return null;
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      Restaurant created = Restaurant(
          null,
          nameController.text.trim(),
          legalEntityNameController.text.trim(),
          innController.text.trim(),
          commentController.text.trim().isEmpty
              ? null
              : commentController.text.trim());

      setState(() {
        submiting = context.read<RestaurantViewModel>().add(created);
        submiting.then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ресторан успешно создан")));
          Navigator.of(context)
              .pushReplacement(
              MaterialPageRoute(builder: (context) =>
                  RestaurantScreen(
                      restaurant:
                      context.read<RestaurantViewModel>().activeRestaurant!)
              )
          );
        });
      });
    }
  }
}
