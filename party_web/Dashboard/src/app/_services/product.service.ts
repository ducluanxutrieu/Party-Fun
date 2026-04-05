import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
// Services
import { api } from '../_api/apiUrl';
// Models
import { Product } from '../_models/product.model';
import { Item } from '../_models/item.model';
import { ApiResponse } from '../_models/response.model';

@Injectable()
export class ProductService {
    products: any[] = [];

    constructor(
        private http: HttpClient
    ) { }

    // Lấy danh sách món ăn
    get_dishList() {
        return this.http.get<ApiResponse>(api.get_dishList);
    }

    // Lấy thông tin 1 sản phẩm
    get_dish(id: string) {
        return this.http.get<ApiResponse>(api.get_dish + "/" + id);
    }

    // Thêm món ăn mới
    add_dish(body: any) {
        const headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            Authorization: localStorage.getItem('token')
        });
        return this.http.post<ApiResponse>(api.add_dish, body, { headers });
    }

    // Cập nhật món ăn có sẵn
    update_dish(body: string) {
        const headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            Authorization: localStorage.getItem('token')
        });
        return this.http.put<ApiResponse>(api.update_dish, body, { headers });
    }

    // Xóa món ăn
    delete_dish(id: string) {
        const headers = new HttpHeaders({
            Authorization: localStorage.getItem('token')
        });
        const option = {
            headers: headers,
            body: {
                _id: id
            },
        };
        return this.http.delete<ApiResponse>(api.delete_dish, option);
    }
    // Tìm sản phẩm
    findAll(): any[] {
        this.products = JSON.parse(localStorage.getItem('dish-list') || '[]');
        return this.products;
    }

    // Tìm sản phẩm qua id
    find(id: string): any {
        this.products = JSON.parse(localStorage.getItem('dish-list') || '[]');
        return this.products[this.getSelectedIndex(id)];
    }

    // Tìm index sản phẩm thông qua id
    private getSelectedIndex(id: string) {
        // console.log(this.products);
        for (let i = 0; i < this.products.length; i++) {
            if (this.products[i]._id === id) {
                return i;
            }
        }
        return -1;
    }
}
