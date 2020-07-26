import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../_api/apiUrl';

interface signup_data {
    name: string;
    email: string;
    phone: number;
    username: string;
    pwd: string;
}
@Injectable({ providedIn: 'root' })
export class AuthenticationService {
    constructor(
        private http: HttpClient,
    ) { }
    // Đăng nhập
    signin(username: string, password: string) {
        let body = `username=${username}&password=${password}`;
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
        })
        return this.http.post(api.signin, body, { headers: headers, observe: 'response' });
    }

    // Đăng ký
    signup(data: signup_data) {
        let headers = new HttpHeaders({
            'Content-Type': 'application/x-www-form-urlencoded',
        });
        let body = `full_name=${data.name}&username=${data.username}&email=${data.email}&phone=${data.phone}&password=${data.pwd}`;
        return this.http.post(api.signup, body, { headers: headers, observe: 'response' });
    }

    // Đăng xuất
    logout() {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token'),
        })
        return this.http.get(api.signout, { headers: headers, observe: 'response' });
    }

    // Kiểm tra user có đăng nhập hay không
    loggedIn() {
        return !!localStorage.getItem('token');
    }
}