import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
// Services
import { AuthenticationService } from '../../../_services/authentication.service';
import { ToastrService } from 'ngx-toastr';
// Models
import { User } from '../../../_models/user.model';

@Component({
  selector: 'app-userlogin',
  templateUrl: './userlogin.component.html',
  styleUrls: ['./userlogin.component.css']
})
export class UserloginComponent implements OnInit {
  constructor(
    private router: Router,
    private authenticationService: AuthenticationService,
    private location: Location,
    private toastr: ToastrService
  ) { }
  onClickSubmit(data: { username: string; pwd: string; }) {
    return this.authenticationService.signin(data.username, data.pwd).subscribe(
      res => {
        let temp = res.body as any;
        let user_info = temp.data as User;
        sessionStorage.setItem('response', JSON.stringify(res.body));
        localStorage.setItem('token', user_info.token);
        localStorage.setItem('userinfo', JSON.stringify(user_info));
        localStorage.setItem('avatar', user_info.avatar);
        this.location.back();
      },
      err => {
        this.toastr.error("Error: " + err.status + " " + err.error.message);
        sessionStorage.setItem('error', JSON.stringify(err));
      });
  }

  // login() {
  //   window['FB'].login((response) => {
  //     console.log('login response', response);
  //     if (response.authResponse) {
  //       window['FB'].api('/me', {
  //         fields: 'last_name, first_name, email, name'
  //       }, (userInfo) => {

  //         console.log("user information");
  //         console.log(userInfo);
  //       });
  //     } else {
  //       console.log('User login failed');
  //     }
  //   }, { scope: 'email' });
  // }

  ngOnInit() {
    if (this.authenticationService.loggedIn()) {
      this.router.navigate(['/mainpage']);
    }
  }

}
