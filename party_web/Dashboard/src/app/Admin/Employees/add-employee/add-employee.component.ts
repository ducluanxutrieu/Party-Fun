import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../../../_api/apiUrl';
import { NgForm } from '@angular/forms';
@Component({ standalone: false,
  selector: 'app-add-employee',
  templateUrl: './add-employee.component.html',
  styleUrls: ['./add-employee.component.css']
})
export class AddEmployeeComponent implements OnInit {
  @ViewChild('userreg') thisForm!: NgForm;
  @ViewChild('addExisted') modalForm!: NgForm;
  existed_username: string;

  constructor(
    private http: HttpClient
  ) { }

  ngOnInit() {
  }
  onClickSubmit(data: {
    name: string;
    email: string;
    phone: number;
    username: string;
    pwd: string;
  }) {
    const body = `fullName=${data.name}&username=${data.username}&email=${data.email}&phoneNumber=${data.phone}&password=${data.pwd}`;
    console.log(body);
    const headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded'
    })
    this.http.post(api.signup, body, { headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        const headers2 = new HttpHeaders({
          'Content-Type': 'application/x-www-form-urlencoded',
          Authorization: localStorage.getItem('token')
        })
        const body2 = `userupgrade=${data.username}`
        this.http.post(api.upgrade_role, body2, { headers: headers2, observe: 'response' }).subscribe(
          res_data => {
            sessionStorage.setItem('response_body2', JSON.stringify(res_data.body));
            alert("Add Employee Success!");
            this.thisForm.reset();
          },
          err => {
            alert("Error: " + err.status + " - " + err.error.message);
            sessionStorage.setItem('error2', JSON.stringify(err));
          })
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }

  AddExistedUser(data: { username: string }) {
    const headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
      Authorization: localStorage.getItem('token')
    })
    const body = `userupgrade=${data.username}`;
    this.http.post(api.upgrade_role, body, { headers, observe: 'response' }).subscribe(
      res_data => {
        sessionStorage.setItem('response_body', JSON.stringify(res_data.body));
        alert("Add Employee Success!");
        this.modalForm.reset();
      },
      err => {
        alert("Error: " + err.status + " - " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      })
  }
}
