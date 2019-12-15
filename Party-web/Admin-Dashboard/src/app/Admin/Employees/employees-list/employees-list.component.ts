import { Component, OnInit } from '@angular/core';
import { UserService } from '../../../_services/user.service';
import { StaffService } from '../../../_services/staff.service';

interface Staff {
  user: any[]
}
@Component({
  selector: 'app-employees-list',
  templateUrl: './employees-list.component.html',
  styleUrls: ['./employees-list.component.css']
})
export class EmployeesListComponent implements OnInit {
  // staffsList = [];
  staffsList: Staff;
  constructor(
    public userService: UserService,
    private staffService: StaffService
  ) { }

  downgrade(username: string) {
    if (confirm("Are you sure to downgrade this user? " + username)) {
      this.staffService.downgradeStaff(username);
    };
  }

  ngOnInit() {
    this.staffService.staffsList.subscribe(data => this.staffsList = data);
  }

}
