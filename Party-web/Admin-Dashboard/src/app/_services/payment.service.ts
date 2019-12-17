import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';
import { Observable, BehaviorSubject } from 'rxjs';

@Injectable()
export class PaymentService {

    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    })
    constructor(
        private http: HttpClient,
    ) { }

    pay_bill(bill_id) {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        })
        let body = `_id=${bill_id}`;
        this.http.post(api.pay, body, { headers: headers }).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data));
                alert("Paid success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.status + " - " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
        return false;
    }
    delete_bill(bill_id) {
        // let body = `_id=${bill_id}`;
        // let headers = new HttpHeaders({
        //     'Content-type': 'application/x-www-form-urlencoded',
        //     'Authorization': localStorage.getItem('token')
        // })
        const option = {
            headers: this.headers,
            body: {
                _id: bill_id
            },
        }
        this.http.delete(api.delete_bill, option).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data));
                alert("Delete bill success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.status + " - " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }
}