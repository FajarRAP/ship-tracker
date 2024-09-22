const loginRoute = "/login";
const getTokenResetPasswordRoute = "/get-token-reset-password";
const resetPasswordRoute = "/reset-password";

const trackerRoute = "/";
const scanReceiptRoute = "${trackerRoute}scan";
const checkReceiptRoute = "${trackerRoute}check";
const packReceiptRoute = "${trackerRoute}pack";
const sendReceiptRoute = "${trackerRoute}send";
const returnReceiptRoute = "${trackerRoute}return";
const reportRoute = "${trackerRoute}report";
const detailReceiptRoute = "${trackerRoute}detail";
const cameraRoute = "${trackerRoute}camera";

const profileRoute = "/profile";
const registerRoute = "$profileRoute/register";

const barcodeScannerRoute = "/barcode-scanner";
const displayPictureRoute = "/picture";

const scanStage = 2;
const checkStage = 3;
const packStage = 4;
const sendStage = 5;
const returnStage = 6;

const spreadsheetIcon = "assets/excel.png";

const successSound = "sounds/success.mp3";
const skipSound = "sounds/skip.mp3";
const repeatSound = "sounds/repeat.mp3";
