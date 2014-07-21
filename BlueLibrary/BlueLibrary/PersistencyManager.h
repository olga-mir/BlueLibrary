//
//  PersistencyManager.h
//  BlueLibrary
//
//  Created by Olga on 2/07/14.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface PersistencyManager : NSObject

- (NSArray *)getAlbums;

- (void)addAlbum:(Album *)album atIndex:(int)index;

- (void)deleteAlbumAtIndex:(int)index;

// Save and get iamge from the iOS file system
- (void)saveImage:(UIImage *)image filename:(NSString *)filename;
- (UIImage *)getImage:(NSString *)filename;

// Archiving album data
- (void)saveAlbums;

@end
