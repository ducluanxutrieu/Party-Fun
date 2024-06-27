import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ToastrService } from 'ngx-toastr';

// Services
import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '../_models/response.model';

@Injectable()
export class PaymentService {

    headers = new HttpHeaders({
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization': localStorage.getItem('token')
    });
    constructor(
        private http: HttpClient,
        private toastr: ToastrService
    ) { }

    // Thanh toán đơn hàng
    pay_bill(bill_id: string) {
        let body;
        this.http.post<ApiResponse>(api.pay_bill + "/" + bill_id, body, { headers: this.headers }).subscribe(
            res => {
                this.toastr.success("Paid success!");
                window.location.reload();
            },
            err => {
                this.toastr.error("Error while paying bill!");
                console.log("Error: " + err.error.message);
            }
        );
        return false;
    }

    // Xác nhận đơn hàng
    confirm_bill(bill_id: string, note: string) {
        let body = `note=${note}`
        return this.http.post<ApiResponse>(api.bill_confirm + "/" + bill_id, body, { headers: this.headers });
    }

    // Hủy đơn hàng
    cancel_bill(bill_id: string, note: string) {
        let body = `note=${note}`
        return this.http.put<ApiResponse>(api.bill_cancel + "/" + bill_id, body, { headers: this.headers });
    }
    // // Xóa đơn hàng
    delete_bill(bill_id: string) {
        const option = {
            headers: this.headers,
            body: {
                _id: bill_id
            },
        };
        this.http.delete(api.bill_cancel, option).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                this.toastr.success("Delete bill success!");
                window.location.reload();
            },
            err => {
                this.toastr.error("Error delete bill");
                console.log("Error: " + err.error.message);
            }
        );
    }

    // Lấy danh sách tất cả hóa đơn
    get_bills_list(page: number) {
        return this.http.get<ApiResponse>(api.get_bills_list + "?page=" + page, { headers: this.headers });
    }

    // Lấy danh sách hóa đơn theo tên khách hàng
    get_bills_by_username(username: string) {
        return this.http.get<ApiResponse>(api.get_bills_list + "/" + username, { headers: this.headers });
    }

    // Tạo mã giảm giá
    create_discount(body: string) {
        return this.http.post<ApiResponse>(api.create_discount, body, { headers: this.headers });
    }

    // Lấy danh sách mã giảm giá
    get_discounts_list() {
        return this.http.get<ApiResponse>(api.get_discounts_list, { headers: this.headers });
    }
}
