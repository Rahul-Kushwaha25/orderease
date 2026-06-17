import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../../domain/entities/order_line_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../core/utils/order_formatter.dart';

class OrderPreviewScreen extends StatelessWidget {
  const OrderPreviewScreen({super.key, required this.items});

  final List<OrderLineItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final double totalPrice = items.fold(0.0, (sum, item) => sum + item.lineTotal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Order Stock'),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderSavedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order saved successfully!')),
            );
            Navigator.pop(context);
          } else if (state is OrderErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item.itemName),
                        subtitle: Text('Qty: ${item.quantity} ${item.unit}'),
                        trailing: Text('₹${item.lineTotal.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    final message = OrderFormatter.format(
                      shopName: 'My Kirana Shop',
                      items: items,
                      totalPrice: totalPrice,
                    );
                    Clipboard.setData(ClipboardData(text: message));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order details copied to clipboard!')),
                    );
                  },
                  label: const Text('Copy Order Text'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () async {
                    final message = OrderFormatter.format(
                      shopName: 'My Kirana Shop',
                      items: items,
                      totalPrice: totalPrice,
                    );

                    context.read<OrderBloc>().add(SaveOrderEvent(
                      order: OrderEntity(
                        items: items,
                        totalPrice: totalPrice,
                        createdAt: DateTime.now(),
                      ),
                    ));

                    // WhatsApp link trigger
                    final encoded = Uri.encodeComponent(message);
                    final uri = Uri.parse('https://wa.me/919999999999?text=$encoded');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch WhatsApp')),
                      );
                    }
                  },
                  label: const Text('Send on WhatsApp', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
