import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';

@Injectable()
export class StatisticalService {

    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    })
    constructor(
        private http: HttpClient,
    ) { }

    //Lấy số liệu thống kê doanh thu gần đây
    get_moneyStatistics() {
        return this.http.get(api.moneyStatistics, { headers: this.headers, observe: 'response' })
    }

    //Lấy số liệu thống kê sản phẩm trong ngày
    get_productStatistics() {
        return this.http.get(api.productStatistics, { headers: this.headers, observe: 'response' })
    }

    //Lấy số liệu thống kê đơn hàng
    get_recentBills() {
        return this.http.get(api.billStatistics, { headers: this.headers, observe: 'response' })
    }
}