import { Component, OnInit } from '@angular/core';

import { Receipt } from '../../../../_models/receipt.model'
import { Item } from '../../../../_models/item.model';

@Component({
  selector: 'app-receipt',
  templateUrl: './receipt.component.html',
  styleUrls: ['./receipt.component.css']
})
export class ReceiptComponent implements OnInit {
  receipt: Receipt;
  receipt_items: Item[] = [];

  constructor() { }

  ngOnInit() {
    this.receipt = JSON.parse(sessionStorage.getItem('current_receipt'));
    this.receipt_items = this.receipt.items;
  }

}