import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderease/core/localization/l10n/app_localizations.dart';
import '../../../../core/constants/icon_constants.dart';
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

  final List<String> _units = ['kg', 'litre', 'unit', 'packet', 'gram', 'ml', 'dozen'];

  final List<String> _selectableIcons = [
    'ic_fruits',
    'ic_oil',
    'ic_grain',
    'ic_beverages',
    'ic_bakery',
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.item?.name ?? '';
    _price = widget.item?.price ?? 0.0;
    _unit = widget.item?.unit ?? 'kg';
    _category = widget.item?.category ?? 'Dairy';
    _iconId = widget.item?.iconId ?? 'ic_fruits';
  }

  String _getCategoryFromIcon(String iconId) {
    if (iconId == 'ic_fruits' || iconId == 'ic_vegetables' || iconId == 'ic_spices') {
      return 'Spices';
    } else if (iconId == 'ic_dairy' || iconId == 'ic_oil') {
      return 'Dairy';
    } else if (iconId == 'ic_grain') {
      return 'Grain';
    } else if (iconId == 'ic_beverages' || iconId == 'ic_snacks') {
      return 'Beverages';
    } else if (iconId == 'ic_bakery') {
      return 'Grain';
    }
    return 'Dairy';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[350],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                widget.item == null ? l10n.addItemButton : l10n.editItemButton,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.itemNameLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _name,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'e.g. Sugar',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                  fillColor: isDark ? Colors.grey[850]! : const Color(0xFFF1F3F0),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null,
                onSaved: (val) => _name = val ?? '',
              ),
              const SizedBox(height: 16),
              Text(
                l10n.localeName == 'hi' ? 'मूल्य' : 'Price',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _price > 0 ? _price.toString() : '',
                keyboardType: TextInputType.number,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8, top: 12),
                    child: Text(
                      '₹ ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
                    ),
                  ),
                  fillColor: isDark ? Colors.grey[850]! : const Color(0xFFF1F3F0),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Please enter price' : null,
                onSaved: (val) => _price = double.parse(val ?? '0.0'),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.localeName == 'hi' ? 'मापने की इकाई' : 'Unit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _units.length,
                  itemBuilder: (context, index) {
                    final unitOpt = _units[index];
                    final isSelected = _unit == unitOpt;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _unit = unitOpt;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.grey[900]! : const Color(0xFFEFF1EE)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            unitOpt,
                            style: TextStyle(
                              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.localeName == 'hi' ? 'आइकन चुनें' : 'Select Icon',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectableIcons.length,
                  itemBuilder: (context, index) {
                    final iconOpt = _selectableIcons[index];
                    final iconConfig = IconConstants.getIconConfig(iconOpt);
                    final isSelected = _iconId == iconOpt;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _iconId = iconOpt;
                          _category = _getCategoryFromIcon(iconOpt);
                        });
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.grey[900]! : const Color(0xFFEFF1EE)),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Icon(
                          iconConfig.icon,
                          color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _saveForm,
                  child: Text(
                    l10n.localeName == 'hi' ? 'सहेजें' : 'Save Item',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
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
