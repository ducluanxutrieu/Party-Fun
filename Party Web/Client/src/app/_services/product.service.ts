import { Injectable } from '@angular/core';
import { api } from '../_api/apiUrl';
import { Product } from '../_models/product.model'
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Item } from '../_models/item.model'
import { Observable, BehaviorSubject } from 'rxjs';

declare var toastr;

@Injectable({ providedIn: 'root' })
export class ProductService {
    private productDataSubject = new BehaviorSubject<any>(null);
    public productList = this.productDataSubject.asObservable();
    products = [];
    cartItems: Item[] = [];

    constructor(
        private http: HttpClient
    ) {
        this.getDishList();
        this.loadCartItems();
        this.productList.subscribe(data => this.products = data);
        toastr.options = {
            "closeDuration": "300"
        }
    }
    //Lấy danh sách sản phẩm
    getDishList(): any {
        this.http.get(api.getdishlist, { observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
                var response_body = JSON.parse(sessionStorage.getItem('response_body'));
                this.products = response_body.lishDishs;
                this.productDataSubject.next(response_body.lishDishs);
                localStorage.setItem('dish_list', JSON.stringify(response_body.lishDishs));
                // console.log(this.products);
                return this.products;
            },
            err => {
                console.log("Error: " + err.status + " " + err.statusText);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        );
    }
    //Tìm tất cả sản phẩm
    findAll(): any[] {
        this.products = JSON.parse(localStorage.getItem('dish_list'));
        return this.products;
    }
    //Tìm sản phẩm qua id
    find(id: string): any {
        this.products = JSON.parse(localStorage.getItem('dish_list'));
        return this.products[this.getSelectedIndex(id)];
    }
    //Lấy index sản phẩm qua id
    private getSelectedIndex(id: string) {
        // console.log(this.products);
        for (var i = 0; i < this.products.length; i++) {
            if (this.products[i]._id == id) {
                return i;
            }
        }
        return -1;
    }
    //Thêm món vào giỏ hàng
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
            toastr.success("Added to cart!")
        }
        return false;
    };
    //xóa giỏ hàng
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
    //Thay đổi số lượng món
    changeItemQuantity(id: string, value) {
        for (var i = 0; i < this.cartItems.length; i++) {
            var item = this.cartItems[i];
            if (item.product._id === id) {
                item.quantity = value;
            }
        }
        this.saveCartItems();
    }
    //Lấy tổng số món trong giỏ hàng
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
    //Load giỏ hàng lúc khởi tạo
    private loadCartItems() {
        if (!!localStorage.getItem('cart'))
            this.cartItems = JSON.parse(localStorage.getItem('cart'));
    }
    //Lưu giỏ hàng
    saveCartItems() {
        if (localStorage != null && JSON != null) {
            localStorage['cart'] = JSON.stringify(this.cartItems);
        }
    };
}