interface RateData {
    content: string;
    createAt: string;
    imageurl: string;
    scorerate: string;
    updateAt: string;
    username: string;
    _iddish: string;
}
export class Rate {
    average: number;
    lishRate: RateData[];
    totalpeople: number;
}