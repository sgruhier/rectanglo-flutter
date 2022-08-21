import 'package:widget_helper/widget_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../config/themes.dart';
import '../utils/tools.dart';
import 'flat_card.dart';

class FlatDropDown extends StatefulWidget {
  final String? selected;
  final dynamic selectedValue;
  final String hint;
  final Color? iconColor;
  final double iconSize;
  final List<String> icons;
  final List<String> menu;
  final List<dynamic> value;
  final Function(DropDownItem? value) onSelected;
  final double? width;
  final double? height;
  final Color? color;
  final Border? border;
  final bool enable;
  final Widget? icon;

  const FlatDropDown({
    Key? key,
    this.iconColor,
    this.iconSize = 18,
    this.icons = const [],
    this.menu = const [],
    this.value = const <dynamic>[],
    required this.hint,
    required this.onSelected,
    this.width,
    this.height,
    this.color,
    this.border,
    this.selected,
    this.selectedValue,
    this.enable = true,
    this.icon,
  }) : super(key: key);

  @override
  _FlatDropDownState createState() => _FlatDropDownState();
}

class DropDownItem {
  String? icon;
  String title;
  dynamic value;
  bool selected;

  DropDownItem({
    required this.title,
    this.icon,
    this.value,
    this.selected = false,
  });
}

class _FlatDropDownState extends State<FlatDropDown> {
  DropDownItem? selected;
  List<DropDownItem> items = [];
  Widget? icon;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    icon = widget.icon;

    items.clear();
    for (int i = 0; i < widget.menu.length; i++) {
      items.add(
        DropDownItem(
          icon: widget.icons.length == widget.menu.length
              ? widget.icons[i]
              : null,
          title: widget.menu[i],
          value: widget.value[i],
        ),
      );
    }

    if (widget.selected != null || widget.selectedValue != null) {
      for (DropDownItem dropDownItem in items) {
        if (widget.selectedValue != null) {
          if (widget.selected == dropDownItem.title &&
              widget.selectedValue == dropDownItem.value) {
            setState(() {
              selected = dropDownItem;
            });
          }
        } else {
          if (widget.selected == dropDownItem.title) {
            setState(() {
              selected = dropDownItem;
            });
          }
        }
      }
    } else {
      selected = null;
    }

    icon ??= const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 24,
    );

    return IgnorePointer(
      ignoring: !widget.enable,
      child: FlatCard(
        border: widget.border ?? Border.all(color: Themes.stroke),
        color: widget.color,
        width: widget.width,
        height: widget.height,
        child: Opacity(
          opacity: widget.enable ? 1 : 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Center(
              child: DropdownButton(
                value: selected,
                icon: icon,
                underline: Container(),
                isExpanded: true,
                hint: Text(
                  widget.hint,
                  style: Themes().black14,
                ),
                items: items.map((DropDownItem dropDownItem) {
                  return DropdownMenuItem(
                    value: dropDownItem,
                    child: Row(
                      children: [
                        if (dropDownItem.icon != null)
                          SvgPicture.asset(
                            dropDownItem.icon!,
                            color: widget.iconColor,
                            width: widget.iconSize,
                            fit: BoxFit.contain,
                          ),
                        Text(
                          dropDownItem.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Themes().black14,
                        )
                            .addMarginLeft(dropDownItem.icon != null ? 12 : 0)
                            .addFlexible,
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (DropDownItem? value) {
                  Tools.closeKeyboard(context);
                  setState(() {
                    selected = value;
                  });
                  widget.onSelected(value);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
