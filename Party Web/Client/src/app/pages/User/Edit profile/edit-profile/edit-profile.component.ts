import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { DatePipe } from '@angular/common';

import { api } from '../../../../_api/apiUrl';
//Models
import { User } from '../../../../_models/user.model';
import { Response } from '../../../../_models/response.model';

declare var toastr;

@Component({
  selector: 'app-edit-profile',
  templateUrl: './edit-profile.component.html',
  styleUrls: ['./edit-profile.component.css']
})
export class EditProfileComponent implements OnInit {
  private birthday;
  userInfo: User;
  constructor(
    private http: HttpClient,
    public datepipe: DatePipe,
  ) { }

  ngOnInit() {
    this.getuserInfo();
  }
  onClickSubmit(data: {
    fullname: string;
    gender: string;
    birthday: string;
    phonenumber: number;
    email: string;
  }) {
    this.birthday = this.datepipe.transform(this.birthday, 'MM/dd/yyyy');
    let body = `full_name=${data.fullname}&sex=${data.gender}&birthday=${this.birthday}&phone=${data.phonenumber}&email=${data.email}`;
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': localStorage.getItem('token'),
    })
    return this.http.put<Response>(api.update_user, body, { headers: headers }).subscribe(
      res => {
        sessionStorage.setItem('response', JSON.stringify(res));
        localStorage.setItem('userinfo', JSON.stringify(res.data));
        toastr.success("Update success!");
      },
      err => {
        toastr.error("Error: " + " " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo')) as User;
    this.birthday = this.datepipe.transform(this.userInfo.birthday, 'yyyy/MM/dd');
  }
  changeOfDate(event: any) {
    this.birthday = event.target.value;
    this.birthday = this.datepipe.transform(this.birthday, 'MM/dd/yyyy');
  }
}