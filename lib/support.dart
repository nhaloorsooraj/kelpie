// ignore_for_file: file_names
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Dear User,",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const Text(""),
              const Text(
                  "We want to take a moment to express our gratitude for your continued support of our app.Your feedback and suggestions have been invaluable in helping us improve and grow.\n\nWe understand that there may be times when you encounter issues or have questions, and we want you to know that we're here to help.\n",
                  style: TextStyle(fontSize: 20)),
              const Text(
                  "Our support team is dedicated to resolving any problems you may have and ensuring that you have the best possible experience with our app.\n",
                  style: TextStyle(fontSize: 20)),
              const Text(
                  "If you have any questions or concerns, please don't hesitate to reach out to us through the support page. We'll do our best to get back to you as quickly as possible. ",
                  style: TextStyle(fontSize: 20)),
              const Text(""),
              const Text(
                  "Thank you again for choosing our app and for being a part of our community.\n",
                  style: TextStyle(fontSize: 20)),
              const Text(""),
              const Text("Best regards,",
                  style: TextStyle(
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
              const Text("Team FarmBit",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
              const Text(""),
              const Text(""),
              const Text(""),
              const Text("Get in touch",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30)),
              const Text(""),
              const Text(""),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse("https://www.geeksforgeeks.org/");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Image.asset(
                        "assets/wordpress_ico.png",
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Image.asset(
                      "assets/github_ico.png",
                      height: 50,
                      width: 50,
                    ),
                    Image.asset(
                      "assets/linkedin_ico.png",
                      height: 45,
                      width: 45,
                    ),
                  ],
                ),
              ),
              const Text(""),
              const Text(""),
            ],
          ),
        ),
      ),
    ));
  }
}
