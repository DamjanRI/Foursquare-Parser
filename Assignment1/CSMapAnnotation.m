//
//  CSMapAnnotation.m
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import "CSMapAnnotation.h"


@implementation CSMapAnnotation

@synthesize coordinate     = _coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate 
				   title:(NSString*)title
{
	self = [super init];
	_coordinate = coordinate;
    _title = title;
	
	return self;
}

- (NSString *)title
{
	return _title;
}



-(void) dealloc
{
    [super dealloc];
}

@end
