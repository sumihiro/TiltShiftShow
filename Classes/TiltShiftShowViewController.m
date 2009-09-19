//
//  TiltShiftShowViewController.m
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TiltShiftShowViewController.h"

#import "PictureManager.h"


@implementation TiltShiftShowViewController

@synthesize flashView;
@synthesize imageView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[flashView setAlpha:0.0f];
	[imageView setAlpha:0.0f];

	//[[PictureManager sharedManager] clear];
	
	[self fireUpdatePictures];
	[NSTimer scheduledTimerWithTimeInterval:120.0f target:self selector:@selector(fireUpdatePictures) userInfo:nil repeats:YES];
	
	[self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1f];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
#pragma mark -
- (void)startAnimation {
	NSDictionary *picture = [[PictureManager sharedManager] nextPicture];
	if(!picture) {
		//FIXME:retry
		NSLog(@"picture not found.");
		//return;
	}
	UIImage *currentImage = [UIImage imageWithContentsOfFile:[[PictureManager sharedManager] pathForFileName:[picture objectForKey:@"pictureFileName"]]];
	[imageView setImage:currentImage];

	[flashView setAlpha:1.0f];
	[imageView setAlpha:1.0f];

	
	[UIView beginAnimations:@"flashFadeout" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.2];
	
	[flashView setAlpha:0.0f];
	
	[UIView commitAnimations];
	
	[UIView beginAnimations:@"imageFadeout" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:5.0];

	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

	[imageView setAlpha:0.0f];
	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	NSLog(@"%@",NSStringFromSelector(_cmd));
	[self startAnimation];
}

#pragma mark -
- (void)fireUpdatePictures {
	NSLog(@"%@",NSStringFromSelector(_cmd));
	[self performSelectorInBackground:@selector(updatePictures) withObject:nil];
}

- (void)updatePictures {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	PictureManager *pm = [PictureManager sharedManager];
	[pm update];

	[pool release];
}

@end
