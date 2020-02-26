import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../_services/user.service';
import { ProductService } from '../../../_services/product.service';
import { User } from '../../../_models/user.model';

declare var $: any;

@Component({
  selector: 'app-user-cart-info',
  templateUrl: './user-cart-info.component.html',
  styleUrls: ['./user-cart-info.component.css']
})
export class UserCartInfoComponent implements OnInit {
  userData: User;
  cartDetail = [];
  pageOfItems: Array<any>;
  constructor(
    private userService: UserService,
    public productService: ProductService
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
    }
  }
}
