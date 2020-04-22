import { Injectable } from '@angular/core';
import { api } from '../_api/apiUrl';
import { Product } from '../_models/product.model'
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Item } from '../_models/item.model'

@Injectable()
export class ProductService {
    products = [];
    cartItems: Item[] = [];

    constructor(
        private http: HttpClient
    ) { }
    //Lấy danh sách sản phẩm
    getDishList() {
        return this.http.get(api.getdishlist, { observe: 'response' })
    }

    //Tìm sản phẩm
    findAll(): any[] {
        this.products = JSON.parse(localStorage.getItem('dish-list'));
        return this.products;
    }

    //Tìm sản phẩm qua id
    find(id: string): any {
        //Sử dụng local storage do lúc hàm này được gọi thì hàm getDishlist ở constructor vẫn chưa lấy xong
        this.products = JSON.parse(localStorage.getItem('dish-list'));
        return this.products[this.getSelectedIndex(id)];
    }

    //Tìm index sản phẩm thông qua id
    private getSelectedIndex(id: string) {
        // console.log(this.products);
        for (var i = 0; i < this.products.length; i++) {
            if (this.products[i]._id == id) {
                return i;
            }
        }
        return -1;
    }
}