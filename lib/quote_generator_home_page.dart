import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qoute_generator/apikey.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

// ignore: camel_case_types
class quote_generator_home_Page extends StatefulWidget {
  const quote_generator_home_Page({super.key});

  @override
  State<quote_generator_home_Page> createState() =>
      _quote_generator_home_PageState();
}

// ignore: camel_case_types
class _quote_generator_home_PageState extends State<quote_generator_home_Page>
    with SingleTickerProviderStateMixin {
  String quote = '';
  String author = '';
  bool isLoading = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchQuote();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  Future<void> fetchQuote() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/quotes'),
        headers: {'X-Api-Key': apiKey},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          quote = data[0]['quote'];
          author = data[0]['author'];
          isLoading = false;
        });
        _controller.forward(from: 0);
      } else {
        setState(() {
          quote = "Failed to load quote.";
          author = "";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        quote = "Something went wrong.";
        author = "";
        isLoading = false;
      });
    }
  }

  void _shareQuote() {
    if (quote.isNotEmpty) {
      Share.share('"$quote"\n\n— $author');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "🌟 Quote Generator",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black45,
                offset: Offset(1, 2),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: fetchQuote,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 150, 101, 248), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.white.withOpacity(0.1),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Text(
                                  '"$quote"',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "- $author",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: fetchQuote,
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.cyanAccent,
                              ),
                              label: const Text(
                                "New Quote",
                                style: TextStyle(color: Colors.cyanAccent),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  145,
                                  110,
                                  241,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _shareQuote,
                              icon: const Icon(Icons.share),
                              label: const Text("Share"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
