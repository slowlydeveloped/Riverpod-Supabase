import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task1/screens/create_orders.dart';
import 'package:task1/utils/common_button.dart';

import '../providers/admin_providers.dart';

class ManagerPage extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ManagerPage());
  const ManagerPage({super.key});

  @override
  ConsumerState<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends ConsumerState<ManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Page"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final itemsFuture = ref.watch(fetchRecipesProvider);
                    return itemsFuture.when(
                      data: (items) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.recipeName),
                                  Text('Price: ₹ ${item.recipePrice}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    );
                  },
                ),
              ),
            ),
            CommonButton(
                title: "Make Order",
                onPressed: () {
                  Navigator.push(context, CreateOrderPage.route());
                })
          ],
        ),
      ),
    );
  }
}
