import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';

//services
import { AuthenticationService } from './_services/authentication.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  constructor(
    private router: Router,
    public authenticationService: AuthenticationService,
    private http: HttpClient
  ) { }

  ngOnInit() { }

  logout() {
    this.authenticationService.logout();
  }
}