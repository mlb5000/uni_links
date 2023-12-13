#import "UniLinksPluginMacOS.h"

static NSString *const kMessagesChannel = @"uni_links/messages";
static NSString *const kEventsChannel = @"uni_links/events";

@interface UniLinksPluginMacOS () <FlutterStreamHandler>
@property(nonatomic, copy) NSString *initialLink;
@property(nonatomic, copy) NSString *latestLink;
@end

@implementation UniLinksPluginMacOS {
  FlutterEventSink _eventSink;
}

static id _instance;

+ (UniLinksPluginMacOS *)sharedInstance {
  if (_instance == nil) {
    _instance = [[UniLinksPluginMacOS alloc] init];
  }
  return _instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  UniLinksPluginMacOS *instance = [UniLinksPluginMacOS sharedInstance];

  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:kMessagesChannel
                                  binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterEventChannel *chargingChannel =
      [FlutterEventChannel eventChannelWithName:kEventsChannel
                                binaryMessenger:[registrar messenger]];
  [chargingChannel setStreamHandler:instance];
}

- (void)setLatestLink:(NSString *)latestLink {
  static NSString *key = @"latestLink";

  [self willChangeValueForKey:key];
  _latestLink = [latestLink copy];
  [self didChangeValueForKey:key];

  if (_eventSink) _eventSink(_latestLink);
}

//- (BOOL)application:(NSApplication *)application
//    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//  NSURL *url = (NSURL *)launchOptions[UIApplicationLaunchOptionsURLKey];
//  self.initialLink = [url absoluteString];
//  self.latestLink = self.initialLink;
//  return YES;
//}

- (void)openURL:(NSURL *)url
  configuration:(NSWorkspaceOpenConfiguration *)configuration
completionHandler:(void (^)(NSRunningApplication *app, NSError *error))completionHandler  API_AVAILABLE(macos(10.15)){
    self.latestLink = [url absoluteString];
    NSLog(@"openURL:configuration:completionHandler: %@", self.latestLink);
}

- (BOOL)application:(NSApplication *)application
            openURL:(NSURL *)url {
  self.latestLink = [url absoluteString];
    NSLog(@"application:openURL %@", self.latestLink);
  return YES;
}

- (BOOL)application:(NSApplication *)application 
continueUserActivity:(NSUserActivity *)userActivity 
 restorationHandler:(void (^)(NSArray<id<NSUserActivityRestoring>> *restorableObjects))restorationHandler {
  if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
    self.latestLink = [userActivity.webpageURL absoluteString];
    NSLog(@"continueUserActivity %@", self.latestLink);
    if (!_eventSink) {
      self.initialLink = self.latestLink;
    }
    return YES;
  }
  return NO;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"getInitialLink" isEqualToString:call.method]) {
    NSLog(@"getInitialLink %@", self.latestLink);
    result(self.initialLink);
    // } else if ([@"getLatestLink" isEqualToString:call.method]) {
    //     result(self.latestLink);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)eventSink {
  _eventSink = eventSink;
  return nil;
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSink = nil;
  return nil;
}

@end
