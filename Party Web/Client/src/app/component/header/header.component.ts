import { Component, OnInit } from '@angular/core';
//Service
import { AuthenticationService } from '../../_services/authentication.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
  userInfo;

  constructor(
    public authenticationService: AuthenticationService
  ) { }

  ngOnInit() {
    this.getuserInfo();
    // this.fbLibrary();
  }
  getuserInfo() {
    this.userInfo = JSON.parse(localStorage.getItem('userinfo'));
  }
  logout() {
    this.authenticationService.logout();
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
