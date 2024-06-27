export interface Bill_item {
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
    _id: string;
    dishes: Bill_item[];
    table: number;
    date_party: string;
    count_customer: number;
    total: number;
    customer: string;
    create_at: string;
    confirm_status: number;
    confirm_at: string;
    confirm_by: string;
    confirm_note: string;
    currency: string;
    payment_status: number;
    payment_type: number;
    payment_at?: string;
    payment_by: string;
}