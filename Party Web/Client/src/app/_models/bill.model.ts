interface Bill_item {
    _id: string;
    image: string;
    name: string;
    numberDish: number;
}

interface Bill_info {
    _id: string;
    username: string;
    createAt: string;
    dateParty: string;
    lishDishs: Bill_item[];
    numbertable: number;
    paymentAt?: string;
    paymentstatus: boolean;
    totalMoney: number;
    userpayment;
}

export class Bill {
    bill: Bill_info;
    message: string;
    success: boolean;
}