import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../_api/apiUrl';
//Models
import { Payment } from '../_models/payment.model';
import {Response} from '../_models/response.model';
//Services
import { StripeService } from './stripe.service';

@Injectable({ providedIn: 'root' })
export class PaymentService {
    headers = new HttpHeaders({
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization': localStorage.getItem('token')
    });

    constructor(
        private http: HttpClient,
        private stripeService: StripeService,
    ) { }

    pay(checkout_session_id: string) {
        this.stripeService.stripe.redirectToCheckout({
            sessionId: checkout_session_id
        }).then(function (result) {
            console.log(result.error.message);
        })
    }

    get_paymentInfo(bill_id: string) {
        const option = {
            headers: this.headers,
        }
        return this.http.get<Response>(api.get_payment + '?_id=' + bill_id, option);
    }
}