//
//  Album.m
//  BlueLibrary
//
//  Created by Olga on 23/06/14.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id)initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year
{
  self = [super init];
  if (self)
  {
    _title = title;
    _artist = artist;
    _coverUrl = coverUrl;
    _year = year;
    _genre = @"Pop";
  }
  return self;
}

@end
