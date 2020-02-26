import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable()
export class StatisticalService {
    private moneyStatisticSubject = new BehaviorSubject<any>(null);
    private productStatisticSubject = new BehaviorSubject<any>(null);
    private billStatisticSubject = new BehaviorSubject<any>(null);
    public money_statistics = this.moneyStatisticSubject.asObservable();
    public product_statistics = this.productStatisticSubject.asObservable();
    public bill_statistics = this.billStatisticSubject.asObservable();

    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    })
    constructor(
        private http: HttpClient,
    ) {
        this.get_moneyStatistics();
        this.get_productStatistics();
        this.get_billStatistics();
    }
    //Lấy số liệu thống kê doanh thu gần đây
    get_moneyStatistics() {
        this.http.get(api.moneyStatistics, { headers: this.headers, observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('money_statistics', JSON.stringify(res_data.body));
                this.moneyStatisticSubject.next(res_data.body);
            },
            err => {
                console.log("Error: " + err.status + " " + err.error.text);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }
    //Lấy số liệu thống kê sản phẩm trong ngày
    get_productStatistics() {
        this.http.get(api.productStatistics, { headers: this.headers, observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('product_statistics', JSON.stringify(res_data.body));
                this.productStatisticSubject.next(res_data.body);
            },
            err => {
                console.log("Error: " + err.status + " " + err.error.text);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }
    //Lấy số liệu thống kê đơn hàng
    get_billStatistics() {
        this.http.get(api.billStatistics, { headers: this.headers, observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('bill_statistics', JSON.stringify(res_data.body));
                this.billStatisticSubject.next(res_data.body);
            },
            err => {
                console.log("Error: " + err.status + " " + err.error.text);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }
    get_moneyData() {
        return JSON.parse(sessionStorage.getItem('money_statistics'));
    }
    get_productData() {
        return JSON.parse(sessionStorage.getItem('product_statistics'));
    }
    get_billData() {
        return JSON.parse(sessionStorage.getItem('bill_statistics'));
    }
}