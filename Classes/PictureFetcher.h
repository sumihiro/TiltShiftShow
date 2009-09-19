//
//  PictureFetcher.h
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SBJSON.h"

@interface PictureFetcher : NSObject {
	id delegate;
}

@property (assign) id delegate;

- (void)fetch;

@end

@protocol PictureFetcherDelegate <NSObject>

-(BOOL)fetcher:(PictureFetcher*)fetcher shouldStartSavePicture:(NSDictionary*)tweet;
-(void)fetcher:(PictureFetcher*)fetcher didSavePicture:(NSDictionary*)tweet withTempPicturePath:(NSString*)tempPicturePath;
-(void)fetcherDidFinishAllFetches:(PictureFetcher*)fetcher;

@end
