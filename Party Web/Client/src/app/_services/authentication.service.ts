import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

import { api } from '../_api/apiUrl';

@Injectable({ providedIn: 'root' })
export class AuthenticationService {
    private apiLogin = api.signin;
    private apiLogout = api.signout;
    constructor(
        private http: HttpClient,
        private router: Router
    ) { }

    login(username: string, password: string) {
        let body = `username=${username}&password=${password}`;
        // alert(body);
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded'
        })
        var results;
        return this.http.post(this.apiLogin, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
            results = res_data.body;
            // alert("Login success!");
            //    sessionStorage.setItem('info',JSON.stringify(res_data));
            sessionStorage.setItem('response_body', JSON.stringify(results));
            localStorage.setItem('token', results.account.token);
            localStorage.setItem('userinfo', JSON.stringify(results.account));
            localStorage.setItem('avatar', results.account.imageurl);
            this.router.navigate(['/mainpage']);
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
            this.router.navigate(['/user_login']);
        },
            err => {
                sessionStorage.setItem('error', JSON.stringify(err));
                alert("Cannot logout!");
            })
    }

    loggedIn() {
        return !!localStorage.getItem('token');
    }
}