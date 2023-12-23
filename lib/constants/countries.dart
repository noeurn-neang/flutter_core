import 'package:get/get.dart';

var countries = [
  {"label": "Afghanistan", "code": "AF"},
  {"label": "Albania", "code": "AL"},
  {"label": "Algeria", "code": "DZ"},
  {"label": "AndorrA", "code": "AD"},
  {"label": "Angola", "code": "AO"},
  {"label": "Argentina", "code": "AR"},
  {"label": "Armenia", "code": "AM"},
  {"label": "Australia", "code": "AU"},
  {"label": "Austria", "code": "AT"},
  {"label": "Azerbaijan", "code": "AZ"},
  {"label": "Bahrain", "code": "BH"},
  {"label": "Bangladesh", "code": "BD"},
  {"label": "Belarus", "code": "BY"},
  {"label": "Belgium", "code": "BE"},
  {"label": "Bhutan", "code": "BT"},
  {"label": "Bolivia", "code": "BO"},
  {"label": "Botswana", "code": "BW"},
  {"label": "Brazil", "code": "BR"},
  {"label": "Bulgaria", "code": "BG"},
  {"label": "Cambodia", "code": "KH"},
  {"label": "Cameroon", "code": "CM"},
  {"label": "Canada", "code": "CA"},
  {"label": "Central African Republic", "code": "CF"},
  {"label": "Chad", "code": "TD"},
  {"label": "Chile", "code": "CL"},
  {"label": "China", "code": "CN"},
  {"label": "Colombia", "code": "CO"},
  {"label": "Congo", "code": "CG"},
  {"label": "Cook Islands", "code": "CK"},
  {"label": "Costa Rica", "code": "CR"},
  {"label": "Cote D\"Ivoire", "code": "CI"},
  {"label": "Croatia", "code": "HR"},
  {"label": "Cuba", "code": "CU"},
  {"label": "Cyprus", "code": "CY"},
  {"label": "Czech Republic", "code": "CZ"},
  {"label": "Denmark", "code": "DK"},
  {"label": "Djibouti", "code": "DJ"},
  {"label": "Dominica", "code": "DM"},
  {"label": "Dominican Republic", "code": "DO"},
  {"label": "Ecuador", "code": "EC"},
  {"label": "Egypt", "code": "EG"},
  {"label": "El Salvador", "code": "SV"},
  {"label": "Equatorial Guinea", "code": "GQ"},
  {"label": "Eritrea", "code": "ER"},
  {"label": "Estonia", "code": "EE"},
  {"label": "Ethiopia", "code": "ET"},
  {"label": "Falkland Islands (Malvinas)", "code": "FK"},
  {"label": "Faroe Islands", "code": "FO"},
  {"label": "Fiji", "code": "FJ"},
  {"label": "Finland", "code": "FI"},
  {"label": "France", "code": "FR"},
  {"label": "French Guiana", "code": "GF"},
  {"label": "French Polynesia", "code": "PF"},
  {"label": "French Southern Territories", "code": "TF"},
  {"label": "Gabon", "code": "GA"},
  {"label": "Gambia", "code": "GM"},
  {"label": "Georgia", "code": "GE"},
  {"label": "Germany", "code": "DE"},
  {"label": "Ghana", "code": "GH"},
  {"label": "Greece", "code": "GR"},
  {"label": "Guatemala", "code": "GT"},
  {"label": "Guinea", "code": "GN"},
  {"label": "Guinea-Bissau", "code": "GW"},
  {"label": "Guyana", "code": "GY"},
  {"label": "Holy See (Vatican City State)", "code": "VA"},
  {"label": "Honduras", "code": "HN"},
  {"label": "Hong Kong", "code": "HK"},
  {"label": "Hungary", "code": "HU"},
  {"label": "Iceland", "code": "IS"},
  {"label": "India", "code": "IN"},
  {"label": "Indonesia", "code": "ID"},
  {"label": "Iran, Islamic Republic Of", "code": "IR"},
  {"label": "Iraq", "code": "IQ"},
  {"label": "Ireland", "code": "IE"},
  {"label": "Israel", "code": "IL"},
  {"label": "Italy", "code": "IT"},
  {"label": "Jamaica", "code": "JM"},
  {"label": "Japan", "code": "JP"},
  {"label": "Jordan", "code": "JO"},
  {"label": "Kazakhstan", "code": "KZ"},
  {"label": "Kenya", "code": "KE"},
  {"label": "Kiribati", "code": "KI"},
  {"label": "Korea, Democratic People\"S Republic of", "code": "KP"},
  {"label": "Korea, Republic of", "code": "KR"},
  {"label": "Kuwait", "code": "KW"},
  {"label": "Kyrgyzstan", "code": "KG"},
  {"label": "Lao People\"S Democratic Republic", "code": "LA"},
  {"label": "Latvia", "code": "LV"},
  {"label": "Lebanon", "code": "LB"},
  {"label": "Lesotho", "code": "LS"},
  {"label": "Liberia", "code": "LR"},
  {"label": "Libyan Arab Jamahiriya", "code": "LY"},
  {"label": "Liechtenstein", "code": "LI"},
  {"label": "Lithuania", "code": "LT"},
  {"label": "Luxembourg", "code": "LU"},
  {"label": "Macao", "code": "MO"},
  {"label": "Macedonia, The Former Yugoslav Republic of", "code": "MK"},
  {"label": "Madagascar", "code": "MG"},
  {"label": "Malawi", "code": "MW"},
  {"label": "Malaysia", "code": "MY"},
  {"label": "Maldives", "code": "MV"},
  {"label": "Mali", "code": "ML"},
  {"label": "Malta", "code": "MT"},
  {"label": "Marshall Islands", "code": "MH"},
  {"label": "Martinique", "code": "MQ"},
  {"label": "Mauritania", "code": "MR"},
  {"label": "Mauritius", "code": "MU"},
  {"label": "Mayotte", "code": "YT"},
  {"label": "Mexico", "code": "MX"},
  {"label": "Micronesia, Federated States of", "code": "FM"},
  {"label": "Moldova, Republic of", "code": "MD"},
  {"label": "Monaco", "code": "MC"},
  {"label": "Mongolia", "code": "MN"},
  {"label": "Montserrat", "code": "MS"},
  {"label": "Morocco", "code": "MA"},
  {"label": "Mozambique", "code": "MZ"},
  {"label": "Myanmar", "code": "MM"},
  {"label": "Namibia", "code": "NA"},
  {"label": "Nauru", "code": "NR"},
  {"label": "Nepal", "code": "NP"},
  {"label": "Netherlands", "code": "NL"},
  {"label": "Netherlands Antilles", "code": "AN"},
  {"label": "New Caledonia", "code": "NC"},
  {"label": "New Zealand", "code": "NZ"},
  {"label": "Nicaragua", "code": "NI"},
  {"label": "Niger", "code": "NE"},
  {"label": "Nigeria", "code": "NG"},
  {"label": "Niue", "code": "NU"},
  {"label": "Norfolk Island", "code": "NF"},
  {"label": "Northern Mariana Islands", "code": "MP"},
  {"label": "Norway", "code": "NO"},
  {"label": "Oman", "code": "OM"},
  {"label": "Pakistan", "code": "PK"},
  {"label": "Palau", "code": "PW"},
  {"label": "Palestinian Territory, Occupied", "code": "PS"},
  {"label": "Panama", "code": "PA"},
  {"label": "Papua New Guinea", "code": "PG"},
  {"label": "Paraguay", "code": "PY"},
  {"label": "Peru", "code": "PE"},
  {"label": "Philippines", "code": "PH"},
  {"label": "Poland", "code": "PL"},
  {"label": "Portugal", "code": "PT"},
  {"label": "Qatar", "code": "QA"},
  {"label": "Romania", "code": "RO"},
  {"label": "Russian Federation", "code": "RU"},
  {"label": "RWANDA", "code": "RW"},
  {"label": "San Marino", "code": "SM"},
  {"label": "Saudi Arabia", "code": "SA"},
  {"label": "Senegal", "code": "SN"},
  {"label": "Singapore", "code": "SG"},
  {"label": "Slovakia", "code": "SK"},
  {"label": "Slovenia", "code": "SI"},
  {"label": "Somalia", "code": "SO"},
  {"label": "South Africa", "code": "ZA"},
  {"label": "Spain", "code": "ES"},
  {"label": "Sri Lanka", "code": "LK"},
  {"label": "Sudan", "code": "SD"},
  {"label": "Sweden", "code": "SE"},
  {"label": "Switzerland", "code": "CH"},
  {"label": "Taiwan, Province of China", "code": "TW"},
  {"label": "Thailand", "code": "TH"},
  {"label": "Timor-Leste", "code": "TL"},
  {"label": "Togo", "code": "TG"},
  {"label": "Tokelau", "code": "TK"},
  {"label": "Tonga", "code": "TO"},
  {"label": "Tunisia", "code": "TN"},
  {"label": "Turkey", "code": "TR"},
  {"label": "Tuvalu", "code": "TV"},
  {"label": "Uganda", "code": "UG"},
  {"label": "Ukraine", "code": "UA"},
  {"label": "United Arab Emirates", "code": "AE"},
  {"label": "United Kingdom", "code": "GB"},
  {"label": "United States", "code": "US"},
  {"label": "Uruguay", "code": "UY"},
  {"label": "Uzbekistan", "code": "UZ"},
  {"label": "Venezuela", "code": "VE"},
  {"label": "Viet Nam", "code": "VN"},
  {"label": "Wallis and Futuna", "code": "WF"},
  {"label": "Western Sahara", "code": "EH"},
  {"label": "Yemen", "code": "YE"},
  {"label": "Zimbabwe", "code": "ZW"},
];

getCountryByName(String name) {
  return countries.firstWhereOrNull(
      (element) => element['label']!.toLowerCase() == name.toLowerCase());
}
