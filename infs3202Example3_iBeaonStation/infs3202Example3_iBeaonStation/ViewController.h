//
//  ViewController.h
//  infs3202Example3_iBeaonStation
//
//  Created by Ben Liu on 19/05/2015.
//  Copyright (c) 2015 Ben Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBPeripheralManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel      *labelStatus;
@property (strong, nonatomic) IBOutlet UITextField  *textfieldURL;
@property (strong, nonatomic) IBOutlet UIWebView    *myWebView;


@end

