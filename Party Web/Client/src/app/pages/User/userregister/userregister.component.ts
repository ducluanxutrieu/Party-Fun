import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { api } from '../../../_api/apiUrl';
import { AuthenticationService } from '../../../_services/authentication.service';

declare var toastr;
@Component({
  selector: 'app-userregister',
  templateUrl: './userregister.component.html',
  styleUrls: ['./userregister.component.css']
})
export class UserregisterComponent implements OnInit {
  private apiUrl = api.signup;
  constructor(
    private http: HttpClient,
    private router: Router,
    private authenticationService: AuthenticationService
  ) { }
  onClickSubmit(data: {
    name: string;
    email: string;
    phone: number;
    username: string;
    pwd: string;
  }) {
    let body = `fullName=${data.name}&username=${data.username}&email=${data.email}&phoneNumber=${data.phone}&password=${data.pwd}`;
    // console.log(body);
    var results;
    let headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded'
    })
    return this.http.post(this.apiUrl, body, { headers: headers, observe: 'response' }).subscribe(res_data => {
      results = res_data.body;
      toastr.success("Register success!");
      sessionStorage.setItem('full-response', JSON.stringify(res_data));
      this.router.navigate(['user_login']);
    },
      err => {
        toastr.error("Error: " + err.status + " " + err.error.message);
        localStorage.setItem('error', JSON.stringify(err));
      })
  }

  ngOnInit() {
  }

}
