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

    // Lấy 1 bài viết
    get_post(id: string) {
        return this.http.get<ApiResponse>(api.post + `/${id}`);
    }

    // Lấy danh sách bài viết
    get_posts_list(page: number) {
        return this.http.get<ApiResponse>(api.post + `?page=${page}`);
    }

    // Lấy danh sách bài viết theo tên tác giả
    get_posts_list_byAuthor(author_name: string) {
        return this.http.get<ApiResponse>(api.post + `?author=${author_name}`);
    }
}