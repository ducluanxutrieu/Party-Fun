import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-edit-info',
  templateUrl: './edit-info.component.html',
  styleUrls: ['./edit-info.component.css']
})
export class EditInfoComponent implements OnInit {
  userInfo;
  constructor() { }

  ngOnInit() {
  }
  changeOfRoutes() {
    this.getuserInfo();
  }
  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
  }

}
