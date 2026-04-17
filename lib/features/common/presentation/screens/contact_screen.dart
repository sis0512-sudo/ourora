import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

// 공방 좌표 — 서울 양천구 목동로21길 6 지하1층
const _mapSrc = 'https://maps.google.com/maps?q=37.52449,126.85618&z=14&output=embed';
const _viewType = 'ourora-google-maps';

bool _mapRegistered = false;

void _registerMapView() {
  if (_mapRegistered) return;
  _mapRegistered = true;
  ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
    final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
    iframe.src = _mapSrc;
    iframe.style.border = 'none';
    iframe.style.width = '100%';
    iframe.style.height = '100%';
    iframe.allowFullscreen = true;
    return iframe;
  });
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key, this.titleStyle, this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    _registerMapView();
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          SliverToBoxAdapter(
            child: _Body(titleStyle: titleStyle, bodyStyle: bodyStyle),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({this.titleStyle, this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 450, child: _MapView()),
        _InfoPanel(titleStyle: titleStyle, bodyStyle: bodyStyle),
        _ParkingPanel(titleStyle: titleStyle, bodyStyle: bodyStyle),
        Container(height: 180, color: AppTheme.white),
      ],
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: _viewType);
  }
}

TextStyle _defaultTitleStyle() => AppTheme.contactTitle();

TextStyle _defaultBodyStyle() => AppTheme.contactBody();

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({this.titleStyle, this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    final ts = titleStyle ?? _defaultTitleStyle();
    final bs = bodyStyle ?? _defaultBodyStyle();

    return Container(
      color: AppTheme.white,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주소 / 연락처', style: ts),
          const SizedBox(height: 8),
          Container(width: 36, height: 6, color: AppTheme.black),
          const SizedBox(height: 32),
          Text('주소 : 서울특별시 양천구 목동로21길 6', style: bs),
          Text('        지하1층 (우: 08022)', style: bs),
          Text('        (목동역(5호선) 8번출구에서 2분)', style: bs),
          const SizedBox(height: 8),
          Text('전화 : ${AppConstants.phone}', style: bs),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse('mailto:${AppConstants.email}')),
            child: Text.rich(
              TextSpan(
                text: '이메일 : ',
                style: bs,
                children: [TextSpan(text: AppConstants.email, style: bs)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkingPanel extends StatelessWidget {
  const _ParkingPanel({this.titleStyle, this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    final ts = titleStyle ?? _defaultTitleStyle();
    final bs = bodyStyle ?? _defaultBodyStyle();

    Widget bullet(String text) => Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: bs),
          Expanded(child: Text(text, style: bs)),
        ],
      ),
    );

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주차 안내', style: ts),
          const SizedBox(height: 8),
          Container(width: 36, height: 6, color: AppTheme.black),
          const SizedBox(height: 32),
          Text('공영주차장', style: bs),
          bullet('바로 앞 사거리 공유주차(약 50m) (평상시 약 1~2대 비어있음)'),
          bullet('신정4동길노상공영주차장(약 300m) : 서울 양천구 신정4동 1065'),
          bullet('신서 공영주차장(약 400m) : 서울 양천구 은행정로 42 신서고등학교'),
          const SizedBox(height: 20),
          Text('유료주차장', style: bs),
          bullet('보성팰리스(바로 뒷건물) : 서울 양천구 오목로 232'),
        ],
      ),
    );
  }
}
