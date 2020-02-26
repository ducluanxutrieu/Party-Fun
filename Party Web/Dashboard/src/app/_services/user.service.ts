import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable()
export class UserService {
    private apiUserData = new BehaviorSubject<any>(null);
    public userData = this.apiUserData.asObservable();
    user_info;
    constructor(
        private http: HttpClient
    ) {
        this.get_userData();
        this.userData.subscribe(data => this.user_info = data);
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
                // sessionStorage.setItem('user-info', JSON.stringify(res_body.account));
                this.apiUserData.next(res_body.account);
            },
            err => {
                console.log("Error: " + err.status + " - " + err.statusText);
                sessionStorage.setItem('error', JSON.stringify(err));
            }
        )
    }
    //Trả vể user info
    get_userInfo(): any {
        return this.user_info;
    }
    get_userAvatar(): string {
        // this.userData.subscribe(data => this.user_info = data);
        // this.user_info = JSON.parse(sessionStorage.getItem('user-info'));
        return this.user_info.imageurl;
    }
}