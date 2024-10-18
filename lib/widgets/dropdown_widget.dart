import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownWidget extends StatelessWidget {
  const DropdownWidget({
    super.key,
    required this.hintText,
    required this.selectedItem,
    required this.itemList,
    required this.onChanged
  });

  final String hintText;
  final String? selectedItem;
  final List<String> itemList;
  final Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey,
            width: 1
          )
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          focusColor: Colors.grey,
          hint: Text(
            hintText,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey
            ),
          ),
          selectedItemBuilder: (context) {
            return itemList.map<Widget>((e) {
              return Center(
                child: Text(
                  e,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                  ),
                ),
              );
            }).toList();
          },
          value: selectedItem,
          borderRadius: BorderRadius.circular(10),
          items: itemList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}