import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
//Service
import { StripeService } from '../../../../_services/stripe.service'

@Component({
  selector: 'app-payment-mobile',
  templateUrl: './payment-mobile.component.html',
  styleUrls: ['./payment-mobile.component.css']
})
export class PaymentMobileComponent implements OnInit {
  session_id: string;

  constructor(
    private activatedRoute: ActivatedRoute,
    private stripeService: StripeService
  ) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(
      params => {
        this.session_id = params['session_id'];
        this.redirect_to_checkout();
      })
  }

  redirect_to_checkout() {
    this.stripeService.stripe.redirectToCheckout({
      sessionId: this.session_id
    }).then(function (result) {
      alert(result.error.message);
    })
  }
}
