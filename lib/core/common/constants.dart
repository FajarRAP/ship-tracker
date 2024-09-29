const loginRoute = "/login";
const getTokenResetPasswordRoute = "/get-token-reset-password";
const resetPasswordRoute = "/reset-password";

const trackerRoute = "/";
const scanReceiptRoute = "${trackerRoute}scan";
const pickUpReceiptRoute = "${trackerRoute}pick-up";
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
const pickUpStage = 3;
const checkStage = 4;
const packStage = 5;
const sendStage = 6;
const returnStage = 7;

const spreadsheetIcon = "assets/excel.png";

const successSound = "sounds/success.mp3";
const skipSound = "sounds/skip.mp3";
const repeatSound = "sounds/repeat.mp3";
