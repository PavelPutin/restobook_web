import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_web/view/refreshable_future_list_view.dart';
import 'package:restobook_web/view/restaurant_creation_form.dart';
import 'package:restobook_web/view/restaurant_tile.dart';
import 'package:restobook_web/view_model/restaurant_view_model.dart';

class RestaurantsOverviewScreen extends StatefulWidget {
  const RestaurantsOverviewScreen({super.key});

  @override
  State<RestaurantsOverviewScreen> createState() => _RestaurantsOverviewScreenState();
}

class _RestaurantsOverviewScreenState extends State<RestaurantsOverviewScreen> {

  late Future<void> restaurantsLoading;

  @override
  void initState() {
    super.initState();
    restaurantsLoading = Provider.of<RestaurantViewModel>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Рестораны в Restobook")),),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
              child: Consumer<RestaurantViewModel>(
                builder: (BuildContext context, RestaurantViewModel value, Widget? child) {
                  Widget listContent;
                  if (value.restaurants.isEmpty) {
                    listContent = const Center(child: Text("Нет созданных ресторанов"));
                  } else {
                    listContent = ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: value.restaurants.length,
                        itemBuilder: (context, index) => RestaurantTile(restaurant: value.restaurants[index]));
                  }
                  return RefreshableFutureListView(
                      future: restaurantsLoading,
                      onRefresh: () async {
                        var promise = context.read<RestaurantViewModel>().load();
                        setState(() {
                          restaurantsLoading = promise;
                        });
                        await promise;
                      },
                      listView: listContent,
                      errorLabel: "Не удалось загрузить рестораны");
                },),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RestaurantCreationForm())
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Создать ресторан"),
      ),
    );
  }
}