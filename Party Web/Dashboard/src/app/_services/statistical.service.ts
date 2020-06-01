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
    });
    constructor(
        private http: HttpClient,
    ) { }

    // Thống kê tổng hóa đơn theo 7 ngày gần nhất
    get_moneyStatistics() {
        return this.http.get<ApiResponse>(api.moneyStatistics, { headers: this.headers });
    }

    // Thống kê món ăn được gọi trong 1 ngày
    get_productStatistics(type: string) {
        return this.http.get<ApiResponse>(api.productStatistics + `?type=${type}`, { headers: this.headers });
    }

    // Thống kê tiền khách hàng thanh toán
    get_customerStatistics(type: string, payment_status: number) {
        return this.http.get<ApiResponse>(api.customerStatistics + `?type=${type}&payment_status=${payment_status}`, { headers: this.headers });
    }

    // Thống kê số tiền nhân viên đã thanh toán
    get_staffStatistics(type: string) {
        return this.http.get<ApiResponse>(api.staffStatistics + `?type=${type}`, { headers: this.headers });
    }
}
