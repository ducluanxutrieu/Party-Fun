import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

import { api } from '../_api/apiUrl';

@Injectable({ providedIn: 'root' })
export class AuthenticationService {
    private apiLogin = api.signin;
    private apiLogout = api.signout;
    private apiUrl2 = "http://www.mocky.io/v2/5db5f3eb2f000058007fe766";
    constructor(
        private http: HttpClient,
        private router: Router
    ) { }

    login(username1: string, password1: string) {
        let body = `username=${username1}&password=${password1}`;
        //       alert(body);
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded'
        })
        var results;
        this.http.post(this.apiLogin, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
            results = res_data.body;
            if (results.account.role == "Admin" || results.account.role == "nhanvien") {
                sessionStorage.setItem('response_body', JSON.stringify(results));
                localStorage.setItem('token', results.account.token);
                localStorage.setItem('userinfo', JSON.stringify(results.account));
                localStorage.setItem('avatar', results.account.imageurl);
                this.router.navigate(['/dashboard']);
            }
            else alert("Must be staff or admin account!");
        },
            err => {
                alert("Error: " + err.status + " " + err.error.message);
                sessionStorage.setItem('error', JSON.stringify(err));
            });
    }
    logout() {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        })
        let body;
        this.http.post(this.apiLogout, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
            sessionStorage.setItem('response', JSON.stringify(res_data.body));
            localStorage.clear();
            sessionStorage.clear();
            this.router.navigate(['/login']);
        },
            err => {
                sessionStorage.setItem('error', JSON.stringify(err));
                alert("Không thể đăng xuất!");
            })
    }
    loggedIn() {
        return !!localStorage.getItem('token');
    }
    isAdmin() {
        if (this.loggedIn() == true) {
            var userinfo = localStorage.getItem('userinfo');
            var currentUser = JSON.parse(userinfo);
            if (currentUser.role == "Admin") return true;
        }
        return false;
    }
    isStaff() {
        if (this.loggedIn() == true) {
            var userinfo = localStorage.getItem('userinfo');
            var currentUser = JSON.parse(userinfo);
            if (currentUser.role == "nhanvien") return true;
        }
        return false;
    }
}