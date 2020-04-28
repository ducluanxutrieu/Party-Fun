interface PaymentInfo {
    id: string,
    object: object,
    success_url: string,
    cancel_url: string,
    customer: string,
    customer_email: string,
    display_items: any[],
    payment_intent: string
}
export class Payment {
    message: string;
    data: PaymentInfo;
}