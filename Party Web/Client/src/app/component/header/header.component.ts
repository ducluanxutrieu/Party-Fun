import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
//Service
import { AuthenticationService } from '../../_services/authentication.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
  userInfo;

  constructor(
    public authenticationService: AuthenticationService,
    private router: Router,
    private toastr: ToastrService
  ) { }

  ngOnInit() {
    this.get_userInfo();
    // this.fbLibrary();
  }
  //Get user info
  get_userInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
  }
  //Logout
  logout() {
    this.authenticationService.logout().subscribe(
      res_data => {
        localStorage.clear();
        sessionStorage.clear();
        sessionStorage.setItem('response', JSON.stringify(res_data.body));
        this.router.navigate(['/user_login']);
      },
      err => {
        sessionStorage.setItem('error', JSON.stringify(err));
        this.toastr.error("Cannot logout!");
      })
  }
  // fbLibrary() {
  //   (window as any).fbAsyncInit = function () {
  //     window['FB'].init({
  //       appId: '2356186141174309',
  //       cookie: true,
  //       xfbml: true,
  //       version: 'v3.1'
  //     });
  //     window['FB'].AppEvents.logPageView();
  //   };

  //   (function (d, s, id) {
  //     var js, fjs = d.getElementsByTagName(s)[0];
  //     if (d.getElementById(id)) { return; }
  //     js = d.createElement(s); js.id = id;
  //     js.src = "https://connect.facebook.net/en_US/sdk.js";
  //     fjs.parentNode.insertBefore(js, fjs);
  //   }(document, 'script', 'facebook-jssdk'));
  // }
}
