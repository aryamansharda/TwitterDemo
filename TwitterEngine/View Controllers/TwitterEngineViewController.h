//
//  TwitterEngineViewController.h
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/24/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterEngineViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *trendingTopicsCollection;
@property (nonatomic, strong) IBOutlet UICollectionView *queryResultsCollection;
@property (nonatomic, weak) IBOutlet UITextField *txtSearchPhrase;
@property (nonatomic, weak) IBOutlet UIButton *btnSearch;

@end
