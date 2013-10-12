//
//  AppDelegate.h
//  cocoa-rack
//
//  Created by Brian M. Gonzalez.
//  Copyright (c) 2013. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

extern NSString *const PORT;
extern NSString *const HOST;
extern NSString *const URL;


@interface AppDelegate : NSObject <NSApplicationDelegate>{
  NSString *ready;
@private int fxServerTask1;
}

@property (nonatomic, retain) NSTask              *fxServerTask;
@property (assign) IBOutlet NSWindow              *splash;
@property (assign) IBOutlet NSWindow              *window;
@property (assign) IBOutlet WebView               *webview;
@property (assign) IBOutlet NSProgressIndicator   *progress;
@property (nonatomic, retain) NSString            *serverVersion;
@property (nonatomic, retain) NSString            *resourcePath;
@property (nonatomic, retain) NSString            *systemRubyPath;
@property (nonatomic, retain) NSString            *versionString;
@property (nonatomic, retain) NSString            *portString;
@property (nonatomic, assign) BOOL                *versionsInSync;
@property (nonatomic, retain) NSString            *currentVersion;
@property (nonatomic, retain) NSTimer             *pingTimer;
@property (nonatomic, retain) NSTimer             *longRunningTimer;
@property (nonatomic, retain) NSTimer             *alertTimer;

@end
