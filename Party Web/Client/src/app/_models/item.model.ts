import { Product } from '../_models/product.model'
export class Item {
    product: Product;
    quantity: number;
}
export class ReceiptItem {
    _id: string;
    name: string;
    price: number;
    currency: string;
    feature_image: string;
    count: number;
    discount: number;
    total_money: number;
}