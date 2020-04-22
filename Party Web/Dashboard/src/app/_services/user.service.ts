import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';

@Injectable()
export class UserService {

    user_info;
    constructor(
        private http: HttpClient
    ) {
        this.get_userData();
    }

    //Lấy userData từ api
    get_userData() {
        let headers = new HttpHeaders({
            'Authorization': localStorage.getItem('token')
        })
        this.http.get(api.profile, { headers: headers, observe: 'response' }).subscribe(
            res_data => {
                sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
                var res_body = JSON.parse(sessionStorage.getItem('response_body'));
                this.user_info = res_body.account;
            },
            err => {
                console.log("Error: " + err.status + " - " + err.statusText);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }

    //Trả vể user info
    get_userInfo(): any {
        if (this.user_info) {
            return this.user_info;
        }
    }

    get_userAvatar(): string {
        if (this.user_info) {
            return this.user_info.imageurl;
        }
    }
}