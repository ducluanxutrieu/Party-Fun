import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../../../_api/apiUrl';

@Component({
  selector: 'app-edit-profile',
  templateUrl: './edit-profile.component.html',
  styleUrls: ['./edit-profile.component.css']
})
export class EditProfileComponent implements OnInit {
  apiUrl = api.updateuser;
  userInfo;
  constructor(
    private http: HttpClient
  ) { }

  ngOnInit() {
    this.getuserInfo();
  }
  onClickSubmit(data: {
    fullname: string;
    gender: string;
    birthday: string;
    phonenumber: number;
    email: string
  }) {
    let body = `fullName=${data.fullname}&sex=${data.gender}&birthday=${data.birthday}&phoneNumber=${data.phonenumber}&email=${data.email}`;
    var token = localStorage.getItem('token');
    localStorage.setItem('editprofile', body);
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    })
    console.log(data.birthday);
    var result;
    return this.http.post(this.apiUrl, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      result = res_data.body;
      sessionStorage.setItem('response', JSON.stringify(res_data.body));
      localStorage.setItem('userinfo', JSON.stringify(result.account));
      alert("Cập nhật thành công!");
    },
      err => {
        alert("Lỗi: " + err.status);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
  }
}
