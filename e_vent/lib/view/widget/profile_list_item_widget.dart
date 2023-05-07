import 'package:flutter/material.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
      ).copyWith(
        bottom: 20,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(5 * 3),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            //size: 12,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (hasNavigation)
            const Icon(
              Icons.arrow_forward_ios_rounded,
              //size: kSpacingUnit.w * 2.5,
            ),
        ],
      ),
    );
  }
}
