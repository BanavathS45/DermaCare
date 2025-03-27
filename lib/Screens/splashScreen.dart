import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

import '../SigninSignUp/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _noInternet = false;

  bool _animateLogo = false;
  double _logoOpacity = 1.0;
  double _backgroundOpacity = 1.0;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInternetAndInitialize();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _handleConnectivityChange(results.first);
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInternetAndInitialize() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _handleConnectivityChange(connectivityResult as ConnectivityResult);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      setState(() => _noInternet = true);
    } else {
      setState(() => _noInternet = false);

      // Wait 5 seconds, then trigger animations
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _animateLogo = true;
          _logoOpacity = 0.0;
          _backgroundOpacity = 0.0;
        });
      });
    }
  }

  void _onFadeComplete() {
    // Navigate only after fade completes
    if (!_noInternet) {
      Get.offAll(() => Loginscreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with fade
          AnimatedOpacity(
            opacity: _backgroundOpacity,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF679B75),
                    Color(0xFF84D8C1),
                    Color(0xFFCFAF96),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // No internet screen
          if (_noInternet)
            _buildNoInternetWidget()
          else
            // Logo animation
            AnimatedAlign(
              alignment:
                  _animateLogo ? const Alignment(0.0, -0.75) : Alignment.center,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _logoOpacity,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                onEnd: _onFadeComplete,
                child: Image.asset(
                  'assets/surecare_launcher.png',
                  height: 150,
                ),
              ),
            ),
          Text(
            "Dermatology center",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: Colors.white.withOpacity(0.95),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/wifi.gif', width: 100, height: 100),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Please check your connection and try again.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _checkInternetAndInitialize,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
          const SizedBox(height: 40),
          _buildNetworkSettingsCard(
            icon: Icons.wifi,
            title: 'Wi-Fi Settings',
            onTap: () {
              if (Platform.isAndroid) {
                (OpenSettingsPlus.shared as OpenSettingsPlusAndroid).wifi();
              } else if (Platform.isIOS) {
                (OpenSettingsPlus.shared as OpenSettingsPlusIOS).wifi();
              }
            },
          ),
          const SizedBox(height: 20),
          _buildNetworkSettingsCard(
            icon: Icons.network_cell,
            title: 'Mobile Data Settings',
            onTap: () {
              if (Platform.isAndroid) {
                (OpenSettingsPlus.shared as OpenSettingsPlusAndroid)
                    .dataRoaming();
              } else if (Platform.isIOS) {
                (OpenSettingsPlus.shared as OpenSettingsPlusIOS).wifi();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkSettingsCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.blue),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
