import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { api } from '../_api/apiUrl';
//Models
import { ApiResponse } from '../_models/response.model';
@Injectable({ providedIn: 'root' })
export class UserService {
    constructor(
        private http: HttpClient,
    ) { }

    // Lấy thông tin user
    get_userInfo() {
        let headers = new HttpHeaders({
            'Authorization': localStorage.getItem('token'),
        })
        return this.http.get<ApiResponse>(api.profile, { headers: headers });
    }
    // Lấy thông tin lịch sử đơn hàng
    get_cartHistory(page: number) {
        let headers = new HttpHeaders({
            'Authorization': localStorage.getItem('token'),
        })
        return this.http.get<ApiResponse>(api.cart_history + "?page=" + page, { headers: headers });
    }
}