                    //
//  ViewController.m
//  Assignment1
//
//  Created by Damjan on 28.08.2016..
//  Copyright © 2016. Damjan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
NSString *clientID;
}
@end

@implementation ViewController
@synthesize foursquare;

- (void)viewDidLoad {
  [super viewDidLoad];
    //
    clientID = @"Enter your Foursquare Client ID Here";
    
    //
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;

    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [locationManager startUpdatingLocation];
     [locationManager requestWhenInUseAuthorization];
    //Initialize the dataArray
    dataArray = [[NSMutableArray alloc] init];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    curLocation = location.coordinate;
    if (!foursquare) {
        foursquare = [[BZFoursquare alloc] initWithClientID:clientID callbackURL:@"assignment1://foursqare"];
        foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        foursquare.sessionDelegate = self;
        [foursquare startAuthorization];
    }
    //

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        return nil;
    } else {
        return indexPath;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Number of rows it should expect should be based on the section
    NSMutableArray *TVenuesDBArray = [dataArray objectAtIndex:section];
    return [TVenuesDBArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
     NSMutableArray *TVenuesDBArray = [dataArray objectAtIndex:0];
    TVenue *venue = (TVenue*)[TVenuesDBArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %.0fm", venue.name,venue.distance];
    return cell;
}


- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare;
{
    [self searchVenues];
}




- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [self refreshVenues: request.response];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

NSInteger venueCompare(id item1, id item2, void *context)
{
    NSNumber *a = [NSNumber numberWithDouble:((TVenue *)item1).distance];
    NSNumber *b = [NSNumber numberWithDouble:((TVenue *)item2).distance];
    return [a compare:b];
}

-(TVenue*) JSONToVenue:(NSDictionary *)dictionary venue:(TVenue*)venue {
    
    venue.name = [dictionary objectForKey:@"name"];
    NSDictionary *location = [dictionary objectForKey:@"location"];
   venue.lat = [[location objectForKey:@"lat"] doubleValue];
    venue.lng = [[location objectForKey:@"lng"] doubleValue];
    venue.distance = [[location objectForKey:@"distance"] doubleValue];
    return venue;
   }
    

- (void)refreshVenues:(NSDictionary *)resp;
{
    if ([resp objectForKey:@"venues"]) {
    NSMutableArray *venues = [resp objectForKey:@"venues"];
        venues = venues;
         NSMutableArray *TVenuesDBArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [venues count]; i++) {
            //
            NSDictionary *venueArr = [venues objectAtIndex:i];
            if (venueArr) {
             TVenue *venue = [[TVenue alloc] init];
                venue = [self JSONToVenue:venueArr venue:venue];
                [TVenuesDBArray addObject:venue];
                //add to map
                annotation = [[CSMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(venue.lat, venue.lng) title:venue.name];
                [map addAnnotation:annotation];
                
          }
    }
        [map showAnnotations:map.annotations animated:YES];
        //sort
        NSArray *temp = [NSArray arrayWithArray:TVenuesDBArray];
        TVenuesDBArray = [NSMutableArray arrayWithArray:
                                [temp sortedArrayUsingFunction:venueCompare context:NULL]];
        //
        [dataArray addObject:TVenuesDBArray];
        [tableV reloadData];

}
    }



- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error userInfo][@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
  //  [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)cancelRequest {
    if (_request) {
        _request.delegate = nil;
        [_request cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
}

- (void)searchVenues {
    [self prepareForRequest];
    NSString *curLocationStr = [NSString stringWithFormat:@"%f,%f",curLocation.latitude, curLocation.longitude];
    NSDictionary *parameters = @{@"ll": curLocationStr,@"categoryId": @"4d4b7105d754a06374d81259",@"limit": @"10",@"intent": @"checkin", @"broadcast": @"public"};
    self.request = [foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [self.request start];
   // [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)checkin {
    [self prepareForRequest];
    NSDictionary *parameters = @{@"venueId": @"4d4b7105d754a06374d81259", @"broadcast": @"public"};
    self.request = [foursquare requestWithPath:@"checkins/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    [self.request start];
  //  [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
