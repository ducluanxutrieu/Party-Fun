var {open_image}=require('./user/user.controllers');
var router = require('express').Router();
router.use('/user', require('./user/user.routes'));
router.use('/product', require('./product/product.routes'));
router.get('/open_image', open_image);
module.exports=router;