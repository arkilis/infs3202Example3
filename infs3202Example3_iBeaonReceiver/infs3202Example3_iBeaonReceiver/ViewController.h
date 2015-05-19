//
//  ViewController.h
//  infs3202Example3_iBeaonReceiver
//
//  Created by Ben Liu on 19/05/2015.
//  Copyright (c) 2015 Ben Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;


@end

