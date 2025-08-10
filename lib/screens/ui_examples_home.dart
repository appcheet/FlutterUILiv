import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../core/constants/app_constants.dart';
import '../core/data/ui_examples_data.dart';
import '../core/theme/app_theme.dart';
import '../shared/widgets/ui_example_card.dart';

class UIExamplesHome extends StatelessWidget {
  const UIExamplesHome({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = UIExamplesData.examples;

    return Scaffold(
      body: SunsetAnimatedBackground(
        child: Column(
          children: [
            AppBar(
              title: Text(
                AppConstants.appTitle,
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: examples.length,
                itemBuilder: (context, index) {
                  final example = examples[index];
                  return UIExampleCard(
                    example: example,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => example.page,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}