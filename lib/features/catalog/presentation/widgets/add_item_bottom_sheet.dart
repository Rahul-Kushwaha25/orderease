import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item_entity.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';

class AddItemBottomSheet extends StatefulWidget {
  const AddItemBottomSheet({super.key, this.item});

  final ItemEntity? item;

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late String _unit;
  late String _category;
  late String _iconId;

  @override
  void initState() {
    super.initState();
    _name = widget.item?.name ?? '';
    _price = widget.item?.price ?? 0.0;
    _unit = widget.item?.unit ?? 'kg';
    _category = widget.item?.category ?? 'Dairy';
    _iconId = widget.item?.iconId ?? 'ic_dairy';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.item == null ? 'Add Stock Item' : 'Edit Item',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null,
                onSaved: (val) => _name = val ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _price > 0 ? _price.toString() : '',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (₹)'),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Please enter price' : null,
                onSaved: (val) => _price = double.parse(val ?? '0.0'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _unit,
                items: const [
                  DropdownMenuItem(value: 'kg', child: Text('kg')),
                  DropdownMenuItem(value: 'gram', child: Text('gram')),
                  DropdownMenuItem(value: 'litre', child: Text('litre')),
                  DropdownMenuItem(value: 'ml', child: Text('ml')),
                  DropdownMenuItem(value: 'unit', child: Text('unit')),
                  DropdownMenuItem(value: 'packet', child: Text('packet')),
                  DropdownMenuItem(value: 'dozen', child: Text('dozen')),
                ],
                onChanged: (val) => setState(() => _unit = val ?? 'kg'),
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: 'Dairy', child: Text('Dairy')),
                  DropdownMenuItem(value: 'Grain', child: Text('Grain')),
                  DropdownMenuItem(value: 'Snacks', child: Text('Snacks')),
                  DropdownMenuItem(value: 'Beverages', child: Text('Beverages')),
                  DropdownMenuItem(value: 'Spices', child: Text('Spices')),
                ],
                onChanged: (val) => setState(() => _category = val ?? 'Dairy'),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final entity = ItemEntity(
        id: widget.item?.id,
        name: _name,
        price: _price,
        unit: _unit,
        iconId: _iconId,
        category: _category,
        createdAt: widget.item?.createdAt ?? DateTime.now(),
      );

      if (widget.item == null) {
        context.read<CatalogBloc>().add(AddCatalogItem(item: entity));
      } else {
        context.read<CatalogBloc>().add(UpdateCatalogItem(item: entity));
      }
      Navigator.pop(context);
    }
  }
}
