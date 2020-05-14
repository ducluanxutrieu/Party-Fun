// interface RateData {
//     content: string;
//     createAt: string;
//     imageurl: string;
//     scorerate: string;
//     updateAt: string;
//     username: string;
//     _iddish: string;
// }
// export class Rate {
//     average: number;
//     lishRate: RateData[];
//     totalpeople: number;
// }
export class Rating {
    _id: string;
    id_dish: string;
    user_rate: string;
    score: number;
    comment: string;
    create_at: string;
    update_at: string;
}