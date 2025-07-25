double getLocationAverageCost(String location) {
  // Mocking average travel cost data
  if (location.toLowerCase() == 'paris') return 100000;
  if (location.toLowerCase() == 'new york') return 120000;
  if (location.toLowerCase() == 'europe') return 200000;
  return 80000; 
}
