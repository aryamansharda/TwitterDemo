//
//  ImageDetailViewController.m
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/23/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "ImageCache.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnTwitterRedirect setTitle:self.imageURL forState:UIControlStateNormal];
    UIImage *image = [[ImageCache sharedInstance] getCachedImageForKey:self.imageURL];
    self.fullSizeImage.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)saveToCameraRoll {
    [self.view snapshotViewAfterScreenUpdates:YES];
    
    UIImageWriteToSavedPhotosAlbum(self.fullSizeImage.image, nil, nil, nil);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Complete!" message:@"Image saved to camera roll." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)viewInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.imageURL] options:@{} completionHandler:nil];
}

@end
