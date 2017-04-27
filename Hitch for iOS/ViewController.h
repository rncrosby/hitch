//
//  ViewController.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/15/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate> {
    CGRect *cardframe;
    UIView *line;
    // VIEWS
    UIView *bgVideo;
    __weak IBOutlet UILabel *titl;
    __weak IBOutlet UILabel *descrip;
    __weak IBOutlet UILabel *card;
    __weak IBOutlet UITextField *emailfield;
    __weak IBOutlet UITextField *passwordfield;
    __weak IBOutlet UIButton *signinbutton;
    __weak IBOutlet UIButton *signupbutton;
    __weak IBOutlet UILabel *accessResult;
        __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UILabel *firsttime;
}
@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;
- (IBAction)signin:(id)sender;
- (IBAction)signup:(id)sender;

@end

