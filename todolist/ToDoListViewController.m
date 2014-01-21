//
//  ToDoListViewController.m
//  todolist
//
//  Created by Gaurav Makhija on 1/20/14.
//  Copyright (c) 2014 Maps. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ToDoItemCell.h"
#import <objc/runtime.h>


@interface ToDoListViewController ()
@property (strong, nonatomic) NSMutableArray *toDoItemList;
- (void)onAddButtonClicked;
- (NSMutableArray*) fetchToDoItemListFromDataStore;
- (void) updateToDoItemListInDataStore;

@end

@implementation ToDoListViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"1");
    self = [super initWithStyle:style];
    NSLog(@"2");
    if (self) {
        self.title = @"To Do List";
        NSLog(@"3");
        // Custom initialization
    }
    return self;
}

- (void)onAddButtonClicked {
    NSLog(@"4");
    self.toDoItemList = [self fetchToDoItemListFromDataStore];
    [self.toDoItemList insertObject:@"" atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ToDoItemCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [newCell.editableText becomeFirstResponder];
    
    [self updateToDoItemListInDataStore];
    NSLog(@"5");
    [self.tableView reloadData];
    NSLog(@"6");
}
- (NSMutableArray*) fetchToDoItemListFromDataStore {
    NSLog(@"7");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedList = [defaults objectForKey:@"toDoItemList"];
    NSLog(@"8");
    return [[NSMutableArray alloc] initWithArray:savedList];
}


- (id) initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"9");
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.toDoItemList = [[NSMutableArray alloc] init];
        [self updateToDoItemListInDataStore];
    }
    NSLog(@"10");
    return self;
}

- (void) updateToDoItemListInDataStore {
    NSLog(@"11");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.toDoItemList forKey:@"toDoItemList"];
    [defaults synchronize];
    NSLog(@"12");
}



- (void)viewDidLoad
{
    NSLog(@"13");
    UINib *toDoCellNib = [UINib nibWithNibName:@"ToDoItemCell" bundle:nil];
    [self.tableView registerNib:toDoCellNib forCellReuseIdentifier:@"ToDoItemCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButtonClicked)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.toDoItemList = [self fetchToDoItemListFromDataStore];
    self.clearsSelectionOnViewWillAppear = NO;
    NSLog(@"14");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"15");
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    NSLog(@"16");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"17");
    self.toDoItemList = [self fetchToDoItemListFromDataStore];
    NSLog(@"18");
    return [self.toDoItemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"19");
    static NSString *CellIdentifier = @"ToDoItemCell";
    NSLog(@"19.1");
    ToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"19.2");
    NSString *toDoItem = [self.toDoItemList objectAtIndex:indexPath.row];
    NSLog(@"19.3");
    cell.editableText.text = toDoItem;
    NSLog(@"19.4");
    [cell.editableText setBorderStyle:UITextBorderStyleNone];
    NSLog(@"19.5");
    cell.shouldIndentWhileEditing = YES;
    NSLog(@"19.6");
    cell.editableText.delegate = self;
    NSLog(@"20");
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"21");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.toDoItemList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateToDoItemListInDataStore];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    NSLog(@"22");
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"23");
    NSObject *fromItem = [self.toDoItemList objectAtIndex:fromIndexPath.row];
    NSObject *toItem = [self.toDoItemList objectAtIndex:toIndexPath.row];
    
    [self.toDoItemList setObject:fromItem atIndexedSubscript:toIndexPath.row];
    [self.toDoItemList setObject:toItem atIndexedSubscript:fromIndexPath.row];
    [self updateToDoItemListInDataStore];
    NSLog(@"24");
}

- (void) onDoneWithAddingButtonClicked {
    NSLog(@"25");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButtonClicked)];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ToDoItemCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.editableText resignFirstResponder];
    [self.toDoItemList setObject:cell.editableText.text atIndexedSubscript:0];
    [self.tableView reloadData];
    [self updateToDoItemListInDataStore];
    NSLog(@"26");
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"27");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneWithAddingButtonClicked)];
    self.navigationItem.rightBarButtonItem.title = @"Done";
    NSLog(@"28");
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"29");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButtonClicked)];
    //    self.navigationItem.rightBarButtonItem.style = UIBarButtonSystemItemAdd;
    NSLog(@"30");
    return YES;
}



@end
