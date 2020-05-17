import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
// Services
import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '../_models/response.model';

@Injectable()
export class StatisticalService {

    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    })
    constructor(
        private http: HttpClient,
    ) { }

    // Thống kê tổng hóa đơn theo 7 ngày gần nhất
    get_moneyStatistics() {
        return this.http.get<ApiResponse>(api.moneyStatistics, { headers: this.headers })
    }

    // Thống kê món ăn được gọi trong 1 ngày
    get_productStatistics() {
        return this.http.get<ApiResponse>(api.productStatistics, { headers: this.headers })
    }

    // Lấy số liệu thống kê đơn hàng
    get_recentBills() {
        return this.http.get<ApiResponse>(api.billStatistics, { headers: this.headers })
    }
}