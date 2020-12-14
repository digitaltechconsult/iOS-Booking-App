//
//  ContactInformationViewController.m
//  Chateau
//
//  Created by Bogdan Coticopol on 01.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "ContactInformationViewController.h"

#define NAME_TEXTFIELD 1
#define PHONE_TEXTFIELD 2
#define EMAIL_TEXTFIELD 3
#define DATE_TEXTFIELD 4

@interface ContactInformationViewController () {
    NSArray *_textFields;
    NSDate *_pickerDate;
    BOOL _fieldError;
}

@end

@implementation ContactInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    UITapGestureRecognizer *tapOnScreen = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissFirstResponder)];
    tapOnScreen.delegate = self;
    [self.view addGestureRecognizer:tapOnScreen];
    
    _textFields = @[self.name, self.phone, self.email, self.bookingDate];
    [self customizeTextFields];
    
    [self showDatePicker];
    
    if(!_appDelegate.currentOrder) {
        _appDelegate.currentOrder = [[Order alloc]init];
    }
    
    [self loadUserData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ViewController *vc = segue.destinationViewController;
    if([vc isMemberOfClass:[NavigationViewController class]]) {
        NavigationViewController *nc = (NavigationViewController *)vc;
        nc.isCalledFromHomePage = NO;
        
        _appDelegate.currentOrder.name = self.name.text;
        _appDelegate.currentOrder.phone = self.phone.text;
        _appDelegate.currentOrder.email = self.email.text;
        _appDelegate.currentOrder.bookingDate = self.bookingDate.text;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(![self isInputDataValid]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Nu ai completat toate câmpurile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    [self saveUserData];
    return YES;
}



#pragma mark - GUI methods
- (void)dismissFirstResponder
{
    for (UITextField *textField in _textFields) {
        [textField resignFirstResponder];
        
        if([textField isEqual:self.bookingDate] && _pickerDate) {
            [self updateDateInField];
            _pickerDate = nil;
        }
    }
}


- (void)showDatePicker {
    //create picker
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    datePicker.minuteInterval = 15;
    datePicker.minimumDate = [NSDate date];
    [datePicker addTarget:self action:@selector(getPickerDate:) forControlEvents:UIControlEventValueChanged];
    
    UIView *customKeyboard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (datePicker.bounds.size.height * 1.05) + 40)];
    customKeyboard.backgroundColor = [UIColor whiteColor];
    customKeyboard.layer.cornerRadius = 5;
    customKeyboard.layer.borderWidth = 1;
    customKeyboard.backgroundColor = [UIColor colorWithRed:244 green:244 blue:244 alpha:.97];
    
    UIButton *btnExit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnExit setTitle:@"Închide" forState:UIControlStateNormal];
    btnExit.titleLabel.font = [UIFont fontWithName:@"Avenir Next" size:14];
    btnExit.tintColor = [UIColor blackColor];
    btnExit.frame = CGRectMake(customKeyboard.frame.size.width - 55, 3, 50, 22);
    [btnExit addTarget:self action:@selector(dismissFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    
    [customKeyboard addSubview:btnExit];
    
    //position date picker in the center of the view
    datePicker.center = customKeyboard.center;
    
    //add date picker to custom view
    [customKeyboard addSubview:datePicker ];
    
    //use custom view as keyboard for date textbox
    [self.bookingDate setInputView:customKeyboard];
}

-(void)getPickerDate:(UIDatePicker *)datePicker
{
    _pickerDate = datePicker.date;
}

-(void)updateDateInField
{
    NSString *errMessage;
    if([self checkDate:_pickerDate alertText:&errMessage]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"EEE, dd/MM/yyyy HH:mm"];
        self.bookingDate.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_pickerDate]];
        self.bookingDate.leftView = nil;
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Salonul este închis" message:errMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        self.bookingDate.text = @"";
        //[self.bookingDate becomeFirstResponder];
    }

}

