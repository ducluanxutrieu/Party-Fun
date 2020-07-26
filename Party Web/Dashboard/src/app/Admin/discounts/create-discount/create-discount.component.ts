import { Component, OnInit } from '@angular/core';
// Services
import { PaymentService } from '../../../_services/payment.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-create-discount',
  templateUrl: './create-discount.component.html',
  styleUrls: ['./create-discount.component.css']
})
export class CreateDiscountComponent implements OnInit {
  discountValue = 0;

  constructor(
    private paymentService: PaymentService,
    private toastr: ToastrService
  ) { }

  ngOnInit() {
  }

  // Tạo mã giảm giá
  create_discount(data: {
    code: string;
    expired: string;
    value: number;
  }) {
    let body = `code=${data.code}&expiresIn=${data.expired}&discount=${data.value}`;
    this.paymentService.create_discount(body).subscribe(
      res => {
        this.toastr.success("Create discount code success!");
      },
      err => {
        console.log("Error: " + err.error.message);
        this.toastr.error(`Error creating discount code!\n ${err.error.message}`);
      }
    )
  }

  // Kiểm tra giá trị discount
  check_discountValue() {
    if (this.discountValue > 100) {
      this.discountValue = 100;
    }
    else if (this.discountValue < 0) {
      this.discountValue = 0;
    }
  }
}
