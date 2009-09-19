//
//  TiltShiftShowAppDelegate.m
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TiltShiftShowAppDelegate.h"
#import "TiltShiftShowViewController.h"

@implementation TiltShiftShowAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
