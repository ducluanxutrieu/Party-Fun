import { Cart } from './cart.model'
export class User {
    _id: string;
    email: string;
    phoneNumber: string;
    birthday: string;
    fullName: string;
    username: string;
    sex: string;
    role: string;
    imageurl: string;
    password: string;
    createAt: string;
    updateAt: string;
    userCart: Cart[];
}