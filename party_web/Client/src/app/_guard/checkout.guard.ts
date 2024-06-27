import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';

@Injectable()
export class CheckoutGuard implements CanActivate {
    constructor(
        private router: Router,
    ) { }
    canActivate(): boolean {
        if (localStorage.getItem('cart')) {
            return true;
        } else {
            this.router.navigate(['/mainpage']);
            return false;
        }
    }
}