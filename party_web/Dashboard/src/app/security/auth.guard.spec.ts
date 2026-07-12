import { TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { Router } from '@angular/router';
import { AuthGuard } from './auth.guard';
import { AuthenticationService } from '../_services/authentication.service';

describe('AuthGuard', () => {
  let guard: AuthGuard;
  let router: Router;
  let authService: jasmine.SpyObj<AuthenticationService>;

  beforeEach(() => {
    authService = jasmine.createSpyObj('AuthenticationService', ['is_loggedIn', 'is_admin', 'is_staff']);

    TestBed.configureTestingModule({
      imports: [RouterTestingModule],
      providers: [
        AuthGuard,
        { provide: AuthenticationService, useValue: authService }
      ]
    });
    guard = TestBed.inject(AuthGuard);
    router = TestBed.inject(Router);
    spyOn(router, 'navigate');
  });

  it('should be created', () => {
    expect(guard).toBeTruthy();
  });

  it('allows access for logged-in admin', () => {
    authService.is_loggedIn.and.returnValue(true);
    authService.is_admin.and.returnValue(true);
    authService.is_staff.and.returnValue(false);
    expect(guard.canActivate()).toBeTrue();
    expect(router.navigate).not.toHaveBeenCalled();
  });

  it('allows access for logged-in staff', () => {
    authService.is_loggedIn.and.returnValue(true);
    authService.is_admin.and.returnValue(false);
    authService.is_staff.and.returnValue(true);
    expect(guard.canActivate()).toBeTrue();
  });

  it('redirects to /login when not logged in', () => {
    authService.is_loggedIn.and.returnValue(false);
    authService.is_admin.and.returnValue(false);
    authService.is_staff.and.returnValue(false);
    expect(guard.canActivate()).toBeFalse();
    expect(router.navigate).toHaveBeenCalledWith(['/login']);
  });

  it('redirects to /login when logged in but not admin or staff', () => {
    authService.is_loggedIn.and.returnValue(true);
    authService.is_admin.and.returnValue(false);
    authService.is_staff.and.returnValue(false);
    expect(guard.canActivate()).toBeFalse();
    expect(router.navigate).toHaveBeenCalledWith(['/login']);
  });
});
