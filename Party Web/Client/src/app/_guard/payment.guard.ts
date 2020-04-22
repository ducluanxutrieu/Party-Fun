import { Injectable } from '@angular/core';
import { Router, CanActivate } from '@angular/router';

@Injectable()
export class PaymentGuard implements CanActivate {
    constructor(
        private router: Router,
    ) { }
    canActivate(): boolean {
        if (sessionStorage.getItem('current_receipt')) {
            return true;
        } else {
            this.router.navigate(['/mainpage']);
            return false;
        }
    }
}