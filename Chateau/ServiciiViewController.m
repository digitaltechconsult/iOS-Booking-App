//
//  ServiciiViewController.m
//  Chateau
//
//  Created by Bogdan Coticopol on 10.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "ServiciiViewController.h"

@interface ServiciiViewController () {
    NSDictionary *_fullMenu;
    NSString *_currentHierarchy;
    NSArray *_currentMenu;
    NSMutableSet *_checkedOptions;
    NSMutableData *_responseData;
    NSDictionary *_reponse;
    UIActivityIndicatorView *_ai;
    UIView *_activityContainer;
}

@end

@implementation ServiciiViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self loadServicesList];
    _fullMenu = [Order generateServicesMenu];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    
    NavigationViewController *nc = (NavigationViewController *)self.navigationController;
    _isNewOrder = !nc.isCalledFromHomePage;
    
    //custom font for bar buttons
    [self.backButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]} forState:UIControlStateNormal];
    
    if(_isNewOrder) {
        [self.sendButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]} forState:UIControlStateNormal];
        
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if(!_appDelegate.currentOrder.content) {
            _checkedOptions = [[NSMutableSet alloc]initWithCapacity:200];
        } else {
            _checkedOptions = [NSMutableSet setWithSet:_appDelegate.currentOrder.content];
        }
        
    } else {
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    }
    
    [self reloadTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_currentMenu count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _currentMenu[indexPath.row];
    NSString *objectFromHierarchy;
    if(!_currentHierarchy) {
        objectFromHierarchy = key;
    } else {
        objectFromHierarchy = [NSString stringWithFormat:@"%@.%@",_currentHierarchy,key];
    }
    
    if(![self getValueForIndex:(int)indexPath.row]) {
        
        _currentHierarchy = objectFromHierarchy;
        _currentMenu = [self generateMenuItemsFromParentMenu:_currentHierarchy];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }  else if(_isNewOrder) {
        
        if([_checkedOptions containsObject:objectFromHierarchy]) {
            [_checkedOptions removeObject:objectFromHierarchy];
        } else {
            [_checkedOptions addObject:objectFromHierarchy];
        }
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    
    //default options for cell
    cell.text.text = nil;
    cell.value.text = nil;
    if(!_isNewOrder) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.text.text= _currentMenu[indexPath.row];
    NSString *value = [self getValueForIndex:(int)indexPath.row];
    if(value) {
        cell.value.text = value;
        
        NSString *objectToCheck;
        if(_currentHierarchy) {
            objectToCheck = [NSString stringWithFormat:@"%@.%@",_currentHierarchy,_currentMenu[indexPath.row]];
        } else {
            objectToCheck = _currentMenu[indexPath.row];
        }
        
        if(_isNewOrder && [_checkedOptions containsObject:objectToCheck]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}

#pragma mark - GUI Actions

- (IBAction)dismissView:(id)sender
{
    if(!_currentHierarchy) {
        _appDelegate.currentOrder.content = _checkedOptions;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSArray *split = [_currentHierarchy componentsSeparatedByString:@"."];
        NSString *tempCurrentHierarchy = @"";
        for(int i=0;i<[split count]-1;i++) {
            NSString *separator = @".";
            if(i == [split count] - 2) {
                separator = @"";
            }
            tempCurrentHierarchy = [NSString stringWithFormat:@"%@%@%@",tempCurrentHierarchy,split[i],separator];
        }
        _currentHierarchy = [tempCurrentHierarchy isEqualToString:@""] ? nil : tempCurrentHierarchy;
        _currentMenu = [self generateMenuItemsFromParentMenu:_currentHierarchy];
        //[self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (IBAction)send:(id)sender
{
    if(_checkedOptions.count < 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alertă" message:@"Nu ai ales nicio opțiune" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
        
        _appDelegate.currentOrder.content = _checkedOptions;
        NSURLRequest *request = [_appDelegate.currentOrder generateRequest];
        
        [self addLoadingWheel];
        
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - NSURLConnection delegate methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    [self removeLoadingWheel];
    _reponse = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:NULL];
    
    if(_reponse) {
        if(![[_reponse objectForKey:@"Status"] isEqualToString:@"OK"]) {
            _reponse = @{@"Status":@"NOK",@"Response":@"WebAPI Error: Invalid API"};
        }
    } else {
        _reponse = @{@"Status":@"NOK",@"Response":@"WebAPI Error: Invalid Server Address"};
    }
    NSString *responseString;
    NSString *responseTitle = @"";
    
    if([[_reponse objectForKey:@"Status"] isEqualToString:@"NOK"]) {
        responseString = [NSString stringWithFormat:@"Verificați accesul la internet al dispozitivului și incercați din nou (%@)",[_reponse objectForKey:@"Response"]];
        responseTitle = @"Alerta";
        
    } else {
        
        
        responseString = @"Programarea a fost trimisă. Te vom contacta in cel mai scurt timp";
    }
    
    if(responseString) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:responseTitle message:responseString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSString *responseString;
    NSString *responseTitle;
    _reponse = @{@"Status":@"NOK",@"Response":@"Eroare de conexiune cu serverul"};
    
    
    
    responseString = @"S-a produs o eroare în incercarea de a trimite programarea. Verificați accesul la internet al dispozitivului și incercați din nou";
    responseTitle = @"Alerta";
    
    [self removeLoadingWheel];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:responseTitle message:responseString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(![alertView.title isEqualToString:@"Alerta"]) {
        _appDelegate.currentOrder = nil;
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private Object Methods

-(void)addLoadingWheel
{
    _activityContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.presentingViewController.view.frame.size.width, self.presentingViewController.view.frame.size.height)];
    _activityContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.25];
    _ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.presentingViewController.view.frame.size.width/2) - 40, (self.presentingViewController.view.frame.size.height/2) - 40, 80, 80)];
    _ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _ai.backgroundColor = [UIColor blackColor];
    [_ai layer].cornerRadius = 8.0;
    [_ai layer].masksToBounds = YES;
    [_activityContainer addSubview:_ai];
    
    self.backButton.enabled = NO;
    self.sendButton.enabled = NO;
    
    [_ai startAnimating];
    [self.view addSubview:_activityContainer];
    
}

-(void)removeLoadingWheel
{
    [_ai stopAnimating];
    [_ai removeFromSuperview];
    [_activityContainer removeFromSuperview];
    self.backButton.enabled = YES;
    self.sendButton.enabled = YES;
}

- (NSArray *)generateMenuItemsFromParentMenu:(NSString *)currentHierarchy
{
    NSArray *menu;
    if(!_currentHierarchy) {
        menu = [_fullMenu allKeys];
    } else {
        menu = [[_fullMenu valueForKeyPath:currentHierarchy] allKeys];
    }
    NSArray *sections = [currentHierarchy componentsSeparatedByString:@"."];
    self.title = _currentHierarchy ? sections[[sections count]-1] : _isNewOrder ? @"Servicii" : @"Listă de prețuri";
    //return menu;
    return [menu sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSString *)getValueForIndex:(int)index
{
    NSDictionary *subMenu;
    if(!_currentHierarchy) {
        subMenu = _fullMenu;
    } else {
        subMenu = [_fullMenu valueForKeyPath:_currentHierarchy];
    }
    id object = [subMenu objectForKey:[_currentMenu objectAtIndex:index]];
    if([object isKindOfClass:[NSDictionary class]]) {
        return nil;
    } else if([object isKindOfClass:[NSString class]]) {
        return object;
    }
    return [NSString stringWithFormat:@"%d",[object intValue]];
}

-(void)reloadTableView
{
    //_fullMenu = [Order generateServicesMenu];
    _currentHierarchy = nil;
    _currentMenu = [self generateMenuItemsFromParentMenu:_currentHierarchy];
    
    //[self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
}


@end
