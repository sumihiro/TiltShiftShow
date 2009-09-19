//
//  DetailViewController.h
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
	IBOutlet UIWebView *mainWebView;
	NSDictionary *picture;
	
	id delegate;
}

@property (nonatomic,retain) UIWebView *mainWebView;
@property (nonatomic,retain) NSDictionary *picture;
@property (assign) id delegate;

-(IBAction)close:(id)sender;

@end

@protocol DetailViewControllerDelegate <NSObject>

-(void)detailViewControllerWillClose:(DetailViewController*)detailViewController;

@end
