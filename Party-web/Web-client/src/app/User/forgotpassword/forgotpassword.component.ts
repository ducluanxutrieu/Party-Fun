import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

import { api } from '../../_api/apiUrl';
@Component({
  selector: 'app-forgotpassword',
  templateUrl: './forgotpassword.component.html',
  styleUrls: ['./forgotpassword.component.css']
})
export class ForgotpasswordComponent implements OnInit {
  authorized = false;
  username;
  private apiUrl1 = api.resetpassword;
  private apiUrl2 = api.resetconfirm;
  constructor(
    private http: HttpClient,
    private router: Router
  ) { }
  onClickSubmit(data: { username: string; email: string; recoverycode: string; newpass: string }) {
    // var token=localStorage.getItem('token');
    let headers = new HttpHeaders({
      'Content-type': 'application/x-www-form-urlencoded'
    })
    if (this.authorized == false) {
      let body = `username=${data.username}`;
      this.username = data.username;
      this.http.post(this.apiUrl1, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
        this.authorized = true;
      },
        err => {
          alert("Lỗi: " + err.status);
          sessionStorage.setItem('error', JSON.stringify(err));
        })
      //       alert(body);
    }
    if (this.authorized) {
      let body = `username=${this.username}&passnew=${data.newpass}&checkforgotpassword=${data.recoverycode}`;
      this.http.post(this.apiUrl1, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
        alert("Đổi mật khẩu thành công!");
        this.router.navigate(['/user_login']);
        this.authorized = false;
      },
        err => {
          alert("Lỗi: " + err.status + " " + err.statusText + "\n" + err.error);
          sessionStorage.setItem('error', JSON.stringify(err));
        })
    }

  }
  ngOnInit() {
  }

}