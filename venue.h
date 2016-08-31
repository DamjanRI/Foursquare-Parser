

#import <UIKit/UIKit.h>





@interface TVenue : NSObject {
    NSString *name;
    NSString *kind;
    double lat;
    double lng;
    double distance;
   }

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *kind;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double distance;

@end
