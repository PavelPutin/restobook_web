import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_web/view/password_textfield.dart';
import 'package:restobook_web/view/restaurants_overview_screen.dart';
import '../view_model/application_view_model.dart';
import 'default_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  Future<void> submiting = Future.delayed(const Duration(seconds: 0));
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Вход",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: DefaultTextField(
                            controller: _loginController,
                            labelText: "Логин",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Поле обязательное";
                              }
                              if (value.length > 512) {
                                return "Логин не должен быть длиннее 512 символов";
                              }
                              return null;
                            },
                            // onChange: (value) {
                            //   if (value != null) {
                            //     _loginController.value =
                            //         TextEditingValue(text: value.toLowerCase());
                            //   }
                            // },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: PasswordTextField(
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Поле обязательное";
                                  }
                                  return null;
                                }))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton(
                          onPressed: submit,
                          child: FutureBuilder(
                              future: submiting,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                return const Text("Войти");
                              })),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void submit() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        submiting = context
            .read<ApplicationViewModel>()
            .login(_loginController.text, _passwordController.text);
        submiting.then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const RestaurantsOverviewScreen()));
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Добро пожаловать")));
        });
        submiting.onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Не удалось войти. Неверный логин или пароль")));
        });
      });
    }
  }
}
