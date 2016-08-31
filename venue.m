

#import "venue.h"


@implementation TVenue

@synthesize name,kind,lat,lng, distance;

- (id) init {
	if(self = [super init]) {
        //Buyer
        name = [[NSString alloc] init];
        kind = [[NSString alloc] init];
        lat = 0;
        lng = 0;
        distance = 0;
	}
	
	return self;
}

- (void) dealloc {
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)coder {
    name = [coder decodeObjectForKey:@"name"];
    kind = [coder decodeObjectForKey:@"kind"];
    lat = [coder decodeDoubleForKey:@"lat"];
    lng = [coder decodeDoubleForKey:@"lng"];
    distance = [coder decodeDoubleForKey:@"distance"];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:kind forKey:@"kind"];
    [encoder encodeDouble:lat forKey:@"lat"];
    [encoder encodeDouble:lng forKey:@"lng"];
    [encoder encodeDouble:distance forKey:@"distance"];
}

@end
