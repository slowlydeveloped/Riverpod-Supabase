import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/orders_model.dart';
import '../providers/admin_providers.dart';

class CreateOrderPage extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateOrderPage());
  const CreateOrderPage({super.key});

  @override
  ConsumerState<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends ConsumerState<CreateOrderPage> {
  final totalPriceController = TextEditingController();
  final List<TextEditingController> recipeIds = [];
  final List<TextEditingController> quantities = [];
  final List<TextEditingController> prices = [];

  void addItemFields() {
    setState(() {
      recipeIds.add(TextEditingController());
      quantities.add(TextEditingController());
      prices.add(TextEditingController());
    });
  }

  void removeItemFields(int index) {
    setState(() {
      recipeIds.removeAt(index);
      quantities.removeAt(index);
      prices.removeAt(index);
    });
  }

  @override
  void dispose() {
    totalPriceController.dispose();
    for (var controller in recipeIds) {
      controller.dispose();
    }
    for (var controller in quantities) {
      controller.dispose();
    }
    for (var controller in prices) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: totalPriceController,
              decoration: const InputDecoration(labelText: 'Total Price'),
              keyboardType: TextInputType.number,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recipeIds.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: recipeIds[index],
                          decoration:const InputDecoration(labelText: 'Item ID'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: quantities[index],
                          decoration: const InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: prices[index],
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => removeItemFields(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: addItemFields,
              child:const Text('Add Item'),
            ),
            ElevatedButton(
              onPressed: () {
                final order = OrderModel(
                  totalPrice: double.parse(totalPriceController.text),
                );

                final orderItems = List.generate(recipeIds.length, (index) {
                  return OrderItemModel(
                    recipeId: int.parse(recipeIds[index].text),
                    quantity: int.parse(quantities[index].text),
                    price: int.parse(prices[index].text),
                  );
                });
                ref
                    .read(adminFunctionsProvider.notifier)
                    .createOrder(order, orderItems);
              },
              child: const Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
