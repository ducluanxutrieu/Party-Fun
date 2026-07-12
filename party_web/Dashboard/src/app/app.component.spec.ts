import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AppComponent } from './app.component';
import { AuthenticationService } from './_services/authentication.service';

describe('AppComponent', () => {
  let component: AppComponent;
  let fixture: ComponentFixture<AppComponent>;
  let authService: jasmine.SpyObj<AuthenticationService>;

  beforeEach(async () => {
    authService = jasmine.createSpyObj('AuthenticationService', ['is_loggedIn', 'logout']);
    authService.is_loggedIn.and.returnValue(false);

    await TestBed.configureTestingModule({
      imports: [RouterTestingModule],
      declarations: [AppComponent],
      providers: [{ provide: AuthenticationService, useValue: authService }]
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AppComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('calls authenticationService.logout on logout()', () => {
    component.logout();
    expect(authService.logout).toHaveBeenCalled();
  });
});
