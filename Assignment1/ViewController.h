//
//  ViewController.h
//  Assignment1
//
//  Created by Damjan on 28.08.2016..
//  Copyright © 2016. Damjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BZFoursquare.h"
#import "CSMapAnnotation.h"
#import "venue.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, BZFoursquareRequestDelegate, BZFoursquareSessionDelegate, CLLocationManagerDelegate>
{
    __weak IBOutlet MKMapView *map;
    __weak IBOutlet UITableView *tableV;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D curLocation;
    NSMutableArray *dataArray;
    CSMapAnnotation *annotation;
}


@property(nonatomic,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;

@end

