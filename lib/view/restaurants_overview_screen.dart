import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restobook_web/view/refreshable_future_list_view.dart';
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
      appBar: AppBar(title: const Text("Рестораны в Restobook"),),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
              child: Consumer<RestaurantViewModel>(
                builder: (BuildContext context, RestaurantViewModel value, Widget? child) {
                  return RefreshableFutureListView(
                      tablesLoading: restaurantsLoading,
                      onRefresh: () async {
                        var promise = context.read<RestaurantViewModel>().load();
                        setState(() {
                          restaurantsLoading = promise;
                        });
                        await promise;
                      },
                      listView: ListView.builder(itemCount: value.restaurants.length, itemBuilder: (context, index) => Text(value.restaurants[index].name)),
                      errorLabel: "Не удалось загрузить рестораны");
                },),
            ),
          ),
        ),
      ),
    );
  }
}