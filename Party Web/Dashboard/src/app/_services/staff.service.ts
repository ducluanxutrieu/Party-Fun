import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ToastrService } from 'ngx-toastr';

// Services
import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '../_models/response.model';

@Injectable()
export class StaffService {

    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    });
    ////////////////////
    constructor(
        private http: HttpClient,
        private toastr: ToastrService
    ) { }

    // Lấy danh sách nhân viên
    get_staffsList(page: number) {
        return this.http.get<ApiResponse>(api.get_staffList + "?page=" + page, { headers: this.headers });
    }

    // Lấy danh sách khách hàng
    get_customersList(page: number) {
        return this.http.get<ApiResponse>(api.get_customerList + "?page=" + page, { headers: this.headers });
    }

    // Hạ cấp tài khoản nhân viên
    downgradeStaff(user_id: string) {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        });
        let body = `user_id=${user_id}`;
        console.log(body);
        this.http.put(api.downgrade_role, body, { headers: headers }).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                this.toastr.success("Downgrade user success!");
                window.location.reload();
            },
            err => {
                this.toastr.error("Error downrade user!");
                console.log("Error: " + err.error.message);
            }
        );
    }

    // Nâng cấp tài khoản khách hàng
    upgradeCustomer(user_id: string) {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        });
        let body = `user_id=${user_id}`;
        this.http.put(api.upgrade_role, body, { headers: headers }).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                this.toastr.success("Upgrade user success!");
                window.location.reload();
            },
            err => {
                this.toastr.error("Error upgrade user!");
                console.log("Error" + err.error.message);
            });
    }
}