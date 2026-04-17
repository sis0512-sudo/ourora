import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:video_player/video_player.dart';

class AboutBrandSection extends StatelessWidget {
  const AboutBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          _LeftPanel(height: 400),
          _RightPanel(padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32)),
        ],
      );
    }

    return SizedBox(
      height: 554,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _LeftPanel()),
          Expanded(child: _RightPanel()),
        ],
      ),
    );
  }
}

class _LeftPanel extends StatefulWidget {
  final double? height;
  const _LeftPanel({this.height});

  @override
  State<_LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<_LeftPanel> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/about_background.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_initialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Image.asset(
              'assets/images/about_background.webp',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'OURORA',
                  style: GoogleFonts.montserrat(fontSize: 60, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 8),
                ),
                const SizedBox(height: 8),
                Text(
                  '=',
                  style: GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'OUR+AURORA',
                  style: GoogleFonts.montserrat(fontSize: 40, fontWeight: FontWeight.w900, color: AppTheme.black, letterSpacing: 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RightPanel extends StatelessWidget {
  final EdgeInsets padding;
  const _RightPanel({this.padding = const EdgeInsets.symmetric(vertical: 80, horizontal: 80)});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "오로라공방의 'OURORA'는",
              style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white, height: 2.0),
              textAlign: TextAlign.center,
            ),
            Text(
              "'우리의(OUR)'와 '오로라(AURORA)'를",
              style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white, height: 2.0),
              textAlign: TextAlign.center,
            ),
            Text(
              '합친 이름입니다.',
              style: GoogleFonts.notoSansKr(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white, height: 2.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Text(
              '우리는 저마다 자신만의 빛을 가지고 있습니다.\n'
              '오로라공방은 그 빛이 지구의 북극과 남극에서 나타나는 오로라처럼, 더욱 아름답고 신비롭게 빛나도록 다듬고 만드는 공간이 되고 싶습니다.\n'
              '모두가 자신의 작품을 통해 세상 속 또 하나의 빛을 비추고, 그 과정에서 당신의 우아한 삶을 추구합니다.',
              style: GoogleFonts.notoSansKr(fontSize: 15, color: Colors.white70, height: 2.0),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
