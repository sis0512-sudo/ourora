// OG(Open Graph) 메타 태그 데이터를 정의하는 파일.
// OG 태그는 카카오톡·SNS 공유 시 나타나는 제목·설명·이미지를 결정합니다.
// 각 페이지 경로(path)에 맞는 OgMeta 객체를 생성하여 반환합니다.

const ogBaseUrl = 'https://www.ourorastudio.com'; // 사이트 기본 URL
const _siteTitle = 'OURORA STUDIO';
const _titleSeparator = ' | '; // 페이지 제목과 사이트 이름 사이 구분자
const _defaultImage =
    'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Flogo.png?alt=media&token=741d2b5e-5306-410f-bec4-d63f70786e46';

// OG 메타 태그에 필요한 데이터를 담는 데이터 클래스
class OgMeta {
  final String title;       // 공유 시 보이는 제목
  final String description; // 공유 시 보이는 설명
  final String url;         // 공유 페이지의 정규 URL
  final String image;       // 공유 시 보이는 대표 이미지 URL
  final String type;        // OG 타입 (website / article)

  const OgMeta({
    required this.title,
    required this.description,
    required this.url,
    this.image = _defaultImage,
    this.type = 'website',
  });
}

// OgMeta 객체를 편리하게 생성하는 내부 헬퍼 함수.
// 제목에 ' | OURORA STUDIO'를 자동으로 붙여줍니다.
OgMeta _meta({
  required String title,
  required String description,
  String path = '',
  String type = 'website',
  String image = _defaultImage,
}) => OgMeta(
  title: '$title$_titleSeparator$_siteTitle',
  description: description,
  url: '$ogBaseUrl$path',
  type: type,
  image: image,
);

// 현재 URL 경로(path)에 맞는 OgMeta를 반환합니다.
// router.dart의 redirect에서 페이지 이동 시마다 호출됩니다.
OgMeta ogMetaForPath(String path) {
  final base = path.split('?').first; // 쿼리 파라미터 제거
  return switch (base) {
    '/about' => _meta(
      title: '공방 소개',
      description: '목동의 가구공방 오로라공방을 소개합니다. 손으로 가구를 만드는 즐거움, 오로라공방에서 시작하세요.',
      path: '/about',
    ),
    '/fidp' => _meta(
      title: 'F·I·D·P',
      description:
          'Form, Innovation, Design, Philosophy. 오로라공방이 추구하는 네 가지 핵심 가치입니다.',
      path: '/fidp',
    ),
    '/class/regular' => _meta(
      title: '정규 과정',
      description: '목공의 기초부터 심화까지, 체계적인 커리큘럼으로 진행되는 오로라공방 정규 목공 과정입니다.',
      path: '/class/regular',
    ),
    '/class/ourora8' => _meta(
      title: 'OURORA 8',
      description: '8주 완성 집중 프로그램 OURORA 8. 짧은 기간에 가구 제작의 핵심을 익힐 수 있습니다.',
      path: '/class/ourora8',
    ),
    '/class' => _meta(
      title: '목공 수업',
      description:
          '오로라공방의 목공 수업을 소개합니다. 정규 과정, OURORA 8 등 체계적인 목공 프로그램으로 가구 제작을 배워보세요.',
      path: '/class',
    ),
    '/membership' => _meta(
      title: '멤버십',
      description: '오로라공방 멤버십으로 공방을 자유롭게 이용하세요. 자유반, 연구반 등 다양한 멤버십 혜택을 안내합니다.',
      path: '/membership',
    ),
    '/contact' => _meta(
      title: '문의하기',
      description: '오로라공방에 목공 수업, 가구 제작, 공방 이용에 관해 문의하세요. 서울 목동 위치.',
      path: '/contact',
    ),
    // /works 또는 /works/... 로 시작하는 모든 경로
    _ when base == '/works' || base.startsWith('/works/') => _meta(
      title: '작품 갤러리',
      description: '오로라공방에서 만든 가구 작품들을 감상하세요. 원목 가구, 목공예 작품 갤러리입니다.',
      path: '/works',
    ),
    // 매칭되는 경로가 없으면 홈페이지 기본 메타 사용
    _ => _meta(
      title: '가구공방 오로라공방',
      description:
          '서울 목동에서 가구 제작 및 목공예를 하는 가구공방 오로라공방(OURORA STUDIO)입니다. 가구를 디자인하고 만듭니다. 그리고 목공의 즐거움을 배울 수 있는 다양한 목공수업도 진행하고 있습니다.',
    ),
  };
}

// 작품 상세 페이지(/post/:id)에 맞는 OgMeta를 생성합니다.
// 작품 제목·설명·대표 이미지를 받아 공유 시 해당 작품 정보가 보이도록 합니다.
OgMeta ogMetaForPost({
  required String id,
  required String title,
  required String description,
  String? image,
}) => OgMeta(
  title: title,
  description: description,
  url: '$ogBaseUrl/post/$id',
  image: image != null && image.isNotEmpty ? image : _defaultImage,
  type: 'article', // 게시물 타입
);
