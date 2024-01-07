import 'package:flutter/material.dart';

import '../components/bottom_sheet_app_bar.dart';
import '../constants/dimens.dart';
import '../constants/theme.dart';

class DialogUtils {
  static void showBottomSheet(
      BuildContext context, String title, Widget child) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
        ),
        builder: (_) {
          return Wrap(
            children: [
              BottomSheetAppBar(title),
              SafeArea(
                  child: Container(
                alignment: Alignment.center,
                child: Container(
                  constraints:
                      const BoxConstraints(minHeight: 100, maxHeight: 300),
                  child: child,
                ),
              )),
            ],
          );
        });
  }

  static void showNoHeaderBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        builder: (_) {
          return child;
        });
  }

  static void showSelection(
    BuildContext context,
    List<dynamic> items, {
    String title = 'Select',
    String selectedId = '0',
    ValueChanged<dynamic>? onItemSelected,
  }) {
    DialogUtils.showBottomSheet(
        context,
        title,
        BottomSelectionModal(
          items,
          selectedId: selectedId,
          onItemSelected: onItemSelected,
        ));
  }
}

class BottomSelectionModal extends StatefulWidget {
  final List<dynamic> items;
  final dynamic selectedId;
  final ValueChanged<dynamic>? onItemSelected;

  const BottomSelectionModal(
    this.items, {
    super.key,
    this.onItemSelected,
    this.selectedId = '',
  });

  @override
  _BottomSelectionModalState createState() => _BottomSelectionModalState();
}

class _BottomSelectionModalState extends State<BottomSelectionModal> {
  dynamic selectedId = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedId = widget.selectedId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.items.length,
      padding: const EdgeInsets.only(bottom: 10),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Row(
            children: [
              widget.items[index]['icon'],
              const SizedBox(
                width: 10,
              ),
              Text(widget.items[index]['name']),
            ],
          ),
          onTap: () {
            var id = widget.items[index]['id'];
            setState(() {
              selectedId = id;
            });
            widget.onItemSelected!(id);
          },
          trailing: widget.items[index]['id'] == selectedId
              ? const Icon(
                  Icons.radio_button_checked,
                  color: successColor,
                )
              : const Icon(Icons.radio_button_unchecked),
        );
      },
    );
  }
}
