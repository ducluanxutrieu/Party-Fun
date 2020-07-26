import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';

import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '..//_models/response.model';

@Injectable({ providedIn: 'root' })
export class AuthenticationService {
    constructor(
        private http: HttpClient,
        private router: Router,
        private toastr: ToastrService
    ) {}
    // Đăng nhập
    login(username: string, password: string) {
        const body = `username=${username}&password=${password}`;
        // alert(body);
        const headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded'
        });
        this.http.post<ApiResponse>(api.signin, body, { headers: headers }).subscribe(
            res => {
                if (res.data.role == "2" || res.data.role == "3") {
                    sessionStorage.setItem('response', JSON.stringify(res));
                    localStorage.setItem('token', res.data.token);
                    localStorage.setItem('userinfo', JSON.stringify(res.data));
                    localStorage.setItem('avatar', res.data.avatar);
                    this.router.navigate(['/dashboard']);
                } else {
                    this.toastr.error("Must be staff or admin account!");
                }
            },
            err => {
                this.toastr.error("Error: " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            });
    }
    // Đăng xuất
    logout() {
        const headers = new HttpHeaders({
            Authorization: localStorage.getItem('token')
        });
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
            });
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
