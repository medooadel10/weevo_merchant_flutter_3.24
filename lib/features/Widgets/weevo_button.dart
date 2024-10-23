import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

class WeevoButton extends StatefulWidget {
  final Function? onTap;
  final String? title;
  final Color color;
  final bool isStable;
  final FontWeight? weight;
  final double? radius;
  final String? icon;
  final bool isExpand;
  final Widget? child;
  final bool autoDelay;
  const WeevoButton({
    super.key,
    required this.onTap,
    this.title,
    required this.color,
    required this.isStable,
    this.weight,
    this.radius,
    this.icon,
    this.isExpand = false,
    this.child,
    this.autoDelay = true,
  });

  @override
  State<WeevoButton> createState() => _WeevoButtonState();
}

class _WeevoButtonState extends State<WeevoButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isExpand ? double.infinity : null,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(
            0.0,
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(13.0),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            widget.isStable ? widget.color : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
              widget.isStable ? Colors.white : widget.color),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                width: 1.0,
                color: widget.color,
              ),
              borderRadius: BorderRadius.circular(
                widget.radius ?? 12.0,
              ),
            ),
          ),
        ),
        onPressed: widget.onTap != null
            ? () async {
                if (widget.autoDelay) {
                  setState(() {
                    isPressed = true;
                  });
                  context.unfocus();
                  widget.onTap!();
                  await Future.delayed(const Duration(milliseconds: 300));
                  setState(() {
                    isPressed = false;
                  });
                  return;
                }
                context.unfocus();
                widget.onTap!();
              }
            : null,
        label: widget.child ??
            Text(
              widget.title ?? '',
              style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: widget.weight,
              ),
            ),
        icon: widget.icon != null
            ? Image.asset(
                widget.icon!,
                height: 30.h,
                width: 30.w,
              )
            : Container(),
      ),
    );
  }
}
