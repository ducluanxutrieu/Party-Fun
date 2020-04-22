import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';

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
    get_staffsList() {
        return this.http.get(api.getStafflist, { headers: this.headers, observe: 'response' })
    }

    //Lấy danh sách khách hàng
    get_customersList() {
        return this.http.get(api.getCustomerlist, { headers: this.headers, observe: 'response' })
    }

    //Hạ cấp tài khoản nhân viên
    downgradeStaff(username: string) {
        const option = {
            headers: this.headers,
            body: {
                userupgrade: username
            },
        }
        this.http.delete(api.downgraderole, option).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data));
                alert("Downgrade user success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.status + " - " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }

    //Hạ cấp tài khoản khách hàng
    upgradeCustomer(username: string) {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        })
        let body = `userupgrade=${username}`;
        this.http.post(api.upgraderole, body, { headers: headers }).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data));
                alert("Upgrade user success!");
                window.location.reload();
            },
            err => {
                alert("Error: " + err.status + " - " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            })
    }
}