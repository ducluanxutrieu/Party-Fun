import { Component, OnInit } from '@angular/core';

//Services
import { UserService } from '../../_services/user.service';
// Models
import { User } from '../../_models/user.model';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent implements OnInit {
  user_info: User;

  constructor(
    public userService: UserService,
  ) { }

  ngOnInit() {
    this.get_userInfo();
  }
  // Lấy thông tin user
  get_userInfo() {
    this.userService.get_userInfo().subscribe(
      res => {
        this.user_info = res.data as User;
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
}