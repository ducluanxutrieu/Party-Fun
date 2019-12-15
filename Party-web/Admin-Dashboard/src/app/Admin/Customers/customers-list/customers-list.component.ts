import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../_services/user.service';
import { StaffService } from '../../../_services/staff.service';

declare var jquery: any;
declare var $: any;
interface Customer {
  user: any[]
}
@Component({
  selector: 'app-customers-list',
  templateUrl: './customers-list.component.html',
  styleUrls: ['./customers-list.component.css']
})
export class CustomersListComponent implements OnInit {
  // customersList = [];
  customersList: Customer;

  constructor(
    public userService: UserService,
    private staffService: StaffService
  ) { }

  upgrade(username: string) {
    if (confirm("Are you sure to upgrade this user? " + username)) {
      this.staffService.upgradeCustomer(username);
    };
  }

  ngOnInit() {
    this.staffService.customersList.subscribe(data => this.customersList = data);
  }

  // search(event) {
  //   var key = event.target.value;
  //   key.toLowerCase();
  //   $("#tableData tr").filter(function(){
  //     $(this).toggle($(this).text().toLowerCase().indexOf(key) > -1)
  //   });
  // }
}
