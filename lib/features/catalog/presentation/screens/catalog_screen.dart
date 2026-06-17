import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';
import '../widgets/add_item_bottom_sheet.dart';
import '../widgets/item_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(const LoadCatalogItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Catalog'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddItemBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CatalogBloc, CatalogState>(
        listener: (context, state) {
          if (state is CatalogItemOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Operation Successful!')),
            );
          } else if (state is CatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CatalogLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const Center(child: Text('No items in catalog. Tap + to add!'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemCard(item: items[index]);
              },
            );
          }
          return const Center(child: Text('Press refresh or add items.'));
        },
      ),
    );
  }
}
