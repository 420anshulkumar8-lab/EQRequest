class RailwayOffice {
  final String designation;
  final String office;
  final String zone;
  final String searchKey;

  RailwayOffice({
    required this.designation,
    required this.office,
    required this.zone,
    required this.searchKey,
  });

  String get displayText => '$designation\n$office';
  String get letterText => '$designation\n$office';
}

final List<RailwayOffice> railwayOffices = [
  // HQ Offices - Dy. CCM
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, Central Railway\nMumbai',
    zone: 'CR',
    searchKey: 'central railway cr mumbai dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, Eastern Railway\nKolkata',
    zone: 'ER',
    searchKey: 'eastern railway er kolkata dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, East Central Railway\nHajipur',
    zone: 'ECR',
    searchKey: 'east central railway ecr hajipur dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, East Coast Railway\nBhubaneswar',
    zone: 'ECoR',
    searchKey: 'east coast railway ecor bhubaneswar dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, Northern Railway\nNew Delhi',
    zone: 'NR',
    searchKey: 'northern railway nr new delhi dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, North Central Railway\nPrayagraj',
    zone: 'NCR',
    searchKey: 'north central railway ncr prayagraj allahabad dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, North Eastern Railway\nGorakhpur',
    zone: 'NER',
    searchKey: 'north eastern railway ner gorakhpur dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, Northeast Frontier Railway\nGuwahati',
    zone: 'NFR',
    searchKey: 'northeast frontier railway nfr guwahati dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, North Western Railway\nJaipur',
    zone: 'NWR',
    searchKey: 'north western railway nwr jaipur dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, Southern Railway\nChennai',
    zone: 'SR',
    searchKey: 'southern railway sr chennai dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, South Central Railway\nSecunderabad',
    zone: 'SCR',
    searchKey: 'south central railway scr secunderabad dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, South Eastern Railway\nKolkata',
    zone: 'SER',
    searchKey: 'south eastern railway ser kolkata dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, South East Central Railway\nBilaspur',
    zone: 'SECR',
    searchKey: 'south east central railway secr bilaspur dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, South Western Railway\nHubballi',
    zone: 'SWR',
    searchKey: 'south western railway swr hubballi dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, Western Railway\nMumbai',
    zone: 'WR',
    searchKey: 'western railway wr mumbai dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, West Central Railway\nJabalpur',
    zone: 'WCR',
    searchKey: 'west central railway wcr jabalpur dy ccm headquarters',
  ),
  RailwayOffice(
    designation: 'Dy. Chief Commercial Manager/Reservation',
    office: 'Headquarters Office, South Coast Railway\nVisakhapatnam',
    zone: 'SCoR',
    searchKey: 'south coast railway scor visakhapatnam dy ccm headquarters',
  ),

  // DRM Offices - Sr. DCM
  // CR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Mumbai CSMT', zone: 'CR', searchKey: 'cr central railway mumbai csmt sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Bhusawal', zone: 'CR', searchKey: 'cr central railway bhusawal sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Nagpur', zone: 'CR', searchKey: 'cr central railway nagpur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Pune', zone: 'CR', searchKey: 'cr central railway pune sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Solapur', zone: 'CR', searchKey: 'cr central railway solapur sr dcm drm'),
  // ER
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Howrah', zone: 'ER', searchKey: 'er eastern railway howrah sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Sealdah', zone: 'ER', searchKey: 'er eastern railway sealdah sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Asansol', zone: 'ER', searchKey: 'er eastern railway asansol sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Malda', zone: 'ER', searchKey: 'er eastern railway malda sr dcm drm'),
  // ECR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Danapur', zone: 'ECR', searchKey: 'ecr east central railway danapur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Dhanbad', zone: 'ECR', searchKey: 'ecr east central railway dhanbad sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Pt. Deen Dayal Upadhyaya (DDU)', zone: 'ECR', searchKey: 'ecr east central railway ddu mughalsarai sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Samastipur', zone: 'ECR', searchKey: 'ecr east central railway samastipur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Sonpur', zone: 'ECR', searchKey: 'ecr east central railway sonpur sr dcm drm'),
  // ECoR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Khurda Road', zone: 'ECoR', searchKey: 'ecor east coast railway khurda road sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Sambalpur', zone: 'ECoR', searchKey: 'ecor east coast railway sambalpur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Waltair', zone: 'ECoR', searchKey: 'ecor east coast railway waltair visakhapatnam sr dcm drm'),
  // NR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, New Delhi', zone: 'NR', searchKey: 'nr northern railway new delhi sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Ambala', zone: 'NR', searchKey: 'nr northern railway ambala sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Firozpur', zone: 'NR', searchKey: 'nr northern railway firozpur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Lucknow (NR)', zone: 'NR', searchKey: 'nr northern railway lucknow sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Moradabad', zone: 'NR', searchKey: 'nr northern railway moradabad sr dcm drm'),
  // NCR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Prayagraj', zone: 'NCR', searchKey: 'ncr north central railway prayagraj allahabad sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Agra', zone: 'NCR', searchKey: 'ncr north central railway agra sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Jhansi', zone: 'NCR', searchKey: 'ncr north central railway jhansi sr dcm drm'),
  // NER
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Izzatnagar', zone: 'NER', searchKey: 'ner north eastern railway izzatnagar bareilly sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Lucknow (NER)', zone: 'NER', searchKey: 'ner north eastern railway lucknow sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Varanasi', zone: 'NER', searchKey: 'ner north eastern railway varanasi sr dcm drm'),
  // NFR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Alipurduar', zone: 'NFR', searchKey: 'nfr northeast frontier railway alipurduar sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Katihar', zone: 'NFR', searchKey: 'nfr northeast frontier railway katihar sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Lumding', zone: 'NFR', searchKey: 'nfr northeast frontier railway lumding sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Rangiya', zone: 'NFR', searchKey: 'nfr northeast frontier railway rangiya sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Tinsukia', zone: 'NFR', searchKey: 'nfr northeast frontier railway tinsukia sr dcm drm'),
  // NWR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Jaipur', zone: 'NWR', searchKey: 'nwr north western railway jaipur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Ajmer', zone: 'NWR', searchKey: 'nwr north western railway ajmer sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Bikaner', zone: 'NWR', searchKey: 'nwr north western railway bikaner sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Jodhpur', zone: 'NWR', searchKey: 'nwr north western railway jodhpur sr dcm drm'),
  // SR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Chennai', zone: 'SR', searchKey: 'sr southern railway chennai madras sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Madurai', zone: 'SR', searchKey: 'sr southern railway madurai sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Palakkad', zone: 'SR', searchKey: 'sr southern railway palakkad sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Salem', zone: 'SR', searchKey: 'sr southern railway salem sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Thiruvananthapuram', zone: 'SR', searchKey: 'sr southern railway thiruvananthapuram trivandrum sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Tiruchirappalli', zone: 'SR', searchKey: 'sr southern railway tiruchirappalli trichy sr dcm drm'),
  // SCR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Secunderabad', zone: 'SCR', searchKey: 'scr south central railway secunderabad sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Hyderabad', zone: 'SCR', searchKey: 'scr south central railway hyderabad sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Guntakal', zone: 'SCR', searchKey: 'scr south central railway guntakal sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Guntur', zone: 'SCR', searchKey: 'scr south central railway guntur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Nanded', zone: 'SCR', searchKey: 'scr south central railway nanded sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Vijayawada', zone: 'SCR', searchKey: 'scr south central railway vijayawada sr dcm drm'),
  // SER
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Adra', zone: 'SER', searchKey: 'ser south eastern railway adra sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Chakradharpur', zone: 'SER', searchKey: 'ser south eastern railway chakradharpur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Kharagpur', zone: 'SER', searchKey: 'ser south eastern railway kharagpur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Ranchi', zone: 'SER', searchKey: 'ser south eastern railway ranchi sr dcm drm'),
  // SECR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Bilaspur', zone: 'SECR', searchKey: 'secr south east central railway bilaspur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Nagpur (SECR)', zone: 'SECR', searchKey: 'secr south east central railway nagpur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Raipur', zone: 'SECR', searchKey: 'secr south east central railway raipur sr dcm drm'),
  // SWR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Hubballi', zone: 'SWR', searchKey: 'swr south western railway hubballi hubli sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Bengaluru', zone: 'SWR', searchKey: 'swr south western railway bengaluru bangalore sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Mysuru', zone: 'SWR', searchKey: 'swr south western railway mysuru mysore sr dcm drm'),
  // WR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Mumbai Central', zone: 'WR', searchKey: 'wr western railway mumbai central sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Vadodara', zone: 'WR', searchKey: 'wr western railway vadodara baroda sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Ahmedabad', zone: 'WR', searchKey: 'wr western railway ahmedabad sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Ratlam', zone: 'WR', searchKey: 'wr western railway ratlam sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Rajkot', zone: 'WR', searchKey: 'wr western railway rajkot sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Bhavnagar', zone: 'WR', searchKey: 'wr western railway bhavnagar sr dcm drm'),
  // WCR
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Jabalpur', zone: 'WCR', searchKey: 'wcr west central railway jabalpur sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Bhopal', zone: 'WCR', searchKey: 'wcr west central railway bhopal sr dcm drm'),
  RailwayOffice(designation: 'Sr. Divisional Commercial Manager/Reservation', office: 'DRM Office, Kota', zone: 'WCR', searchKey: 'wcr west central railway kota sr dcm drm'),
];
