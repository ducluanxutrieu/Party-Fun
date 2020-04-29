import { Component, OnInit } from '@angular/core';
//Models
import { User } from '../../../../_models/user.model';
//Services
import { UserService } from '../../../../_services/user.service';
import { ProductService } from '../../../../_services/product.service';
import { PaymentService } from '../../../../_services/payment.service';

declare var $: any;

@Component({
  selector: 'app-user-cart-info',
  templateUrl: './user-cart-info.component.html',
  styleUrls: ['./user-cart-info.component.css']
})
export class UserCartInfoComponent implements OnInit {
  checkout_session_id: string;
  userData: User;
  cartDetail = [];
  payment_status: boolean;
  pageOfItems: Array<any>;

  constructor(
    private userService: UserService,
    public productService: ProductService,
    private paymentService: PaymentService
  ) { }

  onChangePage(pageOfItems: Array<any>) {
    this.pageOfItems = pageOfItems;
  }

  ngOnInit() {
    this.userService.userData.subscribe(data => this.userData = data);
    // this.userCart = this.userService.get_userCart();
  }

  itemClicked(item: any) {
    if ($('#CartDetailModal').hasClass('show')) {
      $('#CartDetailModal').modal('hide');
    }
    else {
      this.cartDetail = item.lishDishs;
      if (item.paymentstatus == false) {
        this.get_paymentInfo(item._id);
        this.payment_status = item.paymentstatus;
      } else {
        this.payment_status = true;
      }
    }
  }

  pay() {
    this.paymentService.pay(this.checkout_session_id);
  }

  get_paymentInfo(bill_id) {
    this.paymentService.get_paymentInfo(bill_id).subscribe(
      res_data => {
        this.checkout_session_id = res_data.data.id;
      },
      err => {
        sessionStorage.setItem('error', JSON.stringify(err));
        alert('error');
      }
    )
  }
}
