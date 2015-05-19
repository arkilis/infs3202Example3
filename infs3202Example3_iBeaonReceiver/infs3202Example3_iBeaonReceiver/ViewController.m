//
//  ViewController.m
//  infs3202Example3_iBeaconReceiver
//
//  Created by Ben Liu on 17/05/2015.
//  Copyright (c) 2015 Ben Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSString *szURL;
    NSMutableDictionary *dictURLs;
    CLBeaconRegion *myBeaconRegion;
    CLLocationManager *locationManager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Pharse RESTful
    NSURL *url = [NSURL URLWithString:@"http://54.210.200.34:8080/urls"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // init
    dictURLs= [[NSMutableDictionary alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         //NSLog(@"data: %@", data);
         if (data.length > 0 && connectionError == nil)
         {
             NSError *e = nil;
             NSArray *res= [NSJSONSerialization JSONObjectWithData:data
                                                           options:0//NSJSONReadingMutableContainers
                                                             error:&e];
             
             NSLog(@"Res: %@", res);
             
             for(NSMutableDictionary *dict in res){
                 NSMutableArray *aryTemp = [[NSMutableArray alloc]init];
                 
                 [aryTemp addObject:dict[@"uuid"]];
                 [aryTemp addObject:dict[@"major"]];
                 [aryTemp addObject:dict[@"minor"]];
                 [aryTemp addObject:dict[@"url"]];
                 [aryTemp addObject:@0];
                 
                 //dictURLs[dict[@"name"]]= aryTemp;
                 [dictURLs setObject:aryTemp forKey:dict[@"name"]];
             }
             //NSLog(@"dictURLs: %@", dictURLs);
         }
         
         
         for(id key in dictURLs){
             // UUID
             NSUUID      *uuid= [[NSUUID alloc] initWithUUIDString:dictURLs[key][0]];
             NSLog(@"uuid xx: %@", uuid);
             // iBeacon region
              myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                 identifier:@"infs3202_7202_example2"];
             
             locationManager= [[CLLocationManager alloc] init];
             locationManager.delegate = self;
             [locationManager startMonitoringForRegion:myBeaconRegion];
             [locationManager startRangingBeaconsInRegion:myBeaconRegion];
             [locationManager requestWhenInUseAuthorization];
             [locationManager requestAlwaysAuthorization];
         }
     }];
}

// When found region
-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region {
    
    NSLog(@"2");
    NSLog(@"%@", dictURLs);
    for (CLBeacon *beacon in beacons) {
        NSLog(@"uuid: %@", [beacon.proximityUUID UUIDString]);
        NSLog(@"major: %@", beacon.major);
        NSLog(@"minor: %@", beacon.minor);
        for(id key in dictURLs){
            if([[beacon.proximityUUID UUIDString] isEqualToString:dictURLs[key][0]] &&
               [beacon.major isEqual: dictURLs[key][1]] &&
               [beacon.minor isEqual: dictURLs[key][2]] &&
               [dictURLs[key][4] isEqual:@0] ){
                
                NSLog(@"%d", NO);
                self.labelStatus.text= [NSString stringWithFormat:@"Load iBeacon Station %@", key];
                NSURL *url= [NSURL URLWithString:dictURLs[key][3]];
                NSURLRequest *request = [NSURLRequest requestWithURL: url];
                [self.myWebView loadRequest:request];
                dictURLs[key][4]=@1;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
