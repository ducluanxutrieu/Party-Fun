import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders, JsonpInterceptor } from '@angular/common/http';
import { Router } from '@angular/router';

import { api } from '../../../_api/apiUrl'
@Component({
  selector: 'app-edit-password',
  templateUrl: './edit-password.component.html',
  styleUrls: ['./edit-password.component.css']
})
export class EditPasswordComponent implements OnInit {
  apiUrl = api.changepassword;

  constructor(
    private http: HttpClient,
    private router: Router
  ) { }

  onClickSubmit(data: {
    pwd: string;
    newpass: string;
  }) {
    var token = localStorage.getItem('token');
    let body = `password=${data.pwd}&passwordchange=${data.newpass}`;
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    })
    alert("password: " + data.pwd + "newpass: " + data.newpass);
    return this.http.post(this.apiUrl, body, { headers: headers, observe: 'response' }).subscribe(
      res_data => {
        alert("Thay đổi thành công!");
        sessionStorage.setItem('response', JSON.stringify(res_data));
        this.router.navigate(['profile']);
      },
      err => {
        alert("Lỗi: " + err.status);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  ngOnInit() {
  }

}
