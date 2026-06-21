import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderease/core/localization/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.menu, color: primaryColor),
        //   onPressed: () {},
        // ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            l10n.catalogTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: primaryColor,
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.shopping_cart_outlined, color: primaryColor),
        //     onPressed: () {},
        //   ),
        // ],

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: theme.colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => const AddItemBottomSheet(),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
      body: BlocConsumer<CatalogBloc, CatalogState>(
        listener: (context, state) {
          if (state is CatalogItemOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.localeName == 'hi' ? 'सफलतापूर्वक कार्य संपन्न हुआ!' : 'Operation Successful!')),
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
              return Center(child: Text(l10n.noItemsMessage));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemCard(item: items[index]);
              },
            );
          }
          return Center(child: Text(l10n.localeName == 'hi' ? 'आइटम लोड करने के लिए रीफ्रेश करें' : 'Press refresh or add items.'));
        },
      ),
    );
  }
}
