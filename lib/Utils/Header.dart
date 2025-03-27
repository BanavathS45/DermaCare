import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Nullable
  final String? subtitle; // New subtitle field
  final String? username; // Nullable
  final RxString? subLocality; // Nullable and observed
  final VoidCallback? onNotificationPressed; // Nullable callback
  final VoidCallback? onSettingPressed; // Nullable callback
  final VoidCallback? onHelpPressed; // Nullable callback

  const CommonHeader(
      {Key? key,
      this.title,
      this.subtitle,
      this.username,
      this.subLocality,
      this.onNotificationPressed,
      this.onSettingPressed,
      this.onHelpPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF456F62),
              Color(0xFF82D1B8),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                if (subLocality != null)
                  Obx(() {
                    return Text(
                      subLocality!.value,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    );
                  }),
              ],
            ),
          ),
          // Notification Icon
          if (onNotificationPressed != null)
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: onNotificationPressed,
            ),
          // WhatsApp Icon
          if (onSettingPressed != null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: onSettingPressed,
            ),
          if (onHelpPressed != null)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: onHelpPressed,
            ),

          // onHelpPressed
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
