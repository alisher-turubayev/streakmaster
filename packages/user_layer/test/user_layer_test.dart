import 'package:test/test.dart';
import 'package:user_layer/user_layer.dart';

class TestUserLayer extends UserLayer {
  TestUserLayer() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('UserLayer', () {
    test('can be constructed', () {
      expect(TestUserLayer.new, returnsNormally);
    });
  });
}