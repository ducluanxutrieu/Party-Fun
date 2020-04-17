import { Item } from "./item.model";

export class Receipt {
    items: Item[];
    numofTable: number;
    dateParty: Date;
    total_price: number;
}