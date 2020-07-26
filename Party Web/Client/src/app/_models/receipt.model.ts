import { ReceiptItem } from "./item.model";

export class Receipt {
    dishes: ReceiptItem[];
    table: number;
    customer: string;
    count_customer: number;
    currency: string;
    date_party: Date;
    total: number;
    create_at: Date;
}