export class Product {
    createAt;
    description: string;
    discount: string;
    image: string[];
    name: string;
    rate: {
        average: number,
        listRate: [],
        totalpeople: number
    }
    price: number;
    type: string;
    updateAt: Date;
    usercreate: string;
    _id: string;
}