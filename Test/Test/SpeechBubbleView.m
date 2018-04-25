//
//  SpeechBubbleView.m
//  Test
//
//  Created by jwoo on 4/16/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

#import "SpeechBubbleView.h"

@implementation SpeechBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    UIImage *chatBubbleImage = [UIImage imageNamed:@"bubble_received.png"];
    chatBubbleImage = [chatBubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(17, 21, 17, 21) resizingMode:UIImageResizingModeStretch];
    self = [super initWithImage:chatBubbleImage];
    return self;
}

@end
