import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable()
export class StatisticalService {
    private apiMoneyStatistics = new BehaviorSubject<any>(null);
    private apiProductStatistics = new BehaviorSubject<any>(null);
    public money_statistics = this.apiMoneyStatistics.asObservable();
    public product_statistics = this.apiProductStatistics.asObservable();


    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    })
    constructor(
        private http: HttpClient,
    ) {
        this.get_moneyStatistics();
        this.get_productStatistics();
    }

    get_moneyStatistics() {
        this.http.get(api.moneyStatistics, { headers: this.headers, observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('money_statistics', JSON.stringify(res_data.body));
                this.apiMoneyStatistics.next(res_data.body);
            },
            err => {
                console.log("Error: " + err.status + " " + err.error.text);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }

    get_productStatistics() {
        this.http.get(api.productStatistics, { headers: this.headers, observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('product_statistics', JSON.stringify(res_data.body));
                this.apiProductStatistics.next(res_data.body);
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
}