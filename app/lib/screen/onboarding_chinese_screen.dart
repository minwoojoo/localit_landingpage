import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingChineseScreen extends StatefulWidget {
  const OnboardingChineseScreen({super.key});

  @override
  State<OnboardingChineseScreen> createState() =>
      _OnboardingChineseScreenState();
}

class _OnboardingChineseScreenState extends State<OnboardingChineseScreen> {
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
                              '和兴趣相投的当地人配对，\n像朋友一样开启属于你的本地旅行！',
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
                              '一起去吃美食、喝咖啡，\n哪怕是短短的一天，也能像当地人一样体验生活！',
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
                              '旅行计划可以直接聊天商量，\n所有行程安排都能轻松搞定！',
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
                                        "不是'搜索景点'的工具，\n而是一个'通过人来认识城市'的旅行服务。\n与你兴趣契合的当地人，主动向你推荐特别的旅程！",
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
                        '👇 想了解更多？马上加我微信！',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // WeChat 안내
                      const Text(
                        '📱 复制下方微信ID并粘贴到微信搜索栏添加好友',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '🔍 微信ID：Local-it',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // 마지막 안내
                      const Text(
                        '✨ 想第一时间收到上线通知？\n📩 填写你的邮箱，我们会第一时间告诉你！',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  // 이메일 등록 안내
                  const Text(
                    '留下邮箱，我们一上线就马上告诉你！',
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
                        '✉️【请输入邮箱地址】',
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
          title: const Text('请输入邮箱地址'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('留下邮箱，我们一上线就马上告诉你！'),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '邮箱地址',
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
                  : const Text('注册'),
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
        const SnackBar(content: Text('请输入邮箱地址')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的邮箱地址')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('emails').add({
        'email': email,
        'language': 'chinese',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop(); // 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 注册成功！\n🎁 专属福利即将发送！'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发生错误: $e'),
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
