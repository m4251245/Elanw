//
//  MapMarker.m
//  testMap
//
//  Created by job1001 job1001 on 11-11-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MapMarker.h"


@implementation MapMarker

@synthesize coordinate = _coordinate;
@synthesize _name;
@synthesize _subTitle;

-(id) init
{
    self = [super init];
    
    if( self )
    {
        
    }
    
    return self;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if( self )
    {
        _coordinate = coordinate;
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (NSString *)title
{
    return _name;
}

- (NSString *)subtitle
{
    return _subTitle;
}

@end

