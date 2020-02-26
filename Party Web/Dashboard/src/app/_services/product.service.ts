import { Injectable } from '@angular/core';
import { api } from '../_api/apiUrl';
import { Product } from '../_models/product.model'
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Item } from '../_models/item.model'
import { Observable, BehaviorSubject } from 'rxjs';

@Injectable()
export class ProductService {
    private ProductDataSubject = new BehaviorSubject<any>(null);
    public productList = this.ProductDataSubject.asObservable();
    products = [];
    cartItems: Item[] = [];

    constructor(
        private http: HttpClient
    ) {
        this.getDishList();
        // this.loadCartItems();
        this.productList.subscribe(data => this.products = data);
    }
    //Lấy danh sách sản phẩm
    getDishList() {
        this.http.get(api.getdishlist, { observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
                var response_body = JSON.parse(sessionStorage.getItem('response_body'));
                this.ProductDataSubject.next(response_body.lishDishs);
                localStorage.setItem('dish-list', JSON.stringify(response_body.lishDishs));
                //console.log(this.products);
            },
            err => {
                console.log("Lỗi: " + err.status + " " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        );
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