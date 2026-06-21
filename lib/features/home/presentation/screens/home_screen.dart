import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderease/core/localization/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/constants/icon_constants.dart';
import '../../../order/domain/entities/order_line_item_entity.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../catalog/domain/entities/item_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeItems());
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: (theme.brightness == Brightness.dark)
            ? Image.asset("assets/orderease_light_logo.png", width: 28, height: 28)
            : Image.asset("assets/orderease_logo.png", width: 28, height: 28),
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            String shopName = 'OrderEase';
            if (profileState is ProfileLoadedState) {
              shopName = profileState.profile.shopName;
            }
            return Text(
              shopName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: primaryColor,
              ),
            );
          },
        ),
        actions: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded) {
                return ViewModeToggle(
                  isGrouped: state.isGrouped,
                  onChanged: () {
                    context.read<HomeBloc>().add(const ToggleViewMode());
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded && state.cartCount > 0) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  final lineItems = <OrderLineItemEntity>[];
                  state.cart.forEach((itemId, qty) {
                    final item = state.items.firstWhere((i) => i.id == itemId);
                    lineItems.add(OrderLineItemEntity(
                      itemName: item.name,
                      unit: item.unit,
                      quantity: qty,
                      pricePerUnit: item.price,
                      lineTotal: item.price * qty,
                    ));
                  });
                  context.push(AppRoutes.orderPreview, extra: lineItems);
                },
                icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                label: Text(
                  '${l10n.previewOrderButton} (${state.cartCount})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return Center(child: Text(l10n.noItemsMessage));
            }

            if (state.isGrouped) {
              // Group items by category
              final grouped = <String, List<dynamic>>{};
              for (var it in items) {
                grouped.putIfAbsent(it.category, () => []).add(it);
              }

              return ListView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
                children: grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      ...entry.value.map((it) {
                        final qty = state.cart[it.id] ?? 0;
                        return _ItemCard(
                          item: it,
                          quantity: qty,
                          onAdd: () => context.read<HomeBloc>().add(AddToCart(itemId: it.id!)),
                          onRemove: () => context.read<HomeBloc>().add(RemoveFromCart(itemId: it.id!)),
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final it = items[index];
                final qty = state.cart[it.id] ?? 0;
                return _ItemCard(
                  item: it,
                  quantity: qty,
                  onAdd: () => context.read<HomeBloc>().add(AddToCart(itemId: it.id!)),
                  onRemove: () => context.read<HomeBloc>().add(RemoveFromCart(itemId: it.id!)),
                );
              },
            );
          }
          return Center(child: Text(l10n.loadingMessage));
        },
      ),
    );
  }
}

class ViewModeToggle extends StatelessWidget {
  const ViewModeToggle({
    super.key,
    required this.isGrouped,
    required this.onChanged,
  });

  final bool isGrouped;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : const Color(0xFFEBEFEA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: isGrouped ? onChanged : null,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: !isGrouped ? theme.colorScheme.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.format_list_bulleted,
                size: 20,
                color: !isGrouped ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: !isGrouped ? onChanged : null,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isGrouped ? theme.colorScheme.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.grid_view,
                size: 20,
                color: isGrouped ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemQuantityCounter extends StatelessWidget {
  const ItemQuantityCounter({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final hasQty = quantity > 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: hasQty ? onRemove : null,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.remove,
              size: 18,
              color: hasQty ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 20,
          child: Center(
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: hasQty ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.add,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final ItemEntity item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  String _formatUnit(BuildContext context, String unit) {
    final l10n = AppLocalizations.of(context)!;
    final lower = unit.toLowerCase();
    if (lower == 'kg') return l10n.localeName == 'hi' ? '1 किलोग्राम' : '1kg';
    if (lower == 'litre') return l10n.localeName == 'hi' ? '1 लीटर' : '1L';
    if (lower == 'ml') return '500ml';
    if (lower == 'gram') return '500g';
    if (lower == 'unit') return l10n.unitUnit;
    if (lower == 'packet') return l10n.unitPacket;
    if (lower == 'dozen') return l10n.unitDozen;
    return unit;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final iconConfig = IconConstants.getIconConfig(item.iconId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? iconConfig.backgroundColor.withOpacity(0.2) : iconConfig.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconConfig.icon,
                color: isDark ? theme.colorScheme.primary : iconConfig.foregroundColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatUnit(context, item.unit),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            ItemQuantityCounter(
              quantity: quantity,
              onAdd: onAdd,
              onRemove: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
