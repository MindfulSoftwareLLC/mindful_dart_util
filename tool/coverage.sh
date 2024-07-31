dart pub global activate coverage 1.2.0
dart run build_runner build
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/
# Open Coverage Report
open coverage/index.html
