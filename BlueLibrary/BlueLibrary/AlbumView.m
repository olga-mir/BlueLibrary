//
//  AlbumView.m
//  BlueLibrary
//
//  Created by Olga on 23/06/14.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"


// 2LEARN (from https://developer.apple.com/library/mac/documentation/cocoa/conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html)
// You Can Define Instance Variables without Properties
// It’s best practice to use a property on an object any time you need to keep track of a value or another object.
// If you do need to define your own instance variables without declaring a property, you can add them inside braces at the top of the class interface or implementation, like this:
// These variables are truely private (by default)

@implementation AlbumView
{
  UIImageView *coverImage;
  UIActivityIndicatorView *indicator;
}

- (id)initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover
{
  self = [super initWithFrame:frame];
  
  if (self)
  {
    self.backgroundColor = [UIColor blackColor];
    
    // the coverImage has a 5 pixels margin from its frame
    coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
    [self addSubview:coverImage];
    
    indicator = [[UIActivityIndicatorView alloc] init];
    indicator.center = self.center;
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator startAnimating];
    [self addSubview:indicator];
    
    [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification"
                                                        object:self
                                                      userInfo:@{@"imageView":coverImage, @"coverUrl":albumCover}];
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  // if ([keyPath isEqualToString:@"image"] && [object valueForKey:keyPath] != nil)
  if ([keyPath isEqualToString:@"image"])
  {
    [indicator stopAnimating];
  }
}

- (void)dealloc
{
  [coverImage removeObserver:self forKeyPath:@"image"];
}

@end