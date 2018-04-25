//
//  AdaptiveCardTableViewController.m
//  Test
//
//  Created by jwoo on 4/13/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

#import "AdaptiveCardTableViewController.h"
#import "AdaptiveCards/ACFramework.h"
#import "SpeechBubbleView.h"
@interface AdaptiveCardTableViewController ()
{
    NSArray<NSString*> *_pathsToFiles;
    NSString *_hostConfig;
}
@end

@implementation AdaptiveCardTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSBundle *main = [NSBundle mainBundle];
    _pathsToFiles = [main pathsForResourcesOfType:@"json" inDirectory:nil];
    _hostConfig = [NSString stringWithContentsOfFile:[main pathForResource:@"sample" ofType:@"json"]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_pathsToFiles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tabCellId";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];

    }
    else
    {
        if([[cell.contentView subviews] count]){
            [[cell.contentView subviews][0] removeFromSuperview];
        }
    }

    NSString *payload = [NSString stringWithContentsOfFile:_pathsToFiles[indexPath.row] encoding:NSUTF8StringEncoding error:nil];

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
        [speechBubbleView addSubview:renderResult.view];
        [cell.contentView addSubview:speechBubbleView];
        [cell.contentView didMoveToSuperview];

        [NSLayoutConstraint constraintWithItem:speechBubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:renderResult.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-27.0].active = YES;
        [NSLayoutConstraint constraintWithItem:speechBubbleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:renderResult.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0].active = YES;
        [NSLayoutConstraint constraintWithItem:speechBubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:renderResult.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:renderResult.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;

        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
              [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-5].active = YES;
        [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:speechBubbleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0].active = YES;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
