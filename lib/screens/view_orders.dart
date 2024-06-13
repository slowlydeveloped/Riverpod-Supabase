import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/orders_model.dart';
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
      appBar: AppBar(
        title: const Text("View Orders"),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final itemsFuture = ref.watch(viewOrderProvider);
            return itemsFuture.when(
              data: (items) {
                final Map<int, List<OrderItemModel>> groupedItems = {};
                for (var item in items) {
                  groupedItems.putIfAbsent(item.orderId!, () => []).add(item);
                }
                return ListView.builder(
                  itemCount: groupedItems.length,
                  itemBuilder: (context, index) {
                    final orderId = groupedItems.keys.elementAt(index);
                    final orderItems = groupedItems[orderId]!;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order ID: $orderId"),
                            ...orderItems.map((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Recipe: ${item.recipeName}"),
                                      Text("Price: ₹${item.price}"),
                                      Text("Quantity: ${item.quantity}"),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            );
          },
        ),
      ),
    );
  }
}
