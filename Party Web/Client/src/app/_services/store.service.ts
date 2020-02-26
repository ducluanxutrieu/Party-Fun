export class StoreService {
    private savedData = {};

    set(key: string, data) {
        this.savedData[key] = data;
        console.log(this.savedData[key]);
    }
    get(key: string) {
        console.log(this.savedData[key]);
        return this.savedData[key];
    }
}