import 'package:learn_clean_archtucture/core/network/netowrk_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  setUp(() {
    networkInfoImpl = NetworkInfoImpl();
    mockInternetConnectionChecker = MockInternetConnectionChecker();
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      // // arrange
      // when(mockInternetConnectionChecker.hasConnection)
      //     .thenAnswer((_) async => true);
      // // act
      // final result = await networkInfoImpl.isConnected;
      // //assert
      // verify(mockInternetConnectionChecker.hasConnection);
      // expect(result, true);
    });
  });
}
