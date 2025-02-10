import 'package:flutter/material.dart';

class DefaultSliverContainer2 extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const DefaultSliverContainer2({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 15),
      sliver: SliverToBoxAdapter(
        child: GestureDetector(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Container(
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: child,
              )
            ),
          ),
        ),
      ),
    );
  }
}