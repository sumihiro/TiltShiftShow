//
//  PictureFetcher.m
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PictureFetcher.h"
#import "GTMRegex.h"

#define kJSONURL @"http://search.twitter.com/search.json?q=%23TiltShiftGen&rpp=50"

@implementation PictureFetcher

@synthesize delegate;

- (id) init {
	if (self = [super init]) {
		
	}
	return self;
}

- (void)fetch {
	NSMutableArray *tweets = [NSMutableArray arrayWithObjects:nil];
	@try {
		NSError *error;
		NSDictionary *result;
		result = [[NSString stringWithContentsOfURL:[NSURL URLWithString:kJSONURL]
										   encoding:NSUTF8StringEncoding
											  error:&error] JSONValue];
		
		NSLog(@"%@", result);

		GTMRegex *reg = [GTMRegex regexWithPattern:@"http://twitgoo.com/([0-9a-z]+)"];
		NSArray *results = [result objectForKey:@"results"];
		for(NSInteger i = 0; i < [results count]; ++ i) {
			NSDictionary *tweet = [results objectAtIndex:i];
			NSString *text = [tweet objectForKey:@"text"];
			NSString *match = [reg firstSubStringMatchedInString:text];
			
			NSLog(@"match: %@",match);
			if(match) {
				NSString *theID = [match substringFromIndex:19];
				NSString *imageURL = [NSString stringWithFormat:@"http://twitgoo.com/show/img/%@",theID];
				[tweets addObject:[NSDictionary dictionaryWithObjectsAndKeys:match,@"URL"
																			,imageURL,@"imageURL"
																			,[tweet objectForKey:@"text"],@"text"
																			,[tweet objectForKey:@"created_at"],@"createdAt"
																			,[tweet objectForKey:@"from_user"],@"tweetUser"
																			,[tweet objectForKey:@"id"],@"tweetID"
																			,[tweet objectForKey:@"profile_image_url"],@"profileImageUrl"

																			,nil]];
			}
		}
	}
	@catch (NSException * e) {
		NSLog(@"%@",e);
	}
	@finally {
		
	}

	NSLog(@"%@", tweets);
	
	BOOL callDelegate = [delegate respondsToSelector:@selector(fetcher:shouldStartSavePicture:)];
	for (NSInteger i = 0; i < [tweets count]; ++ i) {
		NSDictionary *tweet = [tweets objectAtIndex:i];
		if(callDelegate && [delegate fetcher:self shouldStartSavePicture:tweet]) {
			NSError *error;
			NSHTTPURLResponse *response;
			NSData *content = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:
																	   [NSURL URLWithString:
																		[tweet objectForKey:@"imageURL"]]]
													returningResponse:&response
																error:&error];
			if(error) {
				//TODO:error
				NSLog(@"file download failed:%@",error);
			} else if ([response statusCode] != 200) {
				//TODO:error
				NSLog(@"file download failed:%@",response);
			} else {
				//TODO:save
				NSString *tmpPath = NSTemporaryDirectory();
				tmpPath = [tmpPath stringByAppendingPathComponent:[[[[NSURL URLWithString:[tweet objectForKey:@"imageURL"]] path] pathComponents] lastObject]];
				if([content writeToFile:tmpPath atomically:NO]) {
					[delegate fetcher:self didSavePicture:tweet withTempPicturePath:tmpPath];
				} else {
					NSLog(@"file save failed:%@",tmpPath);
				}

			}

		}
	}
	
	if ([delegate respondsToSelector:@selector(fetcherDidFinishAllFetches:)]) {
		[delegate fetcherDidFinishAllFetches:self];
	}
	return;
}

@end
