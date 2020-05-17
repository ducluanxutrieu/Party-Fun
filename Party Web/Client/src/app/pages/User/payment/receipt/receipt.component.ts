import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
//Models
import { Receipt } from '../../../../_models/receipt.model'
import { Item } from '../../../../_models/item.model';
//Services
import { PaymentService } from '../../../../_services/payment.service';

@Component({
  selector: 'app-receipt',
  templateUrl: './receipt.component.html',
  styleUrls: ['./receipt.component.css']
})
export class ReceiptComponent implements OnInit {
  receipt: Receipt;
  receipt_items: Item[] = [];

  bill_id: string;
  checkout_session_id: string;

  constructor(
    private paymentService: PaymentService,
    private activatedRoute: ActivatedRoute
  ) { }

  ngOnInit() {
    this.receipt = JSON.parse(sessionStorage.getItem('current_receipt'));
    this.receipt_items = this.receipt.items;
    this.activatedRoute.params.subscribe(params => {
      this.bill_id = params['bill_id'];
    })
    this.get_paymentInfo(this.bill_id);
  }

  pay() {
    this.paymentService.pay(this.checkout_session_id);
  }

  get_paymentInfo(bill_id: string) {
    this.paymentService.get_paymentInfo(bill_id).subscribe(
      res => {
        // let temp = res as PaymentInfo;
        this.checkout_session_id = res.data.id;
      },
      err => {
        sessionStorage.setItem('error', JSON.stringify(err));
        // alert('error');
      }
    )
  }
}