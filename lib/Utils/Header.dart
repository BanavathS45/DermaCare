import 'package:cutomer_app/Notification/NotificationController.dart';
import 'package:cutomer_app/Utils/Constant.dart';
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
  final bool automaticallyImplyLeading; // 👈 Add this

  const CommonHeader(
      {Key? key,
      this.title,
      this.subtitle,
      this.username,
      this.subLocality,
      this.onNotificationPressed,
      this.onSettingPressed,
      this.automaticallyImplyLeading = true,
      this.onHelpPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [mainColor, secondaryColor],
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
            Obx(() {
              final count =
                  Get.find<NotificationController>().unreadCount.value;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: onNotificationPressed,
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),

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
