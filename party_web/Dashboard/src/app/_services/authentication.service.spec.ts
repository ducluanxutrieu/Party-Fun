import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { ToastrModule, ToastrService } from 'ngx-toastr';
import { AuthenticationService } from './authentication.service';
import { api } from '../_api/apiUrl';

describe('AuthenticationService', () => {
  let service: AuthenticationService;
  let httpMock: HttpTestingController;
  let toastr: ToastrService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule, RouterTestingModule, ToastrModule.forRoot()],
      providers: [AuthenticationService]
    });
    service = TestBed.inject(AuthenticationService);
    httpMock = TestBed.inject(HttpTestingController);
    toastr = TestBed.inject(ToastrService);
    localStorage.clear();
  });

  afterEach(() => {
    httpMock.verify();
    localStorage.clear();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('is_loggedIn', () => {
    it('returns false when no token', () => {
      expect(service.is_loggedIn()).toBeFalse();
    });

    it('returns true when token exists', () => {
      localStorage.setItem('token', 'test-token');
      expect(service.is_loggedIn()).toBeTrue();
    });
  });

  describe('is_admin', () => {
    it('returns false when not logged in', () => {
      expect(service.is_admin()).toBeFalse();
    });

    it('returns true for role 3', () => {
      localStorage.setItem('token', 'test-token');
      localStorage.setItem('userinfo', JSON.stringify({ role: '3' }));
      expect(service.is_admin()).toBeTrue();
    });

    it('returns false for role 2', () => {
      localStorage.setItem('token', 'test-token');
      localStorage.setItem('userinfo', JSON.stringify({ role: '2' }));
      expect(service.is_admin()).toBeFalse();
    });
  });

  describe('is_staff', () => {
    it('returns false when not logged in', () => {
      expect(service.is_staff()).toBeFalse();
    });

    it('returns true for role 2', () => {
      localStorage.setItem('token', 'test-token');
      localStorage.setItem('userinfo', JSON.stringify({ role: '2' }));
      expect(service.is_staff()).toBeTrue();
    });

    it('returns false for role 3', () => {
      localStorage.setItem('token', 'test-token');
      localStorage.setItem('userinfo', JSON.stringify({ role: '3' }));
      expect(service.is_staff()).toBeFalse();
    });
  });

  describe('login', () => {
    it('stores token and navigates on successful admin login', () => {
      spyOn(toastr, 'error');
      service.login('admin', 'password');

      const req = httpMock.expectOne(api.signin);
      expect(req.request.method).toBe('POST');
      req.flush({ data: { role: '3', token: 'abc123', avatar: 'avatar.png' } });

      expect(localStorage.getItem('token')).toBe('abc123');
    });

    it('shows error toast when role is not staff or admin', () => {
      spyOn(toastr, 'error');
      service.login('user', 'password');

      const req = httpMock.expectOne(api.signin);
      req.flush({ data: { role: '1', token: 'abc123', avatar: '' } });

      expect(toastr.error).toHaveBeenCalledWith('Must be staff or admin account!');
    });

    it('shows error toast on HTTP error', () => {
      spyOn(toastr, 'error');
      service.login('user', 'wrong');

      const req = httpMock.expectOne(api.signin);
      req.flush({ message: 'Invalid credentials' }, { status: 401, statusText: 'Unauthorized' });

      expect(toastr.error).toHaveBeenCalled();
    });
  });

  describe('logout', () => {
    it('clears localStorage on successful logout', () => {
      localStorage.setItem('token', 'test-token');
      service.logout();

      const req = httpMock.expectOne(api.signout);
      expect(req.request.method).toBe('GET');
      req.flush({});

      expect(localStorage.getItem('token')).toBeNull();
    });
  });
});
