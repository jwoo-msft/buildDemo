//
//  ViewController.m
//  Test
//
//  Created by jwoo on 3/12/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import "ViewController.h"
#import "AdaptiveCards/ACRRenderer.h"
//#import "ACFramework.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ChatView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    NSString *json = @"{\
    \"$schema\": \"http://adaptivecards.io/schemas/adaptive-card.json\",\
    \"type\": \"AdaptiveCard\",\
    \"version\": \"1.0\",\
    \"body\": [\
    {\
    \"type\": \"TextBlock\",\
    \"text\": \"This card's action will open a URL\"\
    }\
    ],\
    \"actions\": [\
    {\
    \"type\": \"Action.OpenUrl\",\
    \"title\": \"Action.OpenUrl\",\
    \"url\": \"http://adaptivecards.io\"\
    }\
    ]\
    }";
    ACOAdaptiveCardParseResult *parseResult = [ACOAdaptiveCard fromJson:json];
    if(parseResult.isValid){
        ACRRenderResult *renderResult = [ACRRenderer render:parseResult.card config:nil widthConstraint:330.0];
        if(renderResult.succeeded){
            [self.view addSubview:renderResult.view];
            [self.view didMoveToSuperview];
            renderResult.view.acrActionDelegate = self;
            [NSLayoutConstraint constraintWithItem:renderResult.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:200].active = YES;
            [NSLayoutConstraint constraintWithItem:renderResult.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50.0].active = YES;
        }
    }
}

- (void) didFetchUserResponses:(ACOAdaptiveCard *)card action:(ACOBaseActionElement *)action
{
    if(action.type == ACROpenUrl){
        NSURL *url = [NSURL URLWithString:[action url]];
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:svc animated:YES completion:nil];
    }
    else if(action.type == ACRSubmit){
        NSData * userInputsAsJson = [card inputs];
        NSString *str = [[NSString alloc] initWithData:userInputsAsJson encoding:NSUTF8StringEncoding];
        NSLog(@"user response fetched: %@ with %@", str, [action data]);
    }
}

- (void)didFetchSecondaryView:(ACOAdaptiveCard *)card navigationController:(UINavigationController *)naviationController
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
