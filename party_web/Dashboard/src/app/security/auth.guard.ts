import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';
import { AuthenticationService } from '../_services/authentication.service';

@Injectable()
export class AuthGuard implements CanActivate {
    constructor(
        private router: Router,
        private authenticationService: AuthenticationService
    ) { }
    canActivate(): boolean {
        if (this.authenticationService.is_loggedIn() && (this.authenticationService.is_admin || this.authenticationService.is_staff)) {
            // logged in so return true
            return true;
        } else {
            // not logged in so redirect to login page
            this.router.navigate(['/login']);
            return false;
        }
    }
}