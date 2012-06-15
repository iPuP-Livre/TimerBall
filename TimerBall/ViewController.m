//
//  ViewController.m
//  TimerBall
//
//  Created by Marian PAUL on 21/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define LARGEUR_HAUTEUR_BALLE 30.0 
#define FREQUENCE_RAFRAICHISSEMENT 30.0 // Hz

@implementation ViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];

    _ballImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LARGEUR_HAUTEUR_BALLE, LARGEUR_HAUTEUR_BALLE)];
    _ballImageView.image = [UIImage imageNamed:@"balle.png"];
    [self.view addSubview:_ballImageView];
    
    _wallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 160, 100, 156)];
    _wallImageView.image = [UIImage imageNamed:@"mur_de_briques.png"];
    [self.view addSubview:_wallImageView];
    
    UIButton *startStopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [startStopButton setTitle:@"Stop" forState:UIControlStateSelected];
    [startStopButton addTarget:self action:@selector(startStop:) forControlEvents:UIControlEventTouchUpInside];
    [startStopButton setFrame:CGRectMake(20, 410, 60, 30)];
    [self.view addSubview:startStopButton];
    
    _ballVelocity = CGPointMake(7, 3); // [1]
    
    _topSide = CGRectGetMinY(_wallImageView.frame); // [2]
    _bottomSide = CGRectGetMaxY(_wallImageView.frame);
    _leftSide = CGRectGetMinX(_wallImageView.frame);
    _rightSide = CGRectGetMaxX(_wallImageView.frame);
}

- (void) startStop:(id)sender 
{
    UIButton *but = (UIButton*)sender;
    if (but.selected) // [1]
    {
        [_refreshTimer invalidate];
        _refreshTimer = nil; // [2]        
    }
    else //[3]
    { 
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1/FREQUENCE_RAFRAICHISSEMENT target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    }
    [but setSelected:![but isSelected]];
}

- (void) refresh : (NSTimer*)timer 
{
    if(_ballImageView.center.x - LARGEUR_HAUTEUR_BALLE/2.0 < 0.0 // [1]
       ||
       _ballImageView.center.x + LARGEUR_HAUTEUR_BALLE/2.0 > 320.0)
        _ballVelocity.x = -_ballVelocity.x;
    if(_ballImageView.center.y - LARGEUR_HAUTEUR_BALLE/2.0 < 0.0 
       ||
       _ballImageView.center.y + LARGEUR_HAUTEUR_BALLE/2.0 > 480.0)
        _ballVelocity.y = -_ballVelocity.y;
    
    //On a besoin de savoir si la nouvelle position touche le mur, mais il faut garder l'ancienne position pour faire des calculs
    CGRect newFrame = _ballImageView.frame;
    
    // on calcule la nouvelle position
    newFrame.origin.x += _ballVelocity.x;
    newFrame.origin.y += _ballVelocity.y;
    
    // Attention, la balle n'a pas encore bougée. On regarde juste si elle toucherait le mur
    if (CGRectIntersectsRect(newFrame, _wallImageView.frame)) // [2]
    {
        // haut ou bas du mur
        if (_ballImageView.center.y < _topSide || _ballImageView.center.y > _bottomSide)
            _ballVelocity.y = -_ballVelocity.y;
        
        // gauche ou droit du mur    
        if (_ballImageView.center.x < _leftSide || _ballImageView.center.x > _rightSide)
            _ballVelocity.x = -_ballVelocity.x;
        
    } else 
    {
        // On ne bouge la balle que s'il n'y a pas de collision
        _ballImageView.frame = newFrame;
    }    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
