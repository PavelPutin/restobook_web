import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RefreshableFutureListView extends StatefulWidget {
  const RefreshableFutureListView({super.key, required this.tablesLoading, required this.onRefresh, required this.listView, required this.errorLabel});

  final String errorLabel;
  final AsyncCallback onRefresh;
  final Future<void> tablesLoading;
  final Widget listView;

  @override
  State<RefreshableFutureListView> createState() => _RefreshableFutureListViewState();
}

class _RefreshableFutureListViewState extends State<RefreshableFutureListView> {
  bool _refreshing = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _refreshing = true;
        });
        await widget.onRefresh();
      },
      child: FutureBuilder(
        future: widget.tablesLoading,
        builder: (ctx, snapshot) {
          if (!_refreshing && snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.errorLabel),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _refreshing = false;
                        });
                        widget.onRefresh();
                      },
                      child: const Text("Попробовать ещё раз"))
                ],
              ),
            );
          }

          return widget.listView;
        },
      ),
    );
  }
}