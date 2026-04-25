#!/usr/bin/env bash
# 사용법:
#   ./deploy.sh           ← patch 버전 올림 (1.0.0 → 1.0.1)
#   ./deploy.sh minor     ← minor 버전 올림 (1.0.1 → 1.1.0)
#   ./deploy.sh major     ← major 버전 올림 (1.1.0 → 2.0.0)
set -euo pipefail

cd "$(dirname "$0")"

# ── 현재 버전 파싱 ────────────────────────────────────────────────────────────
CURRENT=$(grep '^version:' pubspec.yaml | awk '{print $2}')
VERSION_NAME="${CURRENT%%+*}"   # 1.0.0
BUILD_NUM="${CURRENT##*+}"      # 1

IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION_NAME"

# ── 버전 bump ─────────────────────────────────────────────────────────────────
BUMP="${1:-patch}"
case "$BUMP" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
  *)     echo "오류: patch | minor | major 중 하나를 입력하세요."; exit 1 ;;
esac

NEW_BUILD=$((BUILD_NUM + 1))
NEW_VERSION_NAME="$MAJOR.$MINOR.$PATCH"
NEW_VERSION="$NEW_VERSION_NAME+$NEW_BUILD"

echo ""
echo "▶  버전: $CURRENT → $NEW_VERSION"
echo ""

# ── pubspec.yaml 업데이트 ──────────────────────────────────────────────────────
sed -i '' "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml

# ── 배포 로그 기록 ────────────────────────────────────────────────────────────
DEPLOY_DATE=$(date '+%Y-%m-%d %H:%M')
LOG_ENTRY="| $DEPLOY_DATE | v$NEW_VERSION_NAME | build $NEW_BUILD |"

if [ ! -f DEPLOY_LOG.md ]; then
  cat > DEPLOY_LOG.md << 'EOF'
# 배포 이력

| 날짜 | 버전 | 빌드 |
|------|------|------|
EOF
fi

echo "$LOG_ENTRY" >> DEPLOY_LOG.md

# ── Flutter 빌드 ──────────────────────────────────────────────────────────────
echo "▶  flutter build web..."
flutter build web --release \
  --build-name="$NEW_VERSION_NAME" \
  --build-number="$NEW_BUILD"

# ── Firebase 배포 ─────────────────────────────────────────────────────────────
echo "▶  firebase deploy..."
firebase deploy --only hosting

# ── Git commit & tag ──────────────────────────────────────────────────────────
git add pubspec.yaml DEPLOY_LOG.md
git commit -m "chore: deploy v$NEW_VERSION_NAME"
git tag "v$NEW_VERSION_NAME"

echo ""
echo "✅ 배포 완료: v$NEW_VERSION_NAME (build $NEW_BUILD)"
echo ""
