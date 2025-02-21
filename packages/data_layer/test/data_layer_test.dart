import 'package:test/test.dart';
import 'package:data_layer/data_layer.dart';

class TestDataLayer extends DataLayer {
  TestDataLayer() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('TodosApi', () {
    test('can be constructed', () {
      expect(TestDataLayer.new, returnsNormally);
    });
  });
}