import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:video_player/video_player.dart';

TextStyle _brandTitle() => GoogleFonts.montserrat(
  fontSize: 34,
  fontWeight: FontWeight.w900,
  color: AppTheme.white,
);

TextStyle _brandBodyText() => GoogleFonts.notoSansKr(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: AppTheme.white,
  height: 2.0,
);

class AboutBrandSection extends StatefulWidget {
  const AboutBrandSection({super.key});

  @override
  State<AboutBrandSection> createState() => _AboutBrandSectionState();
}

class _AboutBrandSectionState extends State<AboutBrandSection> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  double sectionHeight = 554;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fabout_background.mp4?alt=media&token=c12c6165-90c4-4d44-9427-e98a0243da8a',
            ),
          )
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
    final isMobile = Responsive.isMobileDevice;

    return isMobile
        ? Column(
            children: [
              SizedBox(
                height: 400,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_initialized)
                      ClipRect(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(width: _controller.value.size.width, height: _controller.value.size.height, child: VideoPlayer(_controller)),
                        ),
                      )
                    else
                      Image.asset('assets/images/about_background.webp', fit: BoxFit.cover, width: double.infinity, height: sectionHeight),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('OURORA', style: _brandTitle().copyWith(letterSpacing: 8)),
                          Text('=', style: _brandTitle()),
                          Text('OUR+AURORA', style: _brandTitle().copyWith(color: AppTheme.black, letterSpacing: 4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // height: 400,
                color: AppTheme.black,
                padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("오로라공방의 'OURORA'는", style: _brandBodyText(), textAlign: TextAlign.center),
                      Text("'우리의(OUR)'와 '오로라(AURORA)'를", style: _brandBodyText(), textAlign: TextAlign.center),
                      Text('합친 이름입니다.', style: _brandBodyText(), textAlign: TextAlign.center),
                      const SizedBox(height: 48),
                      Text(
                        '우리는 저마다 자신만의 빛을 가지고 있습니다.\n'
                        '오로라공방은 그 빛이 지구의 북극과 남극에서 나타나는 오로라처럼, 더욱 아름답고 신비롭게 빛나도록 다듬고 만드는 공간이 되고 싶습니다.\n'
                        '모두가 자신의 작품을 통해 세상 속 또 하나의 빛을 비추고, 그 과정에서 당신의 우아한 삶을 추구합니다.',
                        style: _brandBodyText().copyWith(fontSize: 15, color: AppTheme.white.withValues(alpha: 0.70)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : SizedBox(
            height: sectionHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_initialized)
                        ClipRect(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(width: _controller.value.size.width, height: _controller.value.size.height, child: VideoPlayer(_controller)),
                          ),
                        )
                      else
                        Image.asset('assets/images/about_background.webp', fit: BoxFit.cover, width: double.infinity, height: sectionHeight),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('OURORA', style: _brandTitle().copyWith(letterSpacing: 8)),
                            Text('=', style: _brandTitle()),
                            Text('OUR+AURORA', style: _brandTitle().copyWith(color: AppTheme.black, letterSpacing: 4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppTheme.black,
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("오로라공방의 'OURORA'는", style: _brandBodyText(), textAlign: TextAlign.center),
                          Text("'우리의(OUR)'와 '오로라(AURORA)'를", style: _brandBodyText(), textAlign: TextAlign.center),
                          Text('합친 이름입니다.', style: _brandBodyText(), textAlign: TextAlign.center),
                          const SizedBox(height: 48),
                          Text(
                            '우리는 저마다 자신만의 빛을 가지고 있습니다.\n'
                            '오로라공방은 그 빛이 지구의 북극과 남극에서 나타나는 오로라처럼, 더욱 아름답고 신비롭게 빛나도록 다듬고 만드는 공간이 되고 싶습니다.\n'
                            '모두가 자신의 작품을 통해 세상 속 또 하나의 빛을 비추고, 그 과정에서 당신의 우아한 삶을 추구합니다.',
                            style: _brandBodyText().copyWith(fontSize: 15, color: AppTheme.white.withValues(alpha: 0.70)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
