import { HttpClient } from '@angular/common/http';
import { api } from '../_api/apiUrl';

export class UserService {
    constructor(
        private http: HttpClient
    ) { }

}