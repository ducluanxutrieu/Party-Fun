import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
// Services
import { api } from '../_api/apiUrl';
// Models
import { ApiResponse } from '../_models/response.model';

@Injectable({
    providedIn: 'root',
})
export class CommonService {

    constructor(
        private http: HttpClient,
    ) { }

    // Upload ảnh
    upload_image(images: any[]) {
        const headers = new HttpHeaders({
            Authorization: localStorage.getItem('token')
        });
        const body = new FormData();
        for (let i = 0; i < images.length; i++) {
            body.append('image', images[i]);
        }
        return this.http.post<ApiResponse>(api.upload_image, body, { headers: headers });
    }
}
