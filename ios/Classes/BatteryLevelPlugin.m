#import "BatteryLevelPlugin.h"
#if __has_include(<battery_level/battery_level-Swift.h>)
#import <battery_level/battery_level-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "battery_level-Swift.h"
#endif

@implementation BatteryLevelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBatteryLevelPlugin registerWithRegistrar:registrar];
}
@end
