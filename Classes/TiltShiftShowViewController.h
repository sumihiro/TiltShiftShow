//
//  TiltShiftShowViewController.h
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface TiltShiftShowViewController : UIViewController <DetailViewControllerDelegate> {
	IBOutlet UIView *flashView;
	IBOutlet UIView *contentView;
	IBOutlet UILabel *tweetLabel;
	IBOutlet UIImageView *imageView;
	IBOutlet UIButton *coverView;
	
	NSDictionary *currentPicture;
	BOOL shouldLoopAnimation;
}

@property (nonatomic,retain) UIView *flashView;
@property (nonatomic,retain) UIView *contentView;
@property (nonatomic,retain) UILabel *tweetLabel;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UIButton *coverView;

- (IBAction)touchMainView:(id)sender;

- (void)fireUpdatePictures;

@end

