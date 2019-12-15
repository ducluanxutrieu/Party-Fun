import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthenticationService } from '../../_services/authentication.service';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';

@Component({
  selector: 'app-userlogin',
  templateUrl: './userlogin.component.html',
  styleUrls: ['./userlogin.component.css']
})
export class UserloginComponent implements OnInit {
  constructor(
    private http: HttpClient,
    private router: Router,
    private authenticationService: AuthenticationService
  ) { }
  onClickSubmit(data: { username: string; pwd: string; }) {
    alert("Username bạn vừa nhập vào là: " + data.username + "\nPassword bạn vừa nhập là: " + data.pwd);
    return this.authenticationService.login(data.username, data.pwd);
  }

  login() {
    window['FB'].login((response) => {
      console.log('login response', response);
      if (response.authResponse) {
        window['FB'].api('/me', {
          fields: 'last_name, first_name, email, name'
        }, (userInfo) => {

          console.log("user information");
          console.log(userInfo);
        });
      } else {
        console.log('User login failed');
      }
    }, { scope: 'email' });
  }

  ngOnInit() {
    if(this.authenticationService.loggedIn()){
      this.router.navigate(['/mainpage']);
    }
   }

}
