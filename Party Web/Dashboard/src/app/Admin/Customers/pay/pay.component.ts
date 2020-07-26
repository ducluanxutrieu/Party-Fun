import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';

// Services
import { PaymentService } from '../../../_services/payment.service';
// Models
import { Bill, Bill_item } from '../../../_models/bill.model';

@Component({
  selector: 'app-pay',
  templateUrl: './pay.component.html',
  styleUrls: ['./pay.component.css']
})
export class PayComponent implements OnInit {
  bill_info: Bill[] = [];
  haveBill: boolean;
  bill_detail: Bill_item[] = [];

  constructor(
    public paymentService: PaymentService,
    private toastr: ToastrService
  ) { }

  ngOnInit() {
    this.onload();
  }
  onload() { }
  // Khi click vào đơn hàng trong danh sách
  itemClicked(item: Bill) {
    this.bill_detail = item.dishes;
  }

  // Tìm danh sách đơn hàng theo username nhập vào
  searchBill(data: {
    username: string
  }) {
    this.paymentService.get_bills_by_username(data.username).subscribe(
      res => {
        this.bill_info = res.data as Bill[];
        this.haveBill = true;
      },
      err => {
        this.toastr.error("Error while searching bills");
        console.log("Error: " + err.error.message);
        this.haveBill = false;
      }
    )
  }

  // Thanh toán đơn hàng
  pay(id: string) {
    if (confirm("Pay this bill?")) {
      this.paymentService.pay_bill(id);
    };
  }

  // Xóa đơn hàng
  delete_bill(bill_id: string) {
    if (confirm("Are you sure to delete this bill?")) {
      this.paymentService.delete_bill(bill_id);
      this.onload();
    };
  }
}