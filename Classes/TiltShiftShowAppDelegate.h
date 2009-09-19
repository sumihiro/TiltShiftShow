//
//  TiltShiftShowAppDelegate.h
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TiltShiftShowViewController;

@interface TiltShiftShowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TiltShiftShowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TiltShiftShowViewController *viewController;

@end

