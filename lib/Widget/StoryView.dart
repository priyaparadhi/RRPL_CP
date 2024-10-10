import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryView extends StatefulWidget {
  final List<String> stories;
  final VoidCallback onStoryViewed;
  final String swipeUpLink;

  StoryView({
    required this.stories,
    required this.onStoryViewed,
    required this.swipeUpLink,
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
        progress = 0.0; // Reset progress for the next story
      });
      startProgress(); // Restart progress for the next story
    } else {
      widget.onStoryViewed(); // Mark the story as viewed
      Navigator.pop(context); // Close story view when the last story is shown
    }
  }

  void _launchURL() async {
    if (!await launchUrl(
      Uri.parse(widget.swipeUpLink),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $widget.swipeUpLink');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: showNextStory, // On tap, show the next story
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe-up gesture detected (primaryVelocity < 0 means upward)
            _launchURL(); // Open the link
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
                  Navigator.pop(context); // Close the story when tapped
                },
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: FadeTransition(
                  opacity: _animation,
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
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
