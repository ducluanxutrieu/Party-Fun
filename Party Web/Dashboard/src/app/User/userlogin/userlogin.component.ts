import { Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { NgForm } from '@angular/forms';

//services
import { AuthenticationService } from '../../_services/authentication.service';

@Component({
  selector: 'app-userlogin',
  templateUrl: './userlogin.component.html',
  styleUrls: ['./userlogin.component.css']
})
export class UserloginComponent implements OnInit {
  @ViewChild('userlogin', null) thisForm: NgForm;
  constructor(
    private router: Router,
    private authenticationService: AuthenticationService
  ) { }

  onClickSubmit(data: { username: string; pwd: string; }) {
    this.authenticationService.login(data.username, data.pwd);
    // this.thisForm.reset();
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
    if (this.authenticationService.is_loggedIn()) {
      this.router.navigate(['/dashboard']);
    }
  }

}
