import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_search_app/view/restaurant_view_model.dart';

//This widget tree to listen to changes on provider, so that the UI automatically updates
class RestaurantList extends ConsumerWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantViewModelProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant App'),
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search by name or cuisine ....',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                  ref.read(restaurantViewModelProvider.notifier).searchItem(value);
                },
              ),
            ),

            // expand is used as the search query is type the list will only show the matched query data
            Expanded(
              child: data.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.cuisine),
                        );
                      }),
            )
          ],
        ));
  }
}
