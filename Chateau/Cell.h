//
//  Cell.h
//  Chateau
//
//  Created by Bogdan Coticopol on 15.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell

//displayed icon
@property (weak, nonatomic) IBOutlet UILabel *value;
//displayed description
@property (weak, nonatomic) IBOutlet UILabel *text;
@end
