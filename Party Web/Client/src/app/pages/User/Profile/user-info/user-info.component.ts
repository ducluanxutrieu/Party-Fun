import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-user-info',
  templateUrl: './user-info.component.html',
  styleUrls: ['./user-info.component.css']
})
export class UserInfoComponent implements OnInit {
  userInfo;
  avtUrl = "https://i.imgur.com/N6PJloU.png";
  constructor() { }

  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
    this.avtUrl = this.userInfo.imageurl;
  }

  ngOnInit() {
    this.getuserInfo();
  }

}
