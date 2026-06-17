import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item_entity.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import 'add_item_bottom_sheet.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final ItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(item.name.isNotEmpty ? item.name[0].toUpperCase() : ''),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹${item.price.toStringAsFixed(2)} / ${item.unit} (${item.category})'),
        onLongPress: () {
          _showOptions(context);
        },
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bCtx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Item'),
              onTap: () {
                Navigator.pop(bCtx);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddItemBottomSheet(item: item),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Item', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(bCtx);
                _showConfirmDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Remove Item?'),
        content: const Text('Are you sure you want to delete this item from your catalog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<CatalogBloc>().add(DeleteCatalogItem(itemId: item.id!));
              Navigator.pop(dCtx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
