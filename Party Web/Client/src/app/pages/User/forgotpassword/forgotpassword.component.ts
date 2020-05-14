import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';

import { api } from '../../../_api/apiUrl';

declare var toastr;

@Component({
  selector: 'app-forgotpassword',
  templateUrl: './forgotpassword.component.html',
  styleUrls: ['./forgotpassword.component.css']
})
export class ForgotpasswordComponent implements OnInit {
  is_authorized = false; //Kiểm tra username có hợp lệ không
  username: string
  constructor(
    private http: HttpClient,
    private router: Router
  ) { }

  onClickSubmit(data: {
    username: string;
    otp_code: string;
    newpass: string;
  }) {
    let headers = new HttpHeaders({
      'Content-type': 'application/x-www-form-urlencoded',
    })
    //Ban đầu hoặc khi tên username không hợp lệ
    if (this.is_authorized == false) {
      this.http.get(api.reset_password + "?username=" + data.username, { headers: headers, observe: 'response' }).subscribe(
        res => {
          this.is_authorized = true;
          this.username = data.username;
        },
        err => {
          toastr.error("Error: " + err.status + " " + err.error.message);
          sessionStorage.setItem('error', JSON.stringify(err));
        })
    }
    //Nếu username hợp lệ chuyển sang form đổi mật khẩu
    if (this.is_authorized) {
      let body = `username=${this.username}&password=${data.newpass}&otp_code=${data.otp_code}`;
      console.log(body);
      this.http.put(api.confirm_otp, body, { headers: headers, observe: 'response' }).subscribe(
        res => {
          toastr.success("Change password success!");
          this.router.navigate(['/user_login']);
          this.is_authorized = false;
        },
        err => {
          toastr.error("Error: " + err.status + " " + err.error.message);
          sessionStorage.setItem('error', JSON.stringify(err));
        })
    }
  }
  ngOnInit() { }
}
