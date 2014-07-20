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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
  }
  return self;
}


// Singleton pattern

+ (LibraryAPI *)sharedInstance
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

- (NSArray *)getAlbums
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

- (void)downloadImage:(NSNotification *)notification
{
  // 1
  UIImageView *imageView = notification.userInfo[@"imageView"];
  NSString *coverUrl = notification.userInfo[@"coverUrl"];
  
  // 2
  imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
  
  // if the file wasn't downloaded previously then download it and save it.
  if (imageView.image == nil)
  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      UIImage *image = [httpClient downloadImage:coverUrl];
      
      dispatch_sync(dispatch_get_main_queue(), ^{
        imageView.image = image;
        [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
      });
    });
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end



