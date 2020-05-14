import { Component, OnInit } from '@angular/core';
// Models
import { User } from '../../../../_models/user.model';
// Services
import { UserService } from '../../../../_services/user.service';
@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.css']
})
export class UserProfileComponent implements OnInit {
  userInfo: User;
  constructor(
    private userService: UserService,
  ) {
  }

  get_userInfo() {
    // this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
    // this.avtUrl = localStorage.getItem('avatar');
    this.userService.get_userInfo().subscribe(
      res => {
        this.userInfo = res.data as User;
      },
      err => {
        console.log("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      }
    )
  }
  ngOnInit() {
    this.get_userInfo();
  }
}