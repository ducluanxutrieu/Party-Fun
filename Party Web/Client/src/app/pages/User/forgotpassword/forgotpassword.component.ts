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
  authorized = false;
  username: string;
  constructor(
    private http: HttpClient,
    private router: Router
  ) { }
  onClickSubmit(data: { username: string; email: string; recoverycode: string; newpass: string }) {
    let headers = new HttpHeaders({
      'Content-type': 'application/x-www-form-urlencoded'
    })
    if (this.authorized == false) {
      let body = `username=${data.username}`;
      this.username = data.username;
      this.http.post(api.resetpassword, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
        this.authorized = true;
      },
        err => {
          toastr.error("Error: " + err.status + " " + err.error.message);
          sessionStorage.setItem('error', JSON.stringify(err));
        })
    }
    if (this.authorized) {
      let body = `username=${this.username}&passnew=${data.newpass}&checkforgotpassword=${data.recoverycode}`;
      this.http.post(api.resetpassword, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
        toastr.success("Change password success!");
        this.router.navigate(['/user_login']);
        this.authorized = false;
      },
        err => {
          toastr.error("Error: " + err.status + " " + err.error.message);
          sessionStorage.setItem('error', JSON.stringify(err));
        })
    }

  }
  ngOnInit() {
  }

}
