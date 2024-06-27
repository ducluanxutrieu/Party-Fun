import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../../../../_api/apiUrl';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-edit-password',
  templateUrl: './edit-password.component.html',
  styleUrls: ['./edit-password.component.css']
})
export class EditPasswordComponent implements OnInit {
  constructor(
    private http: HttpClient,
    private toastr: ToastrService
  ) { }

  onClickSubmit(data: {
    pwd: string;
    newpass: string;
  }) {
    let body = `password=${data.pwd}&new_password=${data.newpass}`;
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': localStorage.getItem('token')
    })
    return this.http.put(api.change_password, body, { headers: headers }).subscribe(
      res => {
        this.toastr.success("Change success!");
        sessionStorage.setItem('response', JSON.stringify(res));
        this.toastr.success("Change password success!");
      },
      err => {
        this.toastr.error("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  ngOnInit() { }
}
