import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_providers.dart';

class ViewOrders extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ViewOrders());
  const ViewOrders({super.key});

  @override
  ViewOrdersState createState() => ViewOrdersState();
}

class ViewOrdersState extends ConsumerState<ViewOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer(
                  builder: (context, ref, child) {
                    final itemsFuture = ref.watch(viewOrderProvider);
                    return itemsFuture.when(
                      data: (items) => ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${item.recipeName}"),
                                  Text("${item.price}"),
                                 Text("${item.quantity}")
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
    );
  }
}
