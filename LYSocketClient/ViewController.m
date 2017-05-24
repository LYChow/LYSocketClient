//
//  ViewController.m
//  LYSocketClient
//
//  Created by hxf on 24/05/2017.
//  Copyright © 2017 sinowave. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *serverIpTextField;
@property (weak, nonatomic) IBOutlet UITextField *serverPortTextField;

@property (weak, nonatomic) IBOutlet UITextField *messageBoardTextField;


- (IBAction)connect:(id)sender;
- (IBAction)sendMsg:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *messageRecordBoard;

@property(nonatomic)GCDAsyncSocket *clientSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark -GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{

    self.messageRecordBoard.text = [NSString stringWithFormat:@"Ip:%@ Port:%i connect Success!\n",host,port];
    [self.clientSocket readDataWithTimeout:-1 tag:1];//(To not timeout, use a negative time interval.)
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

    NSString *receiveStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.messageRecordBoard.text = [self.messageRecordBoard.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n",receiveStr]];
    [self.clientSocket readDataWithTimeout:-1 tag:1];//(To not timeout, use a negative time interval.)
}


#pragma mark -Events
- (IBAction)connect:(id)sender
{
    [self.clientSocket disconnect];
    NSError *err;
    [self.clientSocket connectToHost:self.serverIpTextField.text onPort:self.serverPortTextField.text.integerValue error:&err];
    if (err) {
        self.messageRecordBoard.text = [self.messageRecordBoard.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n",err]];
    }
}

- (IBAction)sendMsg:(id)sender
{
    [self.clientSocket writeData:[self.messageBoardTextField.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
