//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by Olga on 8/07/14.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

- (NSDictionary *)tr_tableRepresentation;

@end
