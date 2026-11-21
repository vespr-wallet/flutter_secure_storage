#!/usr/bin/env bash
# Runs the example app's integration test on the Android emulator (emulator-5554), from flutter_secure_storage/example.
#
# On API 34 the Flutter tool sometimes hangs right after installing the APK: the tool attaches to the test isolate,
# the app's activity then starts a second time with a new Flutter engine, and the tool keeps waiting for a result
# from the first isolate. A fresh run on the same emulator has passed every time so far. Passing runs take about
# 2 minutes, so each attempt is capped at 5 minutes. When an attempt hits that cap (and only then), the app is
# uninstalled, because the hung attempt may leave it installed with the rows it wrote, and the test runs once more on
# the same emulator. Any other failure fails the step straight away. On failure the relevant logcat lines are printed.
set -u

package=com.it_nomads.fluttersecurestorageexample
cap_seconds=300

print_logcat() {
  adb logcat -d -v time | grep -iE 'flutter|securestorage|sharedpref|keystore|tink|crypto|AndroidRuntime|FATAL|PackageManager|installd|dex2oat' | tail -n 400
}

run_test() {
  adb logcat -c || true
  timeout -k 30 "$cap_seconds" flutter test integration_test -d emulator-5554
}

run_test
status=$?
if [ "$status" -eq 124 ]; then
  echo "::warning::The Android integration test hung for ${cap_seconds}s; uninstalling the app and running it once more."
  print_logcat
  adb uninstall "$package" || true
  run_test
  status=$?
fi
if [ "$status" -ne 0 ]; then
  print_logcat
  exit 1
fi
