import { Item } from "./item.model";

export class Receipt {
    items: Item[];
    numOfTable: number;
    dateParty: Date;
    total_price: number;
}