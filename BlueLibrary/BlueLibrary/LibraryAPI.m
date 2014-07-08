//
//  AlbumAPI.m
//  BlueLibrary
//
//  Created by Olga on 2/07/14.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"
#import "HTTPClient.h"

@interface LibraryAPI ()
{
  PersistencyManager *persistencyManager;
  HTTPClient *httpClient;
  BOOL isOnline; //  determines if the server should be updated with any changes made to the albums list, such as added or deleted albums
}

@end

@implementation LibraryAPI

- (id)init
{
  self = [super init];
  if (self) {
    persistencyManager = [[PersistencyManager alloc] init];
    httpClient = [[HTTPClient alloc] init];
    isOnline = NO;
  }
  return self;
}


// Singleton pattern

+ (LibraryAPI*)sharedInstance
{
  // Static variable to hold the instance of the class, available globally inside the class.
  static LibraryAPI *_sharedInstance = nil;
  
  // Declare the static variable dispatch_once_t which ensures that the initialization code executes only once.
  static dispatch_once_t oncePredicate;
  
  // Use Grand Central Dispatch (GCD) to execute a block which initializes an instance of LibraryAPI
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[LibraryAPI alloc] init];
  });
  return _sharedInstance;
}

- (NSArray*)getAlbums
{
  return [persistencyManager getAlbums];
}

- (void)addAlbum:(Album*)album atIndex:(int)index
{
  [persistencyManager addAlbum:album atIndex:index];
  if (isOnline) {
    [httpClient postRequest:@"/api/addAlbum" body:[album description]];
  }
}

- (void)deleteAlbumAtIndex:(int)index
{
  [persistencyManager deleteAlbumAtIndex:index];
  if (isOnline) {
    [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
  }
}


@end



