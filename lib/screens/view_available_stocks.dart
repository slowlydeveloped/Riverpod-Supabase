import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_providers.dart';

class AvailableStockPage extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const AvailableStockPage());
  const AvailableStockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableStockFuture = ref.watch(fetchAvailableStockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Stock"),
      ),
      body: Center(
        child: availableStockFuture.when(
          data: (availableStock) => ListView.builder(
            itemCount: availableStock.length,
            itemBuilder: (context, index) {
              final stock = availableStock[index];
              return ListTile(
                title: Text(stock.itemName),
                subtitle: Text('Remaining Stock: ${stock.remainingStock}'),
              );
            },
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}