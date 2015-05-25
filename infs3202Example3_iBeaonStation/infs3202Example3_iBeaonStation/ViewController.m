//
//  ViewController.m
//  infs3202Example3_iBeaonStation
//
//  Created by Ben Liu on 19/05/2015.
//  Copyright (c) 2015 Ben Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableDictionary *dictURLs;
    CLLocationManager   *locationManager;
    NSDictionary        *beaconData;
    CBPeripheralManager *peripheralManager;
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
                 [aryTemp addObject:dict[@"urlview"]];
                 [aryTemp addObject:dict[@"urlres"]];
                 [aryTemp addObject:@0];
                 
                 //dictURLs[dict[@"name"]]= aryTemp;
                 [dictURLs setObject:aryTemp forKey:dict[@"name"]];
             }
             NSLog(@"dictURLs: %@", dictURLs);
         }
     }];
}


// override method required by CBPeripheralManagerDelegate
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral {
    // if the bluetooth is on
    if (peripheral.state == CBPeripheralManagerStatePoweredOn){
        [peripheralManager startAdvertising:beaconData];
        NSLog(@"Start Broadcast: %@", beaconData);
    }
    // if the bluetooth is off
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff){
        [peripheralManager stopAdvertising];
    }
    // not supported
    else if(peripheral.state == CBPeripheralManagerStateUnsupported) {
        self.labelStatus.text= @"Not supported";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOK:(id)sender {
    
    NSString *urlName= self.textfieldURL.text;
    if (![urlName isEqualToString:@""]) {
        
        // update status
        self.labelStatus.text= [NSString stringWithFormat:@" %@ is broadcasting...", urlName];
        
        // UUID
        NSUUID      *uuid= [[NSUUID alloc] initWithUUIDString:dictURLs[urlName][0]];
        
        NSLog(@"uuid: %@", uuid);
        NSLog(@"major: %@", dictURLs[urlName][1]);
        NSLog(@"minor: %@", dictURLs[urlName][2]);
        
        // Major and Minor
        CLBeaconRegion *beaconRegion= [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                              major:[dictURLs[urlName][1] integerValue]
                                                                              minor:[dictURLs[urlName][2] integerValue]
                                                                         identifier:@"infs3202_7202_example2"];
        beaconData= [beaconRegion peripheralDataWithMeasuredPower:nil];
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                   queue:nil
                                                                 options:nil];
        
    }
}

- (IBAction)btnFresh:(id)sender {
    
    NSString *urlName= self.textfieldURL.text;
    if (![urlName isEqualToString:@""]) {
    }
    // load url
    NSURL *url = [NSURL URLWithString:dictURLs[urlName][4]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
}



@end










































