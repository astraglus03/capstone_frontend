import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider 모니터링 가능함.
class Logger extends ProviderObserver{
  @override
  // 어떤 provider이던지 업데이트 되면 이 함수 무조건 사용됨
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    // TODO: implement didUpdateProvider
    print('[provider Updated] provider: $provider / pv: $previousValue / nv: $newValue');
  }

  @override
  // 추가되었을때
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    // TODO: implement didAddProvider
    print('[provider Add] provider: $provider / value: $value');
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    // TODO: implement didDisposeProvider
    print('[provider Disposed] provider: $provider');
  }

}