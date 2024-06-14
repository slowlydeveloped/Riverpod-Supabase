import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/orders_model.dart';
import '/models/vendor_model.dart';
import '../models/recipe_creation.dart';
import '../models/recipe_model.dart';
import '/exceptions/exceptions.dart';
import '/models/items_model.dart';

class AdminFunctions extends StateNotifier<void> {
  final SupabaseClient supabaseClient;

  AdminFunctions(this.supabaseClient) : super(null);

  // Method to add vendors to the database
  Future<VendorModel> addVendors(VendorModel vendors) async {
    try {
      // Inserting vendor data into the 'vendors' table
      final vendor = await supabaseClient
          .from('vendors')
          .insert(vendors.toJson())
          .select();
      return VendorModel.fromJson(vendor.first); // Returning the response
    } catch (e) {
      // Catching any exceptions and throwing a custom ServerException
      throw ServerException(e.toString());
    }
  }

  // Method to fetch vendors from the database
  Future<List<VendorModel>> fetchVendors() async {
    try {
      // Fetching vendor data from the 'vendors' table
      final vendors = await supabaseClient.from('vendors').select();
      // Mapping the response to VendorModel objects and returning as a list
      return vendors
          .map<VendorModel>((data) => VendorModel.fromJson(data))
          .toList();
    } catch (e) {
      print("While fetching data  ${e}");
      throw ServerException(e.toString());
    }
  }

  // Method to add items to the database
  Future<ItemModel> addItems(ItemModel items) async {
    try {
      // Inserting item data into the 'items' table
      final response =
          await supabaseClient.from('items').insert(items.toJson()).select();

      return ItemModel.fromJson(
          response.first); // Returning the first item from the response
    } catch (e) {
      print('Error adding item: $e'); // Printing the error for debugging
      throw ServerException(e.toString()); // Throwing a custom ServerException
    }
  }

  // Method to fetch items from the database
  Future<List<ItemModel>> fetchItems() async {
    try {
      // Fetching items data from the 'items' table along with vendor names
      final response =
          await supabaseClient.from('items').select('*, vendors(vendorsname)');
      print(response);
      // Mapping the response data to ItemModel objects and returning as a list
      return response
          .map<ItemModel>((data) => ItemModel.fromJson(data)
              .copyWith(vendorname: data['vendors']['vendorsname']))
          .toList();
    } catch (e) {
      print('Error fetching items: $e'); // Printing the error for debugging
      throw ServerException(e.toString()); // Throwing a custom ServerException
    }
  }

  // Method to add recipes to the recipe table
  Future<RecipeModel> addRecipe(RecipeModel recipes) async {
    try {
      final recipe =
          await supabaseClient.from('recipe').insert(recipes.toJson()).select();
      return RecipeModel.fromJson(recipe.first);
    } catch (e) {
      print("Error while adding Recipes ${e}");
      throw ServerException(e.toString());
    }
  }

  // Method to fetch recipes from the database
  Future<List<RecipeModel>> fetchRecipes() async {
    try {
      final recipes = await supabaseClient.from('recipe').select();

      // Mapping the response data to RecipeModel objects and returning as a list
      return recipes
          .map<RecipeModel>((data) => RecipeModel.fromJson(data))
          .toList();
    } catch (e) {
      print("While fetching recipes present. ${e}");
      throw ServerException(e.toString());
    }
  }

  // Method to create the recipe using ingredients.
  Future<RecipeCreationModel> createRecipe(
      RecipeCreationModel recipeCreation) async {
    try {
      final recipeCreated = await supabaseClient
          .from('recipe_creation')
          .insert(recipeCreation.toJson())
          .select();
      return RecipeCreationModel.fromJson(recipeCreated.first);
    } catch (e) {
      print(" WHile creating recipe :: ${e}");
      throw ServerException(e.toString());
    }
  }

  // Method to create orders with multiple items
  Future<void> createOrder(
      OrderModel order, List<OrderItemModel> orderItems) async {
    try {
      // Inserting order data into the 'orders' table
      final response =
          await supabaseClient.from('orders').insert(order.toJson()).select();
      final orderId = response.first['id'];

      // Inserting each order item into the 'order_items' table
      for (var orderItem in orderItems) {
        orderItem.orderId = orderId;
        await supabaseClient.from('order_items').insert(orderItem.toJson());
      }
    } catch (e) {
      print('Error creating order: $e');
      throw ServerException(e.toString());
    }
  }

  // Method to fetch order items from the database
  Future<List<OrderItemModel>> fetchOrderItems() async {
    try {
      final orders = await supabaseClient
          .from('order_items')
          .select('*, recipe(recipe_name)');
      // Mapping the response data to OrderItemModel objects and returning as a list
      return orders
          .map<OrderItemModel>((data) => OrderItemModel.fromJson(data)
              .copyWith(recipeName: data['recipe']['recipe_name']))
          .toList();
    } catch (e) {
      print("Error while fetching orders  ${e}");
      throw ServerException(e.toString());
    }
  }
}

// Provider for providing the SupabaseClient instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider for providing the AdminFunctions instance for adding vendors
final addVendorProvider = StateNotifierProvider<AdminFunctions, void>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AdminFunctions(supabaseClient);
});

// Provider for providing the AdminFunctions instance for adding items
final addItemsProvider = StateNotifierProvider<AdminFunctions, void>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AdminFunctions(supabaseClient);
});

// Provider for providing the AdminFunctions instance for adding recipes
final addRecipeProvider = StateNotifierProvider<AdminFunctions, void>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AdminFunctions(supabaseClient);
});

// Provider for fetching recipes and sorting them alphabetically
final fetchRecipesProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final adminFunctions = AdminFunctions(supabaseClient);
  final recipes = await adminFunctions.fetchRecipes();
  // Command to sort the recipe list alphabetically
  recipes.sort((a, b) => a.recipeName.compareTo(b.recipeName));
  return recipes;
});

final createRecipeProvider = StateNotifierProvider<AdminFunctions, void>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AdminFunctions(supabaseClient);
});

// Provider for fetching vendors
final fetchVendorsProvider = FutureProvider<List<VendorModel>>((ref) async {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final adminFunctions = AdminFunctions(supabaseClient);
  return adminFunctions.fetchVendors();
});

// Provider for fetching items
final fetchItemsProvider = FutureProvider<List<ItemModel>>((ref) async {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final adminFunctions = AdminFunctions(supabaseClient);
  return adminFunctions.fetchItems();
});

// Provider for fetching order items
final viewOrderProvider = FutureProvider<List<OrderItemModel>>((ref) async {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final adminFunctions = AdminFunctions(supabaseClient);
  return adminFunctions.fetchOrderItems();
});

// Provider for creating recipes
final recipeCreationProvider =
    StateNotifierProvider<AdminFunctions, void>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AdminFunctions(supabaseClient);
});

// Provider for creating orders in the database
final createOrderProvider = StateNotifierProvider<AdminFunctions, void>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AdminFunctions(supabaseClient);
});
