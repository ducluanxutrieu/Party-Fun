import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../../../../_api/apiUrl';

declare var toastr;

@Component({
  selector: 'app-edit-password',
  templateUrl: './edit-password.component.html',
  styleUrls: ['./edit-password.component.css']
})
export class EditPasswordComponent implements OnInit {
  constructor(
    private http: HttpClient,
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
        toastr.success("Change success!");
        sessionStorage.setItem('response', JSON.stringify(res));
        toastr.success("Change password success!");
      },
      err => {
        toastr.error("Error: " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  ngOnInit() { }
}
