interface CartItem {
    _id: string;
    image: string;
    name: string;
    numberDish: number;
}
export class Cart {
    createAt: string;
    dateParty: string;
    lishDishs: CartItem[];
    numbertable: number;
    paymentAt: string;
    paymentstatus: boolean;
    totalMoney: number;
    username: string;
    userpayment: string;
    _id: string;
}