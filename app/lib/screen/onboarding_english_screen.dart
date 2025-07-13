import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class OnboardingEnglishScreen extends StatefulWidget {
  const OnboardingEnglishScreen({super.key});

  @override
  State<OnboardingEnglishScreen> createState() =>
      _OnboardingEnglishScreenState();
}

class _OnboardingEnglishScreenState extends State<OnboardingEnglishScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // 개발 환경 감지 함수
  bool _isDevelopment() {
    if (kIsWeb) {
      final uri = Uri.base;
      return uri.host == 'localhost' ||
          uri.host == '127.0.0.1' ||
          uri.host.contains('dev') ||
          uri.port != 443;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370, // 이미지의 카드 폭에 맞춤
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 로고
                  Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                  const SizedBox(height: 24),
                  // 안내 문구들
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. 현지인 매칭 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('🧑‍🤝‍🧑 ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              'Match with a local who shares your vibe —\nand start a trip that feels more like meeting a friend!',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // 2. 하루 가이드 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('🗺️ ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              'Explore cafes and food spots together on a one-day guide.\nEven a short trip can feel like living like a local.',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // 3. 일정 설계 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('💬 ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              'Plan your trip casually over chat —\nno stress, everything handled right in one app!',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // 4. Local-it 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🟩 대신 녹색 정사각형
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 8, top: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Local-it',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text:
                                        " isn't about 'searching for places.'\nIt's about 'starting your trip through people.'\nA local who gets you will suggest a trip just for you.",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      // 체크 안내
                      const Text(
                        '👇 Sounds interesting? Just message us!',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // WhatsApp 안내
                      GestureDetector(
                        onTap: () async {
                          final Uri url =
                              Uri.parse('https://wa.me/821022345457');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not open WhatsApp link'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          '📱 Chat with us on WhatsApp to get started.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 마지막 안내
                      const Text(
                        'Take a walk with someone who really knows the neighborhood —\nand enjoy a travel experience you won\'t find in guidebooks ✨',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  // 이메일 등록 안내
                  const Text(
                    'Drop your email and we\'ll let you know the moment we go live!',
                    style: TextStyle(
                        fontSize: 14, color: Colors.black87, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // 이메일 입력
                  GestureDetector(
                    onTap: _showEmailDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: const Text(
                        '✉️【Please enter your email address】',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEmailDialog() {
    _emailController.clear();

    // 개발 환경이 아닌 경우에만 이벤트 전송
    if (!_isDevelopment()) {
      FirebaseAnalytics.instance.logEvent(
        name: 'email_dialog_opened',
        parameters: {
          'language': 'english',
          'screen': 'onboarding_english',
        },
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Drop your email and we\'ll let you know the moment we go live!'),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                  hintText: 'example@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 개발 환경이 아닌 경우에만 이벤트 전송
                if (!_isDevelopment()) {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'email_registration_cancelled',
                    parameters: {
                      'language': 'english',
                      'screen': 'onboarding_english',
                    },
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveEmail,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('emails').add({
        'email': email,
        'language': 'english',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 개발 환경이 아닌 경우에만 이벤트 전송
      if (!_isDevelopment()) {
        FirebaseAnalytics.instance.logEvent(
          name: 'email_registration_success',
          parameters: {
            'language': 'english',
            'screen': 'onboarding_english',
            'email_domain': email.split('@').last, // 이메일 도메인 추적 (개인정보 보호)
          },
        );
      }

      if (mounted) {
        Navigator.of(context).pop(); // 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Registered!\n🎁 Special benefits are on the way!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // 개발 환경이 아닌 경우에만 이벤트 전송
      if (!_isDevelopment()) {
        FirebaseAnalytics.instance.logEvent(
          name: 'email_registration_failed',
          parameters: {
            'language': 'english',
            'screen': 'onboarding_english',
            'error_message': e.toString(),
          },
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
