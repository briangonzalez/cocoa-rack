//
//  AppDelegate.m
//  cocoa-rack
//
//  Created by Brian M. Gonzalez.
//  Copyright (c). All rights reserved.
//

#import "AppDelegate.h"

NSString *const PORT = @"9999";
NSString *const HOST = @"127.0.0.1";
NSString *const URL  = @"http://127.0.0.1:9999";

@implementation AppDelegate

@synthesize fxServerTask          = fxServerTask;
@synthesize splash                = _splash;
@synthesize window                = _window;
@synthesize webview               = _webview;
@synthesize progress              = _progress;
@synthesize serverVersion         = serverVersion;
@synthesize systemRubyPath        = systemRubyPath;
@synthesize versionString         = versionString;
@synthesize portString            = portString;
@synthesize resourcePath          = resourcePath;
@synthesize versionsInSync        = versionsInSync;
@synthesize currentVersion        = currentVersion;
@synthesize pingTimer             = pingTimer;
@synthesize longRunningTimer      = longRunningTimer;
@synthesize alertTimer            = alertTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  [_progress startAnimation:self];
  [_webview setDrawsBackground:NO];
  
  NSLog(@" ** Starting cocoa-rack server.");
  resourcePath     = [[NSBundle mainBundle] resourcePath];
  currentVersion              = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle]
                                objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
  
  NSLog(@" ** Current app version is %@", currentVersion);
  
  // -----------------------------------------------------------------------------------------------------------
  //
  //  START COCOA-RACK SERVER.
  //
  // -----------------------------------------------------------------------------------------------------------
  systemRubyPath    = @"/usr/bin/ruby";
  versionString     = [[[NSArray alloc] initWithObjects: @"VERSION=", currentVersion, nil] componentsJoinedByString:@""];
  portString        = [[[NSArray alloc] initWithObjects: @"PORT=", PORT, nil] componentsJoinedByString:@""];
  
  [self startCocoaRackServer];
  
  longRunningTimer  = [NSTimer scheduledTimerWithTimeInterval:  15.0
                                                       target:  self
                                                     selector:  @selector(checkForLongStartup:)
                                                     userInfo:  nil
                                                      repeats:  NO];
  
  alertTimer        = [NSTimer scheduledTimerWithTimeInterval:  60.0
                                                       target:  self
                                                     selector:  @selector(alertUserAboutLongRunner:)
                                                     userInfo:  nil
                                                      repeats:  NO];
  
  pingTimer         = [NSTimer scheduledTimerWithTimeInterval:  3.0
                                                       target:  self
                                                     selector:  @selector(checkForRunningServer:)
                                                     userInfo:  nil
                                                      repeats:  YES];
  
}


- (void)applicationWillTerminate:(NSNotification *)aNotification{
}


// -----------------------------------------------------------------------------------------------------------
//
//  CHECK FOR THE RUNNING SERVER
//
// -----------------------------------------------------------------------------------------------------------
- (void) checkForRunningServer:(NSTimer *)timer {
  NSLog(@" ** Waiting for server to initialize.");
  
  NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString: [[NSArray arrayWithObjects: URL, @"/version", nil] componentsJoinedByString: @""] ]
                                       cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                   timeoutInterval:3.0];
  NSData *res       = [NSURLConnection  sendSynchronousRequest:req returningResponse:NULL error:NULL];
  serverVersion     =[[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];
  
  versionsInSync = ([serverVersion isEqualToString: currentVersion]);
  
  NSLog( versionsInSync ? @" ** Server & App versions in sync." : @" ** Server & App versions **NOT** in sync.");
  NSLog(@" ** App version: %@", currentVersion);
  NSLog(@" ** Server version: %@", serverVersion);
  
  // Fire up the view.
  if ( versionsInSync ){
    [longRunningTimer invalidate];
    [alertTimer       invalidate];
    
    NSString *randomizedURL =  [NSString stringWithFormat: URL];
    [NSApp activateIgnoringOtherApps:YES];
    [_window makeKeyAndOrderFront:self];
    
    [_webview setMainFrameURL: randomizedURL];
    
    [_splash close];
    [timer invalidate];
  }
  
}

// -----------------------------------------------------------------------------------------------------------
//
//  CHECK FOR THE LONG STARTUP
//
// -----------------------------------------------------------------------------------------------------------
- (void) checkForLongStartup:(NSTimer *)timer {
  NSLog(@" ** Server taking a long time to start. Killing others.");
  NSTask *runTask = [[NSTask alloc] init];
  [runTask setLaunchPath:@"/bin/sh"];
  [runTask setCurrentDirectoryPath: [NSString stringWithFormat: @"%@/scripts", resourcePath]];
  [runTask setArguments:[NSArray arrayWithObjects: @"kill.sh", nil] ];
  [runTask launch];
  
  [self startCocoaRackServer];
}

- (void) alertUserAboutLongRunner:(NSTimer *)timer {
  [_splash close];
  [pingTimer invalidate];
  
  NSString *alertText       = @"Oops! App Failed to Start";
  NSString *informativeText = [[NSArray arrayWithObjects:  @"Is another process running on port ",
                                PORT,
                                @"? If so, please close it before running this app. \n\n",
                                nil] componentsJoinedByString: @""];
  
  NSAlert *alert = [NSAlert alertWithMessageText: alertText defaultButton: @"OK" alternateButton: nil otherButton:nil  informativeTextWithFormat: informativeText];
  
  [alert runModal];
  [NSApp terminate:self];
}

- (void) startCocoaRackServer {
  
  NSFileManager *fileManager  = [NSFileManager defaultManager];
  
  /* If system has Ruby built in, use it. Otherwise, fireup using jruby complete. */
  if ( [fileManager fileExistsAtPath:systemRubyPath] ){
    [self startCocoaRackServerUsingRuby];
  } else{
    [self startCocoaRackServerUsingJRubyComplete];
  }
  
}

- (void) startCocoaRackServerUsingRuby {
  NSLog(@" ** Starting Server via system ruby");
  NSTask *runTask = [[NSTask alloc] init];
  [runTask setLaunchPath:@"/bin/sh"];
  [runTask setCurrentDirectoryPath: [NSString stringWithFormat: @"%@/scripts", resourcePath]];
  [runTask setArguments:[NSArray arrayWithObjects: @"run.sh", versionString, nil] ];
  [runTask launch];
}

- (void) startCocoaRackServerUsingJRubyComplete {
  NSLog(@" ** Starting Server via jruby-complete");
  NSTask *runTask = [[NSTask alloc] init];
  [runTask setLaunchPath:@"/bin/sh"];
  [runTask setCurrentDirectoryPath: [NSString stringWithFormat: @"%@/scripts", resourcePath]];
  [runTask setArguments:[NSArray arrayWithObjects: @"run_jruby.sh", versionString, nil] ];
  [runTask launch];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
  [_window makeKeyAndOrderFront:self];
  return YES;
}

- (void) applicationDidResignActive:(NSNotification *)notification{
  //[_window setBackgroundColor: [NSColor colorWithDeviceRed:0.33 green:0.34 blue:0.35 alpha:1.0]];
}

- (void) applicationDidBecomeActive:(NSNotification *)notification{
  //[_window setBackgroundColor: [NSColor colorWithDeviceRed:0.28 green:0.33 blue:0.35 alpha:1.0]];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification{
  [_splash setLevel: NSStatusWindowLevel];
  [_splash setBackgroundColor: [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:1]];
  [[[_webview mainFrame] frameView] setAllowsScrolling:YES];
}

@end