#!/bin/bash
PATH=/Applications/dart/dart-sdk/bin/:$PATH
dart2js --disallow-unsafe-eval -ovideo_test.dart.js video_test.dart

