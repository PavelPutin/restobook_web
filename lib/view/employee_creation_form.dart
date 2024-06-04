import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/entities/employee.dart';
import '../view_model/restaurant_view_model.dart';

class EmployeeCreationForm extends StatefulWidget {
  const EmployeeCreationForm({super.key});

  @override
  State<EmployeeCreationForm> createState() => _EmployeeCreationFormState();
}

class _EmployeeCreationFormState extends State<EmployeeCreationForm> {
  Future<void> submiting = Future.delayed(Duration.zero);

  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final commentController = TextEditingController();
  final passwordController = TextEditingController();

  bool loginIsUnique = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: const Text("Добавление администратора"),
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
                        controller: loginController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "Логин администратора*",
                            errorText: loginIsUnique ? null : "Этот логин уже занят"
                        ),
                        validator: _nameValidator,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: surnameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Фамилия администратора*"),
                        validator: _nameValidator,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Имя администратора*"),
                        validator: _nameValidator,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: patronymicController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Отчество администратора"),
                        validator: _patronymicValidator,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Пароль администратора*"),
                        validator: _nameValidator,
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

                                return const Text("Добавить администратора");
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

  String? _patronymicValidator(String? value) {
    if (!(value == null || value.trim().isEmpty) && value.length > 512) {
      return "Максимальная длина 512 символов";
    }

    return null;
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      final password = passwordController.text;
      Employee created = Employee(
          null,
          loginController.text.trim(),
          surnameController.text.trim(),
          nameController.text.trim(),
          patronymicController.text.trim().isEmpty
              ? null
              : patronymicController.text.trim(),
          commentController.text.trim().isEmpty
              ? null
              : commentController.text.trim(),
          false,
          context.read<RestaurantViewModel>().activeRestaurant!.id!);

      setState(() {
        loginIsUnique = true;
        submiting = context.read<RestaurantViewModel>().createAdmin(created, password, "restobook_admin");
        submiting.then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Администратор успешно добавлен")));
          Navigator.of(context).pop();
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Не удалось добавить администратора")));
          if (error == "Login must be unique") {
            setState(() {
              loginIsUnique = false;
            });
          }
        });
      });
    }
  }
}