//
//  AnnouncementViewController.m
//  Loop
//
//  Created by uniqsoft on 31/8/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "AnnouncementInfo.h"
#import "AnnouncementDB.h"
#import "AnnouncementDetailViewController.h"


@interface AnnouncementViewController ()
{
    NSDictionary *announcement;
    NSArray *annoArray;
}
@end

@implementation AnnouncementViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //self.tableView.indexPathForSelectedRow.row
    if ([segue.identifier isEqualToString:@"anno detail segue"]) {
        AnnouncementDetailViewController *detailVC = segue.destinationViewController; // so detailVC will be destination View Controller
        
        NSArray *infoArray = [AnnouncementDB database].getAnnouncementInfos;
        AnnouncementInfo *info = [infoArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        detailVC.titleString = info.anno_title;
        detailVC.contentString = info.anno_content;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //announcement works
    NSString *baseURLString = @"http://54.251.183.106/loop/webservice/";
    NSDictionary *student = [[NSUserDefaults standardUserDefaults] objectForKey:@"student_info"];
    NSString *s_class = [student objectForKey:@"s_class"];
    NSLog(@"s_class is %@" , s_class);
    NSString *s_id = [student objectForKey:@"s_id"];
    NSString *loginCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCode"];
    NSString *getAnnouncement = [NSString stringWithFormat:@"%@announcement_list.php?s_class=%@&s_id=%@&s_login_code=%@", baseURLString, s_class, s_id, loginCode];
    
    NSURL *url = [NSURL URLWithString:getAnnouncement];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [AFXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/xml", @"text/html", nil]];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest: request
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser)
                                        {
                                            self.xmlAnnouncement = [NSMutableDictionary dictionary]; // all of method 1 2 3 4 are written just for that one line
                                            XMLParser.delegate = self;
                                            [XMLParser setShouldProcessNamespaces:YES];
                                            [XMLParser parse];
                                            
                                            //business logic
                                            //NSDictionary *announcementList = [self.xmlAnnouncement valueForKey:@"anno_list"];
                                            //NSLog(@"anno_title : %@",[announcementList objectForKey:@"anno_info"]);
                                            
                                                                                        
                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser){
                                            NSLog(@"%@",error);
                                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error." message:[NSString stringWithFormat:@"%@",error]
                                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [av show];
                                        }];
    [operation start];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)tableCellAction{
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = [appDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"announcementDetail"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return annoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *infoArray = [AnnouncementDB database].getAnnouncementInfos;
    AnnouncementInfo *info = [infoArray objectAtIndex:indexPath.row];
    NSString *string = info.anno_date;
    NSArray *trimmedArray = [string componentsSeparatedByString:@" "];

    cell.title.text = info.anno_title;
    cell.detail.text = info.anno_content;
    cell.date.text = [trimmedArray objectAtIndex:0];
    return cell;
}


// following are implementation of parser methods
// method 1
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.previousElementName = self.elementName;
    if(qName){
        self.elementName = qName;
    }
    
    if([qName isEqualToString:@"anno_info"]){
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
//    NSLog(@"cur dict: %@", self.currentDictionary);
    if([qName isEqualToString:@"anno_info"]){
        // Initalise the list of weather items if it donsn't exit
        NSMutableArray *array = [self.xmlAnnouncement objectForKey:@"anno_info"];
        if(!array)
            array = [NSMutableArray array];
        [array addObject:self.currentDictionary];
        [self.xmlAnnouncement setObject:array forKey:@"anno_info"];
        self.currentDictionary = nil ;
    }
    else{
        [self.currentDictionary setObject:self.outstring forKey:qName];
    }
    self.elementName = nil;
}

//method 4
-(void) parserDidEndDocument:(NSXMLParser *)parser {
    // following codes are just from ray's tutorial site , i think not needed for me
    
    annoArray= [self.xmlAnnouncement objectForKey:@"anno_info"];
    NSLog(@"anno obj: %@", annoArray);
    //announcement = [ar lastObject];
    for (NSDictionary *dct in annoArray) {
        NSLog(@"dct obj: %@", dct);
        AnnouncementDB *db = [[AnnouncementDB alloc] init];
        [db insertAnnouncement:dct];
    }
    [self.tableView reloadData];
}
// I wonder what will happen if without method 4
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
