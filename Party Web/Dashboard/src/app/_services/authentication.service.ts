import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '..//_models/response.model';

@Injectable({ providedIn: 'root' })
export class AuthenticationService {
    constructor(
        private http: HttpClient,
        private router: Router
    ) { }
    // Đăng nhập
    login(username: string, password: string) {
        let body = `username=${username}&password=${password}`;
        // alert(body);
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded'
        })
        this.http.post<ApiResponse>(api.signin, body, { headers: headers }).subscribe(
            res => {
                if (res.data.role == "2" || res.data.role == "3") {
                    sessionStorage.setItem('response', JSON.stringify(res));
                    localStorage.setItem('token', res.data.token);
                    localStorage.setItem('userinfo', JSON.stringify(res.data));
                    localStorage.setItem('avatar', res.data.avatar);
                    this.router.navigate(['/dashboard']);
                }
                else alert("Must be staff or admin account!");
            },
            err => {
                alert("Error: " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            });
    }
    // Đăng xuất
    logout() {
        let headers = new HttpHeaders({
            'Authorization': localStorage.getItem('token')
        })
        this.http.get(api.signout, { headers: headers }).subscribe(
            res => {
                sessionStorage.setItem('response', JSON.stringify(res));
                localStorage.clear();
                sessionStorage.clear();
                this.router.navigate(['/login']);
            },
            err => {
                sessionStorage.setItem('error', JSON.stringify(err));
                alert("Cannot logout!");
            })
    }
    // Kiểm tra có đăng nhập không
    is_loggedIn() {
        return !!localStorage.getItem('token');
    }
    // Kiểm tra tài khoản có phải admin không
    is_admin() {
        if (this.is_loggedIn() == true) {
            var currentUser = JSON.parse(localStorage.getItem('userinfo'));
            if (currentUser.role == "3") return true;
        }
        return false;
    }
    // Kiểm tra tài khoản có phải nhân viên không
    is_staff() {
        if (this.is_loggedIn() == true) {
            var currentUser = JSON.parse(localStorage.getItem('userinfo'));
            if (currentUser.role == "2") return true;
        }
        return false;
    }
}