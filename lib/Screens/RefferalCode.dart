import 'package:cutomer_app/Utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReferralWalletPage extends StatelessWidget {
  final int walletBalance = 2000;
  final String referralCode = "DERMA123";

  const ReferralWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Wallet'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _walletCard(),
            const SizedBox(height: 20),
            _referralCodeCard(context),
            const SizedBox(height: 20),
            _sectionTitle("Referral Rewards History"),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) => _historyTile(
                  title: "Referral Reward",
                  subtitle: "Friend joined using your code",
                  amount: 500,
                  date: "10 July 2025",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _walletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [mainColor, secondaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: secondaryColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Wallet Balance",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            "💰 $walletBalance",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _referralCodeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: mainColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Your Referral Code",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          SelectableText(
            referralCode,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: mainColor,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await Share.share(
                  "Use my referral code $referralCode and earn rewards in the DermaCare app!",
                );
              } catch (e) {
                print("❌ Share failed: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sharing failed. Please try again.")),
                );
              }
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            label: const Text("Share Code"),
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _historyTile({
    required String title,
    required String subtitle,
    required int amount,
    required String date,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.card_giftcard, color: mainColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "+ 💰$amount",
              style: const TextStyle(
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(date, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
