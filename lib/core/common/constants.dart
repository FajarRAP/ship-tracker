const loginRoute = "/login";
const registerRoute = "/register";
const trackerRoute = "/";
const barcodeScannerRoute = "/barcode-scanner";
const scanReceiptRoute = "${trackerRoute}scan";
const checkReceiptRoute = "${trackerRoute}check";
const packReceiptRoute = "${trackerRoute}pack";
const sendReceiptRoute = "${trackerRoute}send";
const returnReceiptRoute = "${trackerRoute}return";
const reportRoute = "${trackerRoute}report";
const profileRoute = "/profile";
const cameraRoute = "$trackerRoute/camera";
const displayPictureRoute = "/picture";

const scanStage = 2;
const checkStage = 3;
const packStage = 4;
const sendStage = 5;
const returnStage = 6;

const spreadsheetIcon = "assets/excel.png";
