import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_web/view/info_label.dart';
import 'package:restobook_web/view/refreshable_future_list_view.dart';

import '../model/entities/restaurant.dart';
import '../view_model/restaurant_view_model.dart';

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
    restaurantLoading = Provider.of<RestaurantViewModel>(context, listen: false).loadActiveRestaurant(widget.restaurant.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: FutureBuilder(
              future: restaurantLoading,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Consumer<RestaurantViewModel>(builder: (BuildContext context, value, Widget? child) {
                  return Text(value.activeRestaurant!.name);
                },);
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
              child: RefreshableFutureListView(
                  future: restaurantLoading,
                  onRefresh: () async {
                    var promise = context.read<RestaurantViewModel>().loadActiveRestaurant(widget.restaurant.id!);
                    setState(() {
                      restaurantLoading = promise;
                    });
                    await promise;
                  },
                  listView: Consumer<RestaurantViewModel>(builder: (BuildContext context, RestaurantViewModel value, Widget? child) {
                    List<Widget> listWidgets = [
                      InfoLabel(label: "Название", info: value.activeRestaurant!.name),
                      InfoLabel(label: "Юридическое лицо", info: value.activeRestaurant!.legalEntityName),
                      InfoLabel(label: "ИНН", info: value.activeRestaurant!.inn),
                      InfoLabel(label: "Комментарий", info: value.activeRestaurant!.comment ?? "-"),
                      const Text("Сотрудники")
                    ];
                    for (var employee in value.activeRestaurantEmployees) {
                      listWidgets.add(Text(employee.shortFullName));
                    }
                    return ListView(physics: const AlwaysScrollableScrollPhysics(),children: listWidgets,);
                  },),
                  errorLabel: "Не удалось загрузить ресторан"
              ),
            ),
          ),
        ),
      ),
    );
  }
}