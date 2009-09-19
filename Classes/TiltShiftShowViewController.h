//
//  TiltShiftShowViewController.h
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiltShiftShowViewController : UIViewController {
	IBOutlet UIView *flashView;
	IBOutlet UIImageView *imageView;
}

@property (nonatomic,retain) UIView *flashView;
@property (nonatomic,retain) UIImageView *imageView;

- (void)fireUpdatePictures;

@end

