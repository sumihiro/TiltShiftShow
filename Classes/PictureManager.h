//
//  PictureManager.h
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureFetcher.h"

@interface PictureManager : NSObject <PictureFetcherDelegate> {
	PictureFetcher *fetcher;
	NSMutableDictionary *pictures;
	NSMutableArray *newPictures;
	
	BOOL updateing;
}

+(PictureManager*)sharedManager;
-(void)update;
-(void)clear;

-(NSDictionary*)nextPicture;
- (NSString*)pathForFileName:(NSString*)fileName;

- (void)loadPicturesList;
- (void)savePicturesList;

@end
