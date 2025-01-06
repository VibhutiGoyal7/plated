import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items; // Items to display in the dropdown
  final Function(String) onItemSelected; // Callback when an item is selected
  final String title; // Title of the container

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.onItemSelected,
    this.title = "Click Me",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDropdownMenu(context),
      onDoubleTap: () => Navigator.pushReplacementNamed(context,"/SelectServiceScreen"),
      child:  Container(
        padding: EdgeInsets.symmetric(vertical: 6,horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow.shade800,width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            SizedBox(width: 6,),
            Icon(Icons.keyboard_arrow_down_outlined)
          ],
        ) ,
      ),
    );
  }

  void _showDropdownMenu(BuildContext context) async {
    final RenderBox containerBox = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Calculate the position of the dropdown menu
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        containerBox.localToGlobal(Offset.zero, ancestor: overlay),
        containerBox.localToGlobal(containerBox.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    // Show the dropdown menu
    final result = await showMenu<String>(
      context: context,
      position: position,
      items: items
          .map(
            (item) => PopupMenuItem(
          value: item,
          child: Text(item),
        ),
      )
          .toList(),
    );

    // Handle selected value
    if (result != null) {
      onItemSelected(result);
    }
  }
}
