import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';
import { Observable, BehaviorSubject } from 'rxjs';

@Injectable()
export class StaffService {
    private staffDataSubject = new BehaviorSubject<any>(null);
    private customerDataSubject = new BehaviorSubject<any>(null);
    public staffsList = this.staffDataSubject.asObservable();
    public customersList = this.customerDataSubject.asObservable();

    headers = new HttpHeaders({
        'Authorization': localStorage.getItem('token')
    })
    ////////////////////
    constructor(
        private http: HttpClient,
    ) {
        this.get_staffsList();
        this.get_customersList();
    }
    //Lấy danh sách nhân viên
    get_staffsList() {
        this.http.get(api.getStafflist, { headers: this.headers, observe: 'response' }).subscribe(res_data => {
            sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
            this.staffDataSubject.next(res_data.body);
        },
            err => {
                console.log("Error: " + err.status + " " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            })
        return null;
    }
    //Lấy danh sách khách hàng
    get_customersList() {
        this.http.get(api.getCustomerlist, { headers: this.headers, observe: 'response' }).subscribe(res_data => {
            sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
            this.customerDataSubject.next(res_data.body)
        },
            err => {
                console.log("Lỗi: " + err.status + " " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            })
        return null;
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