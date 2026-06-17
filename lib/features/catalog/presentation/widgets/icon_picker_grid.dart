import 'package:flutter/material.dart';
import '../../../../core/constants/icon_constants.dart';

class IconPickerGrid extends StatelessWidget {
  const IconPickerGrid({super.key, required this.onIconSelected, required this.selectedIconId});

  final ValueChanged<String> onIconSelected;
  final String selectedIconId;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: IconConstants.all.length,
      itemBuilder: (context, index) {
        final iconId = IconConstants.all[index];
        final isSelected = iconId == selectedIconId;
        return InkWell(
          onTap: () => onIconSelected(iconId),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                iconId.replaceAll('ic_', '').substring(0, min(3, iconId.length - 3)).toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ),
        );
      },
    );
  }

  int min(int a, int b) => a < b ? a : b;
}
