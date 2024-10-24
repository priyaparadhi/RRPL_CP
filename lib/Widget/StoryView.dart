import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryView extends StatefulWidget {
  final List<String> stories;
  final VoidCallback onStoryViewed;
  final String? swipeUpLink;

  StoryView({
    required this.stories,
    required this.onStoryViewed,
    this.swipeUpLink,
  });

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  double progress = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    startProgress();

    // Initialize AnimationController
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller
    super.dispose();
  }

  void startProgress() {
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          progress += 0.01;
          if (progress >= 1.0) {
            showNextStory();
          } else {
            startProgress();
          }
        });
      }
    });
  }

  void showNextStory() {
    if (currentIndex < widget.stories.length - 1) {
      setState(() {
        currentIndex++;
        progress = 0.0;
      });
      startProgress();
    } else {
      widget.onStoryViewed();
      Navigator.pop(context);
    }
  }

  void _launchURL() async {
    if (widget.swipeUpLink != null && widget.swipeUpLink!.isNotEmpty) {
      if (!await launchUrl(
        Uri.parse(widget.swipeUpLink!),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch ${widget.swipeUpLink}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: showNextStory,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _launchURL(); // Open the link only if available
          }
        },
        child: Stack(
          children: [
            Center(
              child: Image.network(
                widget.stories[currentIndex],
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
            if (widget.swipeUpLink != null && widget.swipeUpLink!.isNotEmpty)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Lottie.asset(
                    'assets/images/swipeUp.json',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
            if (widget.swipeUpLink != null && widget.swipeUpLink!.isNotEmpty)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Swipe up to open link',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
