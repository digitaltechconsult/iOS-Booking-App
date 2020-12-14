//
//  CustomViewController.m
//  Chateau
//
//  Created by Bogdan Coticopol on 10.09.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //set background
    UIImage *background = [UIImage imageNamed:@"background2"];
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.frame];
    image.image = background;
    image.center = self.view.center;
    image.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:image];
    [self.view sendSubviewToBack:image];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:background];
    
    [super viewWillAppear:animated];
    Sound *snd = [Sound sharedInstance];
    [snd playSound];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
