#import <FlutterMacOS/FlutterMacOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface UniLinksPluginMacOS : NSObject <FlutterPlugin>
+ (instancetype)sharedInstance;
- (BOOL)application:(NSApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:(void (^)(NSArray<id<NSUserActivityRestoring>> *restorableObjects))restorationHandler;
@end

NS_ASSUME_NONNULL_END
