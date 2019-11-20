import { Injectable } from '@angular/core';
import { api } from '../_api/apiUrl';
import { Product } from '../_models/product.model'
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Item } from '../_models/item.model'
import { Observable } from 'rxjs';

@Injectable()
export class ProductService {
    products = [];
    cartItems: Item[] = [];

    constructor(
        private http: HttpClient
    ) {
        this.getDishList();
        this.loadCartItems();
    }

    getDishList(): any {
        this.http.get(api.getdishlist, { observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
                var response_body = JSON.parse(sessionStorage.getItem('response_body'));
                this.products = response_body.lishDishs;
                localStorage.setItem('dish-list', JSON.stringify(response_body.lishDishs));
                // console.log(this.products);
                return this.products;
            },
            err => {
                console.log("Lỗi: " + err.status + " " + err.statusText);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        );
    }

    findAll(): any[] {
        return this.products;
    }

    find(id: string): any {
        //Sử dụng local storage do lúc hàm này được gọi thì hàm getDishlist ở constructor vẫn chưa lấy xong
        this.products = JSON.parse(localStorage.getItem('dish-list'));
        return this.products[this.getSelectedIndex(id)];
    }

    private getSelectedIndex(id: string) {
        // console.log(this.products);
        for (var i = 0; i < this.products.length; i++) {
            if (this.products[i]._id == id) {
                return i;
            }
        }
        return -1;
    }

    addCartItem(id: string, quantity: number) {
        let product = this.find(id);
        if (quantity != 0) {

            // update quantity for existing item
            var found = false;
            for (var i = 0; i < this.cartItems.length && !found; i++) {
                var item = this.cartItems[i];
                if (item.product._id === product._id) {
                    found = true;
                    item.quantity = item.quantity + quantity;
                }
            }
            // add new item
            if (!found) {
                this.cartItems.push({
                    product,
                    quantity: quantity
                });
            }
            this.saveCartItems();
            alert("Đã thêm vào giỏ hàng!")
        }
        return false;
    };

    clearCartItem(id) {
        if (id) {
            for (var i = 0; i < this.cartItems.length; i++) {
                var item = this.cartItems[i];
                if (item.product._id === id) {
                    this.cartItems.splice(i, 1);
                }
            }
        } else {
            this.cartItems = [];
        }
        this.saveCartItems();
    }

    changeItemQuantity(id: string, value) {
        for (var i = 0; i < this.cartItems.length; i++) {
            var item = this.cartItems[i];
            if (item.product._id === id) {
                item.quantity = value;
            }
        }
        this.saveCartItems();
    }

    getTotalCount(id) {
        var count = 0;
        for (var i = 0; i < this.cartItems.length; i++) {
            var item = this.cartItems[i];
            if (id == null || item.product._id == id) {
                count += item.quantity;
            }
        }
        return count;
    }

    private loadCartItems() {
        if (!!localStorage.getItem('cart'))
            this.cartItems = JSON.parse(localStorage.getItem('cart'));
    }

    saveCartItems() {
        if (localStorage != null && JSON != null) {
            localStorage['cart'] = JSON.stringify(this.cartItems);
        }
    };
}