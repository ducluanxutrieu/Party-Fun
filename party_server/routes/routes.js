var {open_image}=require('./user/user.controllers');
var auth = require('./authorization')
var router = require('express').Router();
router.use('/user', require('./user/user.routes'));
router.use('/product', require('./product/product.routes'));
router.use('/payment',auth.isAuthenticated, require('./payment/payment.routes'));
router.post('/webhook', require('./payment/payment.controllers').payment_success);
router.get('/open_image', open_image);
module.exports=router;