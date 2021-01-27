#import "ScreenshotDetectorPlugin.h"
#if __has_include(<screenshot_detector/screenshot_detector-Swift.h>)
#import <screenshot_detector/screenshot_detector-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "screenshot_detector-Swift.h"
#endif

@implementation ScreenshotDetectorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScreenshotDetectorPlugin registerWithRegistrar:registrar];
}
@end
