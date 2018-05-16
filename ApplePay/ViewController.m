//
//  ViewController.m
//  ApplePay
//
//  Created by linan on 16/6/14.
//  Copyright © 2016年 linan. All rights reserved.
//

#import "ViewController.h"

#import <PassKit/PassKit.h>

#import <Framework/Person.h>


@interface ViewController () <PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /**
     *   update
     */
    Person *a = [Person new];
    [a sayHello];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(60, 100, 200, 50);
    btn.center = self.view.center;
    [btn setTitle:@"Apple Pay" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ApplePay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

#pragma mark ----支付状态
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    
    /**
     *  只需将payment.token.paymentData 发送至服务端, 服务端发送给银联进行相关操作
     */
    
    NSLog(@"Payment was authorized: %@", payment.token.paymentData);
    
    
    /**
     *  做相应的处理
     */
    BOOL asyncSuccessful = TRUE;
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"支付成功");
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        
        NSLog(@"支付失败");
        
        
    }
    
}


#pragma mark ----开始支付
- (void)ApplePay{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"支持支付");
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"单身Wang"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
        
        PKPaymentSummaryItem *widget4 = [PKPaymentSummaryItem summaryItemWithLabel:@"哆啦宝" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"] type:PKPaymentSummaryItemTypeFinal];
        
        request.paymentSummaryItems = @[widget1, widget4];
        
        request.countryCode = @"CN";
        request.currencyCode = @"CNY";//人民币
        //此属性限制支付卡，可以支付。PKPaymentNetworkChinaUnionPay支持中国的卡 9.2增加的
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.example.duolabao";
        /*
         PKMerchantCapabilityCredit NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 2,   // 支持信用卡
         PKMerchantCapabilityDebit  NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 3    // 支持借记卡
         */
        //必须加上  PKMerchantCapabilityEMV;
        request.merchantCapabilities = PKMerchantCapabilityDebit | PKMerchantCapabilityCredit | PKMerchantCapabilityEMV | PKMerchantCapability3DS;
        //增加邮箱及地址信息  (可选)
//        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        
        
        if (!paymentPane) {

            NSLog(@"出问题了");
            
        }
        
        [self presentViewController:paymentPane animated:YES completion:nil];
        
    } else {
        NSLog(@"该设备不支持支付");
    }
    
}


#pragma mark ----支付完成
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
