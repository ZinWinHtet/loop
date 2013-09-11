//
//  ViewController.m
//  Loop
//
//  Created by uniqsoft on 26/7/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    NSDictionary *student;
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    UIButton *btn = [[UIButton alloc] init];
//    btn setImage:<#(UIImage *)#> forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setTxtMobile:nil];
    [self setTxtNRC:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)dismissKeyborad:(id)sender
{
    [self resignFirstResponder];
}

-(void)postLogin{
    
    NSString *deviceID = [[UIDevice currentDevice] identifierForVendor]; // will be used later
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"]; // will be used later

    NSString *baseURLString = @"http://54.251.183.106/loop/webservice/";
   
    int loginCode = (arc4random() % 99999) + 10000;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",loginCode] forKey:@"loginCode"];
    
//    NSString *loginURL = [NSString stringWithFormat:@"%@login_student.php?s_mobile=%@&s_nrc=%@&s_login_code=%d&s_category=iPhone&device_unique_id=%@&push_reg_id=%@"
//                          ,baseURLString,
//                          [self.txtMobile.text stringByReplacingOccurrencesOfString:@" " withString:@""], // replaced the space
//                          [self.txtNRC.text stringByReplacingOccurrencesOfString:@" " withString:@""], loginCode, 
//                          @"90a661cba306e8d1",@"872f8941250bee1490f16f0728af9f840773d4b9ed5c4506a4c399938ced7aba"];
    
        NSString *loginURL = [NSString stringWithFormat:@"%@login_student.php?s_mobile=96781564&s_nrc=S9829718I&s_login_code=%d&s_login_status=1&s_category=iPhone&device_unique_id=%@&push_reg_id=%@"
                              ,baseURLString,loginCode,
                              @"e37db91c88dca87e5850921903cd2a7ac75b5390",@"872f8941250bee1490f16f0728af9f840773d4b9ed5c4506a4c399938ced7aba"];
    
    NSURL *url = [NSURL URLWithString:loginURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [AFXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFXMLRequestOperation *operation =
    [AFXMLRequestOperation XMLParserRequestOperationWithRequest: request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser)
    {
        self.xmlStudent = [NSMutableDictionary dictionary]; // all of method 1 2 3 4 are written just for that one line
        XMLParser.delegate = self;
        [XMLParser setShouldProcessNamespaces:YES];
        [XMLParser parse];
        
        //business logic
        
        NSDictionary *studentList = [self.xmlStudent valueForKey:@"student-list"];
        NSDictionary *studentInfo = [studentList valueForKey:@"student-info"];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser){
        NSLog(@"%@",error);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Login. This is failure" message:[NSString stringWithFormat:@"%@",error]
                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }];
    
    
    [operation start];
}


- (IBAction)loginAction:(id)sender {
    [self postLogin];
}


// following are implementation of parser methods
// method 1
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.previousElementName = self.elementName;
    if(qName){
        self.elementName = qName;
    }
    if([qName isEqualToString:@"status"]){
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    else if([qName isEqualToString:@"student_list"]){
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    self.outstring = [NSMutableString string];
}

// method 2
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.elementName){
        return;
    }
    
    [self.outstring appendFormat:@"%@", string];
}

// method 3
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    NSLog(@"cur dict: %@", self.currentDictionary);
    
    if([qName isEqualToString:@"status"] || [qName isEqualToString:@"student_info"]){                          // for tags who have no sub tags
        [self.xmlStudent setObject:[NSArray arrayWithObject:self.currentDictionary] forKey:qName];
        self.currentDictionary = nil;
    }
//    else if ([qName isEqualToString:@"status"]){              // for tags who have sub tags  , i think that's not actually needed for current php
//        // Initalise the list of weather items if it dosnt exist
//        NSMutableArray *array = [self.xmlStudent objectForKey:@"status"];
//        if(!array)
//            array = [NSMutableArray array];
//        
//        [array addObject:self.currentDictionary];
//        [self.xmlStudent setObject:array forKey:@"status"];
//        self.currentDictionary = nil;
//    }
    else { // i don't know why that is needed
        [self.currentDictionary setObject:self.outstring forKey:qName];
    }
    self.elementName = nil;
}

//method 4
-(void) parserDidEndDocument:(NSXMLParser *)parser {
    // following codes are just from ray's tutorial site , i think not needed for me
    NSArray *ar = [self.xmlStudent objectForKey:@"student_info"];
    student = [ar objectAtIndex:0];
    NSLog(@"name: %@", [student objectForKey:@"s_name"]);
    [self loginAccessWithMobile:[student objectForKey:@"s_mobile"] nrc:[student objectForKey:@"s_nrc"]];
}

- (void) loginAccessWithMobile:(NSString*) mobile nrc:(NSString*)nrc
{
//    if([[self.txtMobile.text stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqualToString:mobile] && [[self.txtNRC.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:nrc])
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:student forKey:@"student_info"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
//        appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"menuScreen"];
//        
//    } else {
//        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong NRIC or Phone"
//                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [errorMessage show];
//    }
    [[NSUserDefaults standardUserDefaults] setObject:student forKey:@"student_info"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"logIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"menuScreen"];
}

@end
