import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class CustomDropdown extends StatefulWidget {
  String hintText;
  List<String> items;
  ValueChanged<String>? onChanged;
  String? leadingIconName;
  String? errorText;
  Color? borderColor;

  CustomDropdown({
    required this.hintText,
    required this.items,
    this.onChanged,
    this.leadingIconName,
    this.errorText,
    this.borderColor,
  });
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isExpanded = false;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor ?? AppTheme.primary),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      if (widget.leadingIconName != null) ...[
                        SvgPicture.asset(
                          'assets/icons/${widget.leadingIconName}.svg',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          selectedValue ?? widget.hintText,
                          style: TextTheme.of(context).titleMedium!.copyWith(
                            color: selectedValue == null
                                ? AppTheme.black.withValues(alpha: 0.6)
                                : AppTheme.black,
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: AppTheme.black,
                      ),
                    ],
                  ),
                ),
              ),

              if (isExpanded)
                Column(
                  children: widget.items.map((item) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedValue = item;
                          isExpanded = false;
                        });

                        widget.onChanged?.call(item);
                      },
                      child: SizedBox(
                        height: 32,
                        child: Row(
                          children: [
                            RadioGroup<String>(
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                  isExpanded = false;
                                });

                                if (value != null) {
                                  widget.onChanged?.call(value);
                                }
                              },
                              child: Radio<String>(
                                value: item,
                                activeColor: AppTheme.primary,
                              ),
                            ),
                            Text(
                              item,
                              style: TextTheme.of(context).titleMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),

        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: AppTheme.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
