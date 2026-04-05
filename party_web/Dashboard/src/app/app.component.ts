import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

// services
import { AuthenticationService } from './_services/authentication.service';

@Component({ standalone: false,
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  constructor(
    private router: Router,
    public authenticationService: AuthenticationService
  ) { }

  ngOnInit() { }

  logout() {
    this.authenticationService.logout();
  }

  // Sidebar Functionality
  sidebar_functionality() {
    $('#toggle-btn').on('click', function (e) {
      e.preventDefault();
      $(this).toggleClass("active");

      $('.side-navbar').toggleClass('shrinked');
      $('.content-inner').toggleClass('active');
      $(document).trigger('sidebarChanged');

      if (($(window).outerWidth() ?? 0) > 1183) {
        if ($('#toggle-btn').hasClass('active')) {
          $('.navbar-header .brand-small').hide();
          $('.navbar-header .brand-big').show();
        } else {
          $('.navbar-header .brand-small').show();
          $('.navbar-header .brand-big').hide();
        }
      }

      if (($(window).outerWidth() ?? 0) < 1183) {
        $('.navbar-header .brand-small').show();
      }
    });
  }
}