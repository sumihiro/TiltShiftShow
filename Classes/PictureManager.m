//
//  PictureManager.m
//  TiltShiftShow
//
//  Created by 上田 澄博 on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PictureManager.h"

#define kPicturesListArchive @"PictureList.dat"

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

@implementation PictureManager

+(PictureManager*)sharedManager {
	static id obj;
	
	@synchronized(obj) {
		if(!obj) {
			obj = [[PictureManager alloc] init];
		}
	}
	return obj;
}

- (id) init {
	if (self = [super init]) {
		RANDOM_SEED();
		
		[self loadPicturesList];
		newPictures = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSString*)pictureListDataPath {
	NSArray*    paths;
    NSString*   path;
    paths = NSSearchPathForDirectoriesInDomains(
												NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:kPicturesListArchive];
	
	return path;
}

- (void)loadPicturesList {
	@try {
		NSString *path = [self pictureListDataPath];
		pictures = [[NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:path]]retain];
	}
	@catch (NSException * e) {
		pictures = [[NSMutableDictionary alloc] init];
	}
	@finally {
	}
}

- (void)savePicturesList {
	NSString *path = [self pictureListDataPath];
	[NSKeyedArchiver archiveRootObject:pictures toFile:path];
	
	NSLog(@"Save: %@",pictures);
}

-(void)update {
	if(updateing) {
		return;
	}
	
	updateing = YES;
	
	if (!fetcher) {
		fetcher = [[PictureFetcher alloc] init];
		fetcher.delegate = self;
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[fetcher fetch];
}

-(void)clear {
	NSArray *keys = [pictures allKeys];
	for(NSInteger i = 0; i < [keys count]; ++ i) {
		NSString *path = [self pathForFileName:[[pictures objectForKey:[keys objectAtIndex:i]] objectForKey:@"pictureFileName"]];
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
	[pictures removeAllObjects];
	[newPictures removeAllObjects];
	[self savePicturesList];
}


- (void) dealloc
{
	fetcher.delegate = nil;
	[fetcher release];
	
	[newPictures release];
	[pictures release];
	
	[super dealloc];
}

- (NSDictionary*)nextPicture {
	NSDictionary *tweet;
	if([newPictures count]) {
		tweet = [newPictures objectAtIndex:0];
		[newPictures removeObjectAtIndex:0];
	} else {
		if([pictures count] == 0) {
			return nil;
		}
		
		NSArray *keys = [pictures allKeys];
		int rand = RANDOM_INT(0,[keys count] - 1);
		NSString *key = [keys objectAtIndex:rand];
		tweet = [pictures objectForKey:key];
	}
	
	return tweet;
}

- (NSString*)pathForFileName:(NSString*)fileName {
	NSArray*    paths;
	NSString*   path;
	paths = NSSearchPathForDirectoriesInDomains(
												NSDocumentDirectory, NSUserDomainMask, YES);
	path = [paths objectAtIndex:0];
	
	path = [path stringByAppendingPathComponent:fileName];
	
	return path;
}

#pragma mark PictureFetcherDelegate

-(BOOL)fetcher:(PictureFetcher*)fetcher shouldStartSavePicture:(NSDictionary*)tweet {
	return ([pictures objectForKey:[tweet objectForKey:@"URL"]] == nil);
}

-(void)fetcher:(PictureFetcher*)fetcher didSavePicture:(NSDictionary*)tweet withTempPicturePath:(NSString*)tempPicturePath {
	
	if ([pictures objectForKey:[tweet objectForKey:@"URL"]] == nil) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:tweet];

		NSString *filename = [[tempPicturePath pathComponents] lastObject];
		NSString *path = [self pathForFileName:filename];
		
		NSLog(@"Move %@ -> %@",tempPicturePath, path);
		
		NSError *error;
		if(![[NSFileManager defaultManager] moveItemAtPath:tempPicturePath toPath:path error:&error]) {
			NSLog(@"save file failed: %@",error);
		} else {
			[dict setObject:filename forKey:@"pictureFileName"];
			[pictures setObject:dict forKey:[dict objectForKey:@"URL"]];
			[self savePicturesList];
			
			[newPictures addObject:dict];
		}

	}
}

-(void)fetcherDidFinishAllFetches:(PictureFetcher*)fetcher {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	updateing = NO;
}

@end
