import { Injectable } from '@angular/core';

declare var Stripe: any;

@Injectable({ providedIn: 'root' })

export class StripeService {
    stripe = Stripe('pk_test_28owFDjd02mGhWN5XUDoq1S700UciXGH9F');
}
