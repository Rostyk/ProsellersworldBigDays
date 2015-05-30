#import "InAppPurchaseObserver.h"

@implementation InAppPurchaseObserver

@synthesize delegate;
@synthesize product;

- (void)requestPurchaseWithProductIndentifier:(NSString *)identifier {
    
	if ([SKPaymentQueue canMakePayments]) {
        
		SKProductsRequest *productRequest= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: identifier]];
        
		productRequest.delegate = self;
		
        [productRequest start];
        
	} else {
        
	}
}

#pragma mark SKProductsRequest Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    product = nil;
    
	int count = [response.products count];
    
	if (count>0)
		self.product = [response.products objectAtIndex:0];

	if (!product) {
        
        if (delegate && [delegate respondsToSelector:@selector(didFinishPurchaseResult:error:)]) {
            [delegate didFinishPurchaseResult:NO error:[NSError errorWithDomain:@"NO PRODUCTS" code:0 userInfo:nil]];
        }
        
		return;
	}
    
	SKPayment *paymentRequest = [SKPayment paymentWithProduct:product];
    
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	[[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
	for(SKPaymentTransaction *transaction in transactions) {
        
		switch (transaction.transactionState) {
                
			case SKPaymentTransactionStatePurchasing:
				break;
				
			case SKPaymentTransactionStatePurchased: {
                
                if (delegate && [delegate respondsToSelector:@selector(didFinishPurchaseResult:error:)]) {
                    [delegate didFinishPurchaseResult:YES error:nil];
                }

				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
				break;
            }
                
			case SKPaymentTransactionStateRestored:
				// Verified that user has already paid for this item.

                if (delegate && [delegate respondsToSelector:@selector(didFinishPurchaseResult:error:)]) {
                    [delegate didFinishPurchaseResult:YES error:nil];
                }
                
				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
				
				if (transaction.error.code != SKErrorPaymentCancelled) {
					// A transaction error occurred, so notify user.
				}
                
                if (delegate && [delegate respondsToSelector:@selector(didFinishPurchaseResult:error:)]) {
                    [delegate didFinishPurchaseResult:NO error:[NSError errorWithDomain:@"Purchase Fail!" code:0 userInfo:nil]];
                }
                
				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
				break;
                
            default:

                break;
		}
	}
}

@end
