import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_web/view/employee_creation_form.dart';
import 'package:restobook_web/view/info_label.dart';
import 'package:restobook_web/view/refreshable_future_list_view.dart';

import '../model/entities/restaurant.dart';
import '../view_model/restaurant_view_model.dart';
import 'delete_icon_button.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late Future<void> restaurantLoading;

  @override
  void initState() {
    super.initState();
    restaurantLoading = Provider.of<RestaurantViewModel>(context, listen: false)
        .loadActiveRestaurant(widget.restaurant.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: FutureBuilder(
            future: restaurantLoading,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Consumer<RestaurantViewModel>(
                builder: (BuildContext context, value, Widget? child) {
                  return Row(
                    children: [
                      Text(value.activeRestaurant!.name),
                      DeleteIconButton(
                        dialogTitle: const Text("Удалить ресторан"),
                        onSubmit: () {
                          return context.read<RestaurantViewModel>().delete(
                            context.read<RestaurantViewModel>().activeRestaurant!
                          );
                        },
                        successLabel: "Ресторан удалён",
                        errorLabel: "Не удалось удалить ресторан",
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
              child: RefreshableFutureListView(
                  future: restaurantLoading,
                  onRefresh: () async {
                    var promise = context
                        .read<RestaurantViewModel>()
                        .loadActiveRestaurant(widget.restaurant.id!);
                    setState(() {
                      restaurantLoading = promise;
                    });
                    await promise;
                  },
                  listView: Consumer<RestaurantViewModel>(
                    builder: (BuildContext context, RestaurantViewModel value,
                        Widget? child) {
                      List<Widget> listWidgets = [
                        InfoLabel(
                            label: "Название",
                            info: value.activeRestaurant!.name),
                        InfoLabel(
                            label: "Юридическое лицо",
                            info: value.activeRestaurant!.legalEntityName),
                        InfoLabel(
                            label: "ИНН", info: value.activeRestaurant!.inn),
                        InfoLabel(
                            label: "Комментарий",
                            info: value.activeRestaurant!.comment ?? "-"),
                        Text("Сотрудники:",
                            style: Theme.of(context).textTheme.headlineSmall)
                      ];
                      for (var employee in value.activeRestaurantEmployees) {
                        listWidgets.add(Text(employee.shortFullName));
                      }
                      if (value.activeRestaurantEmployees.isEmpty) {
                        listWidgets.add(
                            Text("В ресторане не зарегистрированы сотрудники"));
                      }
                      listWidgets.add(Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const EmployeeCreationForm()));
                              },
                              child: const Text("Добавить администратора"))));
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: listWidgets,
                      );
                    },
                  ),
                  errorLabel: "Не удалось загрузить ресторан"),
            ),
          ),
        ),
      ),
    );
  }
}
