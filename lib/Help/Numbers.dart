import 'package:url_launcher/url_launcher.dart';

String customerNumber = "8985073803";
String customerWhatsupNumber = "8985073803";
String emailID = "surecare@gmail.com";

customerCare() async {
  final Uri callNow = Uri.parse("tel:+91${customerNumber}");

  // Check if the URL can be launched
  if (await canLaunchUrl(callNow)) {
    // Launch the WhatsApp URL
    await launchUrl(callNow);
  } else {
    // If the URL cannot be launched, show an error or fallback
    print('Could not launch WhatsApp');
  }
}

whatsUpChat() async {
  final Uri whatsappNumber =
      Uri.parse("https://wa.me/+91${customerWhatsupNumber}");

  // Check if the URL can be launched
  if (await canLaunchUrl(whatsappNumber)) {
    // Launch the WhatsApp URL
    await launchUrl(whatsappNumber);
  } else {
    // If the URL cannot be launched, show an error or fallback
    print('Could not launch WhatsApp');
  }
}
