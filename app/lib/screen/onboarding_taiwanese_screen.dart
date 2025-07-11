import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingTaiwaneseScreen extends StatefulWidget {
  const OnboardingTaiwaneseScreen({super.key});

  @override
  State<OnboardingTaiwaneseScreen> createState() =>
      _OnboardingTaiwaneseScreenState();
}

class _OnboardingTaiwaneseScreenState extends State<OnboardingTaiwaneseScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

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
                              '和在地人找到志趣相投的夥伴，\n像交朋友一樣展開一段旅程吧！',
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
                              '一起用一天的時間探索美食和咖啡館，\n就算只有短短幾小時，也能感受到在地人的日常。',
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
                              '旅程規劃可以直接用聊天輕鬆討論，\n所有準備用一個App就搞定！',
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
                                        "不是「找景點」，\n而是「透過人」開始旅程的服務。\n懂你、和你有共鳴的在地人會為你推薦一趟專屬旅程。",
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
                        '👇 對這個服務有興趣的話，馬上來看看吧！',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // LINE 안내
                      GestureDetector(
                        onTap: () async {
                          final Uri url =
                              Uri.parse('https://line.me/ti/p/Mp5RBh9JzM');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('無法開啟LINE連結'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          '📱 加我LINE，馬上體驗看看！',
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
                        '跟熟門熟路的在地人一起，\n感受一段不一樣的在地旅行 ✨',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  // 이메일 등록 안내
                  const Text(
                    '留下你的信箱，我們一上線就會第一時間通知你喔！',
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
                        '✉️【請輸入您的Email】',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('請輸入Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('留下你的信箱，我們一上線就會第一時間通知你喔！'),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'example@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveEmail,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('註冊'),
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
        const SnackBar(content: Text('請輸入Email')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入有效的Email')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('emails').add({
        'email': email,
        'language': 'taiwanese',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop(); // 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 註冊成功！\n🎁 專屬福利即將發送！'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('發生錯誤: $e'),
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
