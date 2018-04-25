//
//  AdaptiveCardCollectionViewCollectionViewController.m
//  Test
//
//  Created by jwoo on 4/16/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

#import "AdaptiveCardCollectionViewCollectionViewController.h"
#import "AdaptiveCards/ACFramework.h"
#import "SpeechBubbleView.h"

@interface AdaptiveCardCollectionViewCollectionViewController ()
{
    NSArray<NSString*> *_pathsToFiles;
    NSString *_hostConfig;
}
@end

@implementation AdaptiveCardCollectionViewCollectionViewController

static NSString * const reuseIdentifier = @"chatEntryCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    NSBundle *main = [NSBundle mainBundle];
    _pathsToFiles = [main pathsForResourcesOfType:@"json" inDirectory:nil];
    _hostConfig = [NSString stringWithContentsOfFile:[main pathForResource:@"sample" ofType:@"json"]
                                            encoding:NSUTF8StringEncoding
                                               error:nil];
    //self.reuseIdentifier = @"chatEntryCellId";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_pathsToFiles count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    NSString *payload = [NSString stringWithContentsOfFile:_pathsToFiles[indexPath.section] encoding:NSUTF8StringEncoding error:nil];

    ACRRenderResult *renderResult;
    ACOHostConfigParseResult *hostconfigParseResult = [ACOHostConfig fromJson:_hostConfig];
    ACOAdaptiveCardParseResult *cardParseResult = [ACOAdaptiveCard fromJson:payload];
    if(cardParseResult.isValid){
        renderResult = [ACRRenderer render:cardParseResult.card config:hostconfigParseResult.config widthConstraint:300];
    }

    if(renderResult.succeeded)
    {

        SpeechBubbleView *speechBubbleView  = [[SpeechBubbleView alloc] init];
        speechBubbleView.translatesAutoresizingMaskIntoConstraints = NO;
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        cell.backgroundView = speechBubbleView;
        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        //[speechBubbleView addSubview:renderResult.view];
        [cell.contentView addSubview:renderResult.view];
        [cell.contentView didMoveToSuperview];
    
        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:renderResult.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0].active = YES;

        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:renderResult.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;

        [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:cell.contentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0].active = YES;

        [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;

/*
        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:renderResult.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;

        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-5].active = YES;
        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0].active = YES;
 */
    }
    return cell;
    // Configure the cell  
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
