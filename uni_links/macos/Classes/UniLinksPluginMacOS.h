#import <FlutterMacOS/FlutterMacOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface UniLinksPluginMacOS : NSObject <FlutterPlugin>
+ (instancetype)sharedInstance;
- (BOOL)application:(NSApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler;
@end

NS_ASSUME_NONNULL_END
