//
//  AdaptiveCardChatView.m
//  Test
//
//  Created by jwoo on 4/13/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdaptiveCardChatView.h"
#import "AdaptiveCards/ACFramework.h"

@implementation AdaptiveCardChatView
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tabCellId";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
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
            [cell.contentView addSubview:renderResult.view];
            [cell.contentView didMoveToSuperview];
            //renderResult.view.acrActionDelegate = self;
            [NSLayoutConstraint constraintWithItem:renderResult.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:200].active = YES;
            [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:renderResult.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
        }
    }
    return cell;
}

@end
