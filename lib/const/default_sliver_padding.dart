import 'package:flutter/material.dart';

class DefaultSliverContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final void Function()? onTap;

  const DefaultSliverContainer({super.key, required this.child, this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 15),
      sliver: SliverToBoxAdapter(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 2,
              //     blurRadius: 5,
              //     offset: Offset(0, 3), // changes position of shadow
              //   ),
              // ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}