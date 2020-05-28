import { Component, OnInit } from '@angular/core';
//Models
import { User } from '../../../../_models/user.model';
import { Bill } from '../../../../_models/bill.model';
//Services
import { UserService } from '../../../../_services/user.service';
import { ProductService } from '../../../../_services/product.service';
import { PaymentService } from '../../../../_services/payment.service';

declare var $: any;
declare var toastr;

@Component({
  selector: 'app-user-cart-info',
  templateUrl: './user-cart-info.component.html',
  styleUrls: ['./user-cart-info.component.css']
})
export class UserCartInfoComponent implements OnInit {
  total_pages: number;

  checkout_session_id: string;
  userData: User;
  cart_history: Bill[] = [];
  cartDetail = [];
  payment_status: boolean;

  constructor(
    private userService: UserService,
    public productService: ProductService,
    private paymentService: PaymentService
  ) { }

  ngOnInit() {
    // this.userService.userData.subscribe(data => this.userData = data);
    // this.userCart = this.userService.get_userCart();
    this.get_cartHistory(1);
  }

  // Lấy lịch sử đơn hàng
  get_cartHistory(page: number) {
    this.userService.get_cartHistory(page).subscribe(
      res => {
        this.cart_history = res.data.value as Bill[];
        this.total_pages = res.data.total_page;
      },
      err => {
        toastr.error("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }

  // Khi nhấn vào đơn hàng
  itemClicked(item: Bill) {
    if ($('#CartDetailModal').hasClass('show')) {
      $('#CartDetailModal').modal('hide');
    }
    else {
      this.cartDetail = item.dishes;
      if (item.payment_status == 0) {
        this.get_paymentInfo(item._id);
        this.payment_status = false;
      } else {
        this.payment_status = true;
      }
    }
  }

  // Thanh toán đơn hàng online
  pay() {
    this.paymentService.pay(this.checkout_session_id);
  }

  // Lấy session id từ Stripe
  get_paymentInfo(bill_id) {
    this.paymentService.get_paymentInfo(bill_id).subscribe(
      res_data => {
        this.checkout_session_id = res_data.data.id;
      },
      err => {
        toastr.error("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
}