import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { UserloginComponent } from './userlogin.component';
import { AuthenticationService } from '../../_services/authentication.service';

describe('UserloginComponent', () => {
  let component: UserloginComponent;
  let fixture: ComponentFixture<UserloginComponent>;
  let authService: jasmine.SpyObj<AuthenticationService>;
  let router: Router;

  beforeEach(async () => {
    authService = jasmine.createSpyObj('AuthenticationService', ['is_loggedIn', 'login']);

    await TestBed.configureTestingModule({
      imports: [RouterTestingModule, FormsModule],
      declarations: [UserloginComponent],
      providers: [{ provide: AuthenticationService, useValue: authService }]
    }).compileComponents();

    router = TestBed.inject(Router);
    spyOn(router, 'navigate');
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UserloginComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    authService.is_loggedIn.and.returnValue(false);
    fixture.detectChanges();
    expect(component).toBeTruthy();
  });

  it('redirects to /dashboard if already logged in', () => {
    authService.is_loggedIn.and.returnValue(true);
    fixture.detectChanges();
    expect(router.navigate).toHaveBeenCalledWith(['/dashboard']);
  });

  it('does not redirect if not logged in', () => {
    authService.is_loggedIn.and.returnValue(false);
    fixture.detectChanges();
    expect(router.navigate).not.toHaveBeenCalled();
  });

  it('calls login with correct credentials on submit', () => {
    authService.is_loggedIn.and.returnValue(false);
    fixture.detectChanges();
    component.onClickSubmit({ username: 'admin', pwd: 'secret' });
    expect(authService.login).toHaveBeenCalledWith('admin', 'secret');
  });
});
