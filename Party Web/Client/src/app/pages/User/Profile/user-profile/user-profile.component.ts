import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.css']
})
export class UserProfileComponent implements OnInit {
  userInfo;
  avtUrl = "https://i.imgur.com/N6PJloU.png";
  constructor() { }

  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
    this.avtUrl = localStorage.getItem('avatar');
  }

  ngOnInit() {
    this.getuserInfo();
  }

}
