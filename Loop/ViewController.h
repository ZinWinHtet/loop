//
//  ViewController.h
//  Loop
//
//  Created by uniqsoft on 26/7/13.
//  Copyright (c) 2013 uniqsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <NSXMLParserDelegate>


-(IBAction)dismissKeyborad:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtNRC;


//XML parsing works
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
-(void)parserDidEndDocument:(NSXMLParser *)parser;

@property(strong) NSMutableDictionary *xmlStudent;
@property(strong) NSMutableDictionary *currentDictionary;
@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;
@property(strong) NSMutableString *outstring;

@end