- (void)goBack:(id)sender
{
    _appDelegate.currentOrder = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)customizeTextFields
{
    //placeholder text color
    UIColor *placeholderTextColor = [UIColor grayColor];
    
    //images for cleartext button
    UIImage *clearTextButtonImage = [UIImage imageNamed:@"clearButton"];
    UIImage *clearTextButtonPressedImage = [UIImage imageNamed:@"clearButton pressed"];
    
    for (UITextField *textField in _textFields) {
        
        //create cleartext button
        UIButton *clearTextButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
        [clearTextButton setImage:clearTextButtonImage forState:UIControlStateNormal];
        [clearTextButton setImage:clearTextButtonPressedImage forState:UIControlStateHighlighted];
        [clearTextButton addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
        
        //assign text field context & resize the bottom line of the UITextField
        if([textField.placeholder isEqualToString:@"nume"]) {
            clearTextButton.tag = NAME_TEXTFIELD;
            self.nameLine.frame = CGRectMake(0, 0, self.name.frame.size.width, 1);
            self.nameLine.contentMode = UIViewContentModeScaleAspectFill;
        } else if([textField.placeholder isEqualToString:@"telefon"]) {
            self.phoneLine.frame = CGRectMake(0, 0, self.phone.frame.size.width, 1);
            self.phoneLine.contentMode = UIViewContentModeScaleAspectFill;
            clearTextButton.tag = PHONE_TEXTFIELD;
        } else if([textField.placeholder isEqualToString:@"email"]) {
            self.emailLine.frame = CGRectMake(0, 0, self.email.frame.size.width, 1);
            self.emailLine.contentMode = UIViewContentModeScaleAspectFill;
            clearTextButton.tag = EMAIL_TEXTFIELD;
        } else if([textField.placeholder isEqualToString:@"data programării"]) {
            self.bookingDateLine.frame = CGRectMake(0, 0, self.bookingDate.frame.size.width, 1);
            self.bookingDateLine.contentMode = UIViewContentModeScaleAspectFill;
            clearTextButton.tag = DATE_TEXTFIELD;
        }
        
        //font style of the placeholder text
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:placeholderTextColor}];
        
        //assign text field clear button
        textField.rightView = clearTextButton;
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
        
        //textfield delegate
        textField.delegate = self;
        
        //textfield keyboard
        textField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
}

- (void)clearText:(id)sender
{
    UIButton *clearButton = sender;
    switch(clearButton.tag) {
        case NAME_TEXTFIELD:
            self.name.text = @"";
            break;
        case PHONE_TEXTFIELD:
            self.phone.text = @"";
            break;
        case EMAIL_TEXTFIELD:
            self.email.text = @"";
            break;
        case DATE_TEXTFIELD:
            self.bookingDate.text = @"";
            break;
        default:
            break;
    }
}

-(void)showExclamationMarkForTextField:(UITextField *)textField
{
    textField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"warning"]];
    textField.leftViewMode = UITextFieldViewModeUnlessEditing;
}

#pragma mark - Object Private Methods

-(BOOL)checkDate:(NSDate *)date alertText:(NSString **)alertText
{
    
    if([date compare:[NSDate date]] == NSOrderedAscending || [date compare:[NSDate date]] == NSOrderedSame) {
        *alertText = @"Nu se pot face programări in trecut";
        return NO;
    }
    
    int day = (int)[[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
    
    if(day == 1) { //Sunday
        *alertText = @"Ne pare rău, dar duminica nu se pot face programări";
        return NO;
    }
    
    int hour = (int)[[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:date] hour];
    
    if(hour < 9) { //earlier than 9AM
        *alertText = @"Ne pare rău, este prea devreme, te rugăm sa alegi altă oră";
        return NO;
    } else if(day > 1 && day <7 && hour >= 20 ) { //MON-FRI 9-20
        *alertText = @"Ne pare rău, este prea târziu, te rugăm sa alegi altă oră";
        return NO;
    } else if(day == 7 && hour >= 16) {//Saturday 9-16
        *alertText = @"Ne pare rău, este prea târziu, te rugăm sa alegi alta oră";
        return NO;
    }
    
    alertText = nil;
    return YES;
}

-(BOOL)isInputDataValid
{
    BOOL defaultReturn = YES;
    
    if([self.name.text isEqualToString:@""]) {
        [self showExclamationMarkForTextField:self.name];
        defaultReturn = NO;
    }
    
    if ([self.phone.text isEqualToString:@""]) {
        [self showExclamationMarkForTextField:self.phone];
        defaultReturn = NO;
    }
    
    if([self.email.text isEqualToString:@""]) {
        [self showExclamationMarkForTextField:self.email];
        defaultReturn = NO;
    }
    
    if ([self.bookingDate.text isEqualToString:@""]) {
        [self showExclamationMarkForTextField:self.bookingDate];
        defaultReturn = NO;
    }
    
    return defaultReturn;
}

-(void)saveUserData
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:self.name.text forKey:@"Name"];
    [pref setObject:self.phone.text forKey:@"Phone"];
    [pref setObject:self.email.text forKey:@"Email"];
}

-(void)loadUserData
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    self.name.text = [pref objectForKey:@"Name"];
    self.phone.text = [pref objectForKey:@"Phone"];
    self.email.text = [pref objectForKey:@"Email"];
}


#pragma mark - TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([textField isEqual:self.name]) {
        [self.phone becomeFirstResponder];
    } else if([textField isEqual:self.email]) {
        [self.bookingDate becomeFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@""]) {
        [self showExclamationMarkForTextField:textField];
    } else {
        textField.leftView = nil;
    }
    return YES;
}


@end
