import { HttpClient, HttpHeaders } from '@angular/common/http';
import { api } from '../_api/apiUrl';
import { Injectable } from '@angular/core';

// Models
import { User } from '../_models/user.model';
import { ApiResponse } from '../_models/response.model';

@Injectable()
export class UserService {

    user_info: User;
    constructor(
        private http: HttpClient
    ) {
        // this.get_userData();
    }

    // Lấy thông tin user
    get_userInfo() {
        const headers = new HttpHeaders({
            Authorization: localStorage.getItem('token')
        });
        return this.http.get<ApiResponse>(api.get_profile, { headers });
    }
    // Cập nhật thông tin user
    update_userInfo(body: string) {
        const headers = new HttpHeaders({
            'Content-Type': 'application/x-www-form-urlencoded',
            Authorization: localStorage.getItem('token')
        });
        return this.http.put<ApiResponse>(api.update_user, body, { headers });
    }
}
