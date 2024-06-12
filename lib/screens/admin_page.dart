import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task1/screens/add_items.dart';
import 'package:task1/screens/add_recipe.dart';
import 'package:task1/screens/view_orders.dart';
import 'package:task1/utils/common_button.dart';

import 'add_vendors.dart';

class AdminPage extends ConsumerWidget {
  static route() => MaterialPageRoute(builder: (context) => const AdminPage());

  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonButton(
                title: "Add Recipe ",
                onPressed: () {
                  Navigator.push(context, AddRecipe.route());
                }),
            const SizedBox(height: 18),
            CommonButton(
              title: "Add Vendors",
              onPressed: () {
                Navigator.push(context, AddVendors.route());
              },
            ),
            const SizedBox(height: 18),
            CommonButton(
              title: "Get Items",
              onPressed: () {
                Navigator.push(context, AddItems.route());
              },
            ),
             const SizedBox(height: 18),
            CommonButton(
              title: "View Orders",
              onPressed: () {
                Navigator.push(context, ViewOrders.route());
              },
            ),
          ],
        ),
      ),
    );
  }
}
