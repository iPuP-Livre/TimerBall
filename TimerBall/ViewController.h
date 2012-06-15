//
//  ViewController.h
//  TimerBall
//
//  Created by Marian PAUL on 21/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    UIImageView *_ballImageView, *_wallImageView;
    CGPoint _ballVelocity;
    NSTimer *_refreshTimer;
    
    CGFloat _topSide, _bottomSide, _leftSide, _rightSide;
}
@end
