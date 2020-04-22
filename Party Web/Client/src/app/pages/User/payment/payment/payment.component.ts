import { Component, OnInit, ViewChild } from '@angular/core';

import { FormGroup, FormBuilder, Validators } from "@angular/forms";
import { StripeService, Elements, Element as StripeElement, ElementsOptions } from "ngx-stripe";

declare var toastr;

@Component({
  selector: 'app-payment',
  templateUrl: './payment.component.html',
  styleUrls: ['./payment.component.css']
})
export class PaymentComponent implements OnInit {
  errorText: string;
  error: boolean = false;

  elements: Elements;
  // card: StripeElement;

  cardNumber: StripeElement;
  cardExpiry: StripeElement;
  cardCvc: StripeElement;

  // optional parameters
  elementsOptions: ElementsOptions = {
    locale: 'en'
  };

  stripeTest: FormGroup;

  elementStyles = {
    base: {
      iconColor: '#c4f0ff',
      fontWeight: 500,
      fontFamily: 'Roboto, Open Sans, Segoe UI, sans-serif',
      fontSize: '16px',
      fontSmoothing: 'antialiased',

      ':-webkit-autofill': {
        color: '#fce883',
      },
      '::placeholder': {
        color: '#b5b5b5',
      },
    },
    invalid: {
      iconColor: '#FFC7EE',
      color: 'red',
    },
  };

  constructor(
    private fb: FormBuilder,
    private stripeService: StripeService
  ) { }

  ngOnInit() {
    this.initialize_stripe();
  }

  initialize_stripe() {
    this.stripeTest = this.fb.group({
      name: ['', [Validators.required]]
    });
    this.stripeService.elements(this.elementsOptions)
      .subscribe(elements => {
        this.elements = elements;
        // Only mount the element the first time
        if (!this.cardNumber) {
          this.cardNumber = this.elements.create('cardNumber', {
            style: this.elementStyles
          });
          this.cardNumber.mount('#card-number');
        }
        if (!this.cardExpiry) {
          this.cardExpiry = this.elements.create('cardExpiry', {
            style: this.elementStyles
          });
          this.cardExpiry.mount('#card-expiry');
        }
        if (!this.cardCvc) {
          this.cardCvc = this.elements.create('cardCvc', {
            style: this.elementStyles
          });
          this.cardCvc.mount('#card-cvc');
        }
      });
  }

  buy() {
    const name = this.stripeTest.get('name').value;
    this.stripeService
      .createToken(this.cardNumber, null)
      .subscribe(result => {
        if (result.token) {
          // Use the token to create a charge or a customer
          // https://stripe.com/docs/charges
          console.log(result.token);
          toastr.success("Payment success!");
        } else if (result.error) {
          // Error creating the token
          console.log(result.error.message);
          this.errorText = result.error.message;
        }
      });
  }
}
