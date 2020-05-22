import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
// Services
import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '../_models/response.model';

@Injectable()
export class PaymentService {

    headers = new HttpHeaders({
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization': localStorage.getItem('token')
    })
    constructor(
        private http: HttpClient,
    ) { }

    //Thanh toán đơn hàng
    pay_bill(bill_id: string) {
        let body;
        this.http.post<ApiResponse>(api.pay_bill + "/" + bill_id, body, { headers: this.headers }).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                alert("Paid success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
        return false;
    }

    //Xóa đơn hàng
    delete_bill(bill_id: string) {
        const option = {
            headers: this.headers,
            body: {
                _id: bill_id
            },
        }
        this.http.delete(api.delete_bill, option).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                alert("Delete bill success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.status + " - " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }

    // Lấy danh sách tất cả hóa đơn
    get_bills_list(page: number) {
        return this.http.get<ApiResponse>(api.get_bills_list + "?page=" + page, { headers: this.headers });
    }

    // Lấy danh sách hóa đơn theo tên khách hàng
    get_bills_by_username(username: string) {
        return this.http.get<ApiResponse>(api.get_bills_list + "/" + username, { headers: this.headers });
    }
}