// 앱의 시작점(entry point). Flutter는 항상 main() 함수에서 실행이 시작됩니다.
// bootstrap()에 App 위젯 생성 함수를 전달하여, 초기화 후 앱을 실행합니다.
import 'package:ourora/app.dart';
import 'package:ourora/bootstrap.dart';

void main() {
  bootstrap(() => const App());
}
