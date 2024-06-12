import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task1/models/vendor_model.dart';
import '../utils/common_textfied.dart';
import '/utils/common_button.dart';

import '../providers/admin_providers.dart';

class AddVendors extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddVendors());
  const AddVendors({super.key});

  @override
  AddVendorsState createState() => AddVendorsState();
}

class AddVendorsState extends ConsumerState<AddVendors> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Vendors"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              CustomTextFormField(
                hintText: "Enter the name",
                controller: nameController,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                hintText: "Enter the number",
                controller: numberController,
              ),
              const SizedBox(height: 12),
              CommonButton(
                title: "Add",
                onPressed: () {
                  final vendors = VendorModel(
                      name: nameController.text, number: numberController.text);
                  ref.read(addVendorProvider.notifier).addVendors(vendors);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final itemsFuture = ref.watch(fetchVendorsProvider);
                    ref.refresh(fetchVendorsProvider);
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
                                  Text("Vendor's Name: ${item.name}"),
                                  const SizedBox(height: 12),
                                  Text("Vendor's Number: ${item.number}"),
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
            ],
          ),
        ),
      ),
    );
  }
}
