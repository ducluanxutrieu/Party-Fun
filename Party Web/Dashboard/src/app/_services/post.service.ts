import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
// Services
import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '../_models/response.model';

@Injectable({
    providedIn: 'root',
})
export class PostService {
    constructor(
        private http: HttpClient,
    ) { }

    // Thêm bài viết
    add_post(body: string) {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        })
        return this.http.post<ApiResponse>(api.post, body, { headers: headers });
    }

    // Sửa bài viết
    edit_post(body: string) {
        let headers = new HttpHeaders({
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': localStorage.getItem('token')
        })
        return this.http.put<ApiResponse>(api.post, body, { headers: headers });
    }

    // Lấy 1 bài viết
    get_post(id: string) {
        return this.http.get<ApiResponse>(api.post + `/${id}`);
    }

    // Lấy danh sách bài viết
    get_posts_list(page: number) {
        return this.http.get<ApiResponse>(api.post + `?page=${page}`);
    }
}