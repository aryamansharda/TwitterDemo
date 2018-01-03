//
//  TwitterEngineViewController.m
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/24/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import "TwitterEngineViewController.h"
#import "TwitterEngine.h"
#import "ImageDetailViewController.h"
#import "UIImage+AsyncLoading.h"
#import "ImageCache.h"
#import "ImageCollectionViewCell.h"
#import "TrendingTopicsCollectionViewCell.h"

@interface TwitterEngineViewController ()

@end
@implementation TwitterEngineViewController {
    NSArray *trendingTopics;
    NSMutableArray *dataStore;
    NSString *maxID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtSearchPhrase.delegate = self;
    [self.txtSearchPhrase becomeFirstResponder];
    self.txtSearchPhrase.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter search query or hashtag" attributes:@{ NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    dataStore = [[NSMutableArray alloc] init];
    maxID = [[NSString alloc] init];
    
    //Load and display trending topics asynchronously
    [TwitterEngine loadTrendingTopics:^(NSMutableArray *topics) {
        trendingTopics = topics;
        [self.trendingTopicsCollection reloadData];
    }];
    
}

- (IBAction)loadImagesForNewQuery {
    //Reset the dataStore array and the cache. Load new images from Twitter
    [self loadImagesFromTwitter:YES];
}

- (void)loadImagesFromTwitter:(BOOL)shouldReset {
    if ([self.txtSearchPhrase.text length] == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter a search keyword!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            return;
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self.txtSearchPhrase resignFirstResponder];
    [self.btnSearch setEnabled:NO];
    
    //Show activity indicator while waiting for response from Twitter API
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    
    //Only reset if searching for a new word, not when you are extending a current query
    if (shouldReset) {
        //Clear cache and list of objects in anticipation of new query
        [dataStore removeAllObjects];
        [[[ImageCache sharedInstance] imageCache] removeAllObjects];
    }
    
    [self.btnSearch setEnabled:YES];
    
    [TwitterEngine loadImages:self.txtSearchPhrase.text withMaxID:maxID withCallback:^(NSArray *statuses) {
        if ([statuses count] != 0) {
            NSMutableArray *newImages = [[NSMutableArray alloc] init];
            for (NSDictionary *status in statuses) {
                //Twitter JSON response categorizes images into extended_entities and retweeted categories
                [newImages addObjectsFromArray:[status valueForKeyPath:@"extended_entities.media.media_url_https"]];
                [newImages addObjectsFromArray:[status valueForKeyPath:@"retweeted_status.entities.media.media_url_https"]];
            }
            
            [dataStore addObjectsFromArray:[[NSSet setWithArray:newImages] allObjects]];
            maxID = [statuses[[statuses count] - 1] valueForKey:@"id"];
            [self.queryResultsCollection reloadData];
        }
       
        [activityIndicator stopAnimating];
    }];       
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection View delegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     if (collectionView == self.trendingTopicsCollection) {
         return [trendingTopics count];
     } else if (collectionView == self.queryResultsCollection) {
         return [dataStore count];
     }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.trendingTopicsCollection) {
        TrendingTopicsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TrendingTopics" forIndexPath:indexPath];
        [cell.trendingTopicTitle setText:[trendingTopics objectAtIndex:indexPath.row]];
        [cell.trendingTopicTitle setBackgroundColor:[UIColor greenColor]];
        [cell.trendingTopicTitle.layer setCornerRadius:4.0f];
        [cell.trendingTopicTitle.layer setMasksToBounds:YES];
        return cell;
    } else if (collectionView == self.queryResultsCollection) {
        ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TwitterImages" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        
        //Check if image exists in cache
        NSString *url = [dataStore objectAtIndex:indexPath.row];
        UIImage *image = [[ImageCache sharedInstance] getCachedImageForKey:url];
        
        //Invalidate any entry in the cell (cell could potentially be in use)
        cell.imageView.image = nil;
        
        if (image) {
            [cell.imageView setImage:image];
        } else {
            //Asynchronously load image as it was not found in cache
            [UIImage asyncLoadFromURL:[NSURL URLWithString:url] callback:^(UIImage *image) {
                if (image && cell.tag == indexPath.row) {
                    
                    [cell.imageView setImage:image];
                    [cell setNeedsLayout];
                    
                    //Add image to cache
                    [[ImageCache sharedInstance] cacheImage:image forKey:url];
                }
            }];
        }
        
        return cell;
    }
    return NULL;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([dataStore count]) {
        //If the user is at the bottom of the list, load more entries. Using a buffer of 3 to ensure smooth scrolling.
        NSInteger index = (indexPath.section * 2) + indexPath.row + 3;
        if (index >= ([dataStore count] - 1)) {
            [self loadImagesFromTwitter:NO];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (collectionView == self.trendingTopicsCollection) {
        //Set text field to trending topic chosen
        [self.txtSearchPhrase setText:[trendingTopics objectAtIndex:indexPath.row]];
    } else if (collectionView == self.queryResultsCollection) {
        //Open detail view to see and download image
        [self performSegueWithIdentifier:@"showDetailView" sender:self];
    }
}

#pragma mark - Segue Transition
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetailView"]) {
        NSIndexPath *indexPath = [self.queryResultsCollection indexPathsForSelectedItems][0];
        ImageDetailViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.imageURL = [dataStore objectAtIndex:indexPath.row];
        [self.queryResultsCollection deselectItemAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Text Field delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
