//
//  ImageDetailViewController.h
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/23/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *fullSizeImage;
@property (nonatomic, weak) IBOutlet UIButton *btnTwitterRedirect;
@property (nonatomic, copy) NSString *imageURL;

@end
