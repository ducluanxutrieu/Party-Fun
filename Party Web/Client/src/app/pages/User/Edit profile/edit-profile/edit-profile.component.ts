import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { DatePipe } from '@angular/common';

import { api } from '../../../../_api/apiUrl';
import { Router } from '@angular/router';

declare var toastr;

@Component({
  selector: 'app-edit-profile',
  templateUrl: './edit-profile.component.html',
  styleUrls: ['./edit-profile.component.css']
})
export class EditProfileComponent implements OnInit {
  private birthday;
  apiUrl = api.updateuser;
  userInfo;
  constructor(
    private http: HttpClient,
    public datepipe: DatePipe,
    private router: Router
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
    this.birthday = this.datepipe.transform(this.birthday, 'MM/dd/yyyy');
    let body = `fullName=${data.fullname}&sex=${data.gender}&birthday=${this.birthday}&phoneNumber=${data.phonenumber}&email=${data.email}`;
    var token = localStorage.getItem('token');
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    })
    // console.log(body);
    var result;
    return this.http.post(this.apiUrl, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      result = res_data.body;
      sessionStorage.setItem('response', JSON.stringify(res_data.body));
      localStorage.setItem('userinfo', JSON.stringify(result.account));
      toastr.success("Update success!");
      this.router.navigate(['/profile']);
      
    },
      err => {
        toastr.error("Error: " + err.status + " " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
    this.birthday = this.datepipe.transform(this.userInfo.birthday, 'yyyy/MM/dd');
  }
  changeOfDate(event: any) {
    this.birthday = event.target.value;
    this.birthday = this.datepipe.transform(this.birthday, 'MM/dd/yyyy');
  }
}
