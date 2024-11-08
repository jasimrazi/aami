import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const CustomBottomNavButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(15.0),
        height: 75.h,
        color: Theme.of(context).colorScheme.primary,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 17.sp, color: Color(0xffFEFEFE)),
        ),
      ),
    );
  }
}
