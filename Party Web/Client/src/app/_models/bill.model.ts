interface Bill_item {
    _id: string;
    feature_image: string;
    name: string;
    count: number;
    currency: string;
    discount: number;
    price: number;
    total_money: number;
}

export class Bill {
    create_at: string;
    count_customer: number;
    currency: string;
    customer: string;
    date_party: string;
    dishes: Bill_item[];
    table: number;
    total: number;
    payment_at?: string;
    payment_status: number;
    payment_type: number;
    _id: string;
}