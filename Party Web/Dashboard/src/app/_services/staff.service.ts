import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
// Services
import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '../_models/response.model';

@Injectable()
export class StaffService {

    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    })
    ////////////////////
    constructor(
        private http: HttpClient,
    ) { }

    //Lấy danh sách nhân viên
    get_staffsList(page: number) {
        return this.http.get<ApiResponse>(api.get_staffList + "?page=" + page, { headers: this.headers })
    }

    //Lấy danh sách khách hàng
    get_customersList(page: number) {
        return this.http.get<ApiResponse>(api.get_customerList + "?page=" + page, { headers: this.headers })
    }

    //Hạ cấp tài khoản nhân viên
    downgradeStaff(user_id: string) {
        const option = {
            headers: this.headers,
            body: {
                userupgrade: user_id
            },
        }
        this.http.put(api.downgrade_role, option).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                alert("Downgrade user success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }

    //Hạ cấp tài khoản khách hàng
    upgradeCustomer(user_id: string) {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        })
        let body = `user_id=${user_id}`;
        this.http.put(api.upgrade_role, body, { headers: headers }).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                alert("Upgrade user success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            })
    }
}