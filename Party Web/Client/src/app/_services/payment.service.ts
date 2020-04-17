import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

import { api } from '../_api/apiUrl';

@Injectable({ providedIn: 'root' })
export class PaymentService {


    constructor(
        private http: HttpClient,
        private router: Router
    ) { }
}