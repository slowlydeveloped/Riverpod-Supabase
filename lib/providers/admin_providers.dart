import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task1/models/available_stocks.dart';

import '../models/orders_model.dart';
import '/models/vendor_model.dart';
import '../models/recipe_creation.dart';
import '../models/recipe_model.dart';
import '/exceptions/exceptions.dart';
import '/models/items_model.dart';

class AdminFunctions extends StateNotifier<void> {
  final SupabaseClient supabaseClient;

  AdminFunctions(this.supabaseClient) : super(null);

  Future<T> _insertAndReturn<T>(String table, Map<String, dynamic> data,
      T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await supabaseClient.from(table).insert(data).select();
      return fromJson(response.first);
    } catch (e) {
      print("error  ${e}");
      throw ServerException(e.toString());
    }
  }

  Future<List<AvailableStockModel>> fetchAvailableStock() async {
    try {
      final response = await supabaseClient.from('available_stock').select();
      print(response);
      return response
          .map<AvailableStockModel>(
              (data) => AvailableStockModel.fromJson(data))
          .toList();
    } catch (e) {
      print("Erro fetching available stocks ${e}");
      throw ServerException(e.toString());
    }
  }

  Future<List<T>> _fetchAndReturnList<T>(
      String table, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await supabaseClient.from(table).select();
      return response.map<T>((data) => fromJson(data)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<VendorModel> addVendors(VendorModel vendor) async {
    return _insertAndReturn('vendors', vendor.toJson(), VendorModel.fromJson);
  }

  Future<List<VendorModel>> fetchVendors() async {
    return _fetchAndReturnList('vendors', VendorModel.fromJson);
  }

  Future<ItemModel> addItems(ItemModel item) async {
    return _insertAndReturn('items', item.toJson(), ItemModel.fromJson);
  }

  Future<List<ItemModel>> fetchItems() async {
    final response =
        await supabaseClient.from('items').select('*, vendors(vendorsname)');
    return response
        .map<ItemModel>((data) => ItemModel.fromJson(data)
            .copyWith(vendorname: data['vendors']['vendorsname']))
        .toList();
  }

  Future<RecipeModel> addRecipe(RecipeModel recipe) async {
    return _insertAndReturn('recipe', recipe.toJson(), RecipeModel.fromJson);
  }

  Future<List<RecipeModel>> fetchRecipes() async {
    final recipes = await _fetchAndReturnList('recipe', RecipeModel.fromJson);
    recipes.sort((a, b) => a.recipeName.compareTo(b.recipeName));
    return recipes;
  }

  Future<RecipeCreationModel> createRecipe(
      RecipeCreationModel recipeCreation) async {
    return _insertAndReturn('recipe_creation', recipeCreation.toJson(),
        RecipeCreationModel.fromJson);
  }

  Future<void> createOrder(
      OrderModel order, List<OrderItemModel> orderItems) async {
    try {
      final response =
          await supabaseClient.from('orders').insert(order.toJson()).select();
      final orderId = response.first['id'];
      for (var orderItem in orderItems) {
        orderItem.orderId = orderId;
        await supabaseClient.from('order_items').insert(orderItem.toJson());
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<OrderItemModel>> fetchOrderItems() async {
    final orders = await supabaseClient
        .from('order_items')
        .select('*, recipe(recipe_name)');
    return orders
        .map<OrderItemModel>((data) => OrderItemModel.fromJson(data)
            .copyWith(recipeName: data['recipe']['recipe_name']))
        .toList();
  }
}

final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final adminFunctionsProvider =
    StateNotifierProvider<AdminFunctions, void>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AdminFunctions(supabaseClient);
});

final fetchAvailableStockProvider =
    FutureProvider<List<AvailableStockModel>>((ref) async {
  final adminFunctions = ref.watch(adminFunctionsProvider.notifier);
  return adminFunctions.fetchAvailableStock();
});

final fetchRecipesProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final adminFunctions = ref.watch(adminFunctionsProvider.notifier);
  return adminFunctions.fetchRecipes();
});

final fetchVendorsProvider = FutureProvider<List<VendorModel>>((ref) async {
  final adminFunctions = ref.watch(adminFunctionsProvider.notifier);
  return adminFunctions.fetchVendors();
});

final fetchItemsProvider = FutureProvider<List<ItemModel>>((ref) async {
  final adminFunctions = ref.watch(adminFunctionsProvider.notifier);
  return adminFunctions.fetchItems();
});

final viewOrderProvider = FutureProvider<List<OrderItemModel>>((ref) async {
  final adminFunctions = ref.watch(adminFunctionsProvider.notifier);
  return adminFunctions.fetchOrderItems();
});
