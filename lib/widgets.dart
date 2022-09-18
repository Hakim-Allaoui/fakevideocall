import 'package:flutter/material.dart';

class MButton extends StatelessWidget {
  final VoidCallback? onClicked;
  final String text;
  final Color? bgColor;
  final Color? textColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final MainAxisAlignment mainAxisAlignment;

  const MButton({
    Key? key,
    this.onClicked,
    this.text = "•••",
    this.bgColor,
    this.borderRadius = 6.0,
    this.textColor,
    this.width,
    this.height = 30.0,
    this.leading,
    this.trailing,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: bgColor ?? Colors.amber,
          padding: const EdgeInsets.symmetric(vertical: 4),
        ),
        onPressed: onClicked,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(2.0),
          alignment: Alignment.center,
          child: Padding(
            padding: padding!,
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading ?? const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text(
                    text,
                    style: textStyle ??
                        TextStyle(
                          color: textColor ?? Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
