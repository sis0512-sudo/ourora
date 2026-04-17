import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

// 공방 좌표 — 서울 양천구 목동로21길 6 지하1층
const _mapSrc =
    'https://maps.google.com/maps?q=37.52449,126.85618&z=16&output=embed';
const _viewType = 'ourora-google-maps';

bool _mapRegistered = false;

void _registerMapView() {
  if (_mapRegistered) return;
  _mapRegistered = true;
  ui_web.platformViewRegistry.registerViewFactory(
    _viewType,
    (int viewId) {
      final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
      iframe.src = _mapSrc;
      iframe.style.border = 'none';
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.allowFullscreen = true;
      return iframe;
    },
  );
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _registerMapView();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: NavBarDelegate(),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Responsive.isMobile(context)
                ? const _MobileBody()
                : const _DesktopBody(),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  const _DesktopBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 640,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 3, child: _MapView()),
          Expanded(flex: 2, child: _InfoPanel()),
        ],
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  const _MobileBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 360, child: _MapView()),
        _InfoPanel(),
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

class _InfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightGray,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTACT',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
              color: AppTheme.textGray,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'OURORA\nSTUDIO',
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              height: 1.1,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 40, height: 2, color: AppTheme.black),
          const SizedBox(height: 36),
          _ContactRow(
            icon: Icons.location_on_outlined,
            label: 'ADDRESS',
            value: AppConstants.address,
          ),
          const SizedBox(height: 24),
          _ContactRow(
            icon: Icons.phone_outlined,
            label: 'PHONE',
            value: AppConstants.phone,
            onTap: () => launchUrl(Uri.parse('tel:${AppConstants.phone}')),
          ),
          const SizedBox(height: 24),
          _ContactRow(
            icon: Icons.mail_outline,
            label: 'EMAIL',
            value: AppConstants.email,
            onTap: () => launchUrl(Uri.parse('mailto:${AppConstants.email}')),
          ),
          const SizedBox(height: 24),
          _ContactRow(
            icon: Icons.access_time_outlined,
            label: 'HOURS',
            value: 'Mon – Sat  10:00 – 20:00\nSun  Closed',
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.black),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppTheme.textGray,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  value,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    height: 1.7,
                    color: onTap != null ? AppTheme.black : AppTheme.textGray,
                    decoration:
                        onTap != null ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
