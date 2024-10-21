document.addEventListener('DOMContentLoaded', function() {
  const cityInput = document.getElementById('city-autocomplete');
  const latitudeInput = document.getElementById('latitude');
  const longitudeInput = document.getElementById('longitude');
  const countrySelect = document.getElementById('country-select');

  if (cityInput && latitudeInput && longitudeInput && countrySelect) {
    const autocomplete = new google.maps.places.Autocomplete(cityInput, {
      types: ['(cities)'],
      fields: ['geometry']
    });

    autocomplete.addListener('place_changed', function() {
      const place = autocomplete.getPlace();
      if (place.geometry && place.geometry.location) {
        latitudeInput.value = place.geometry.location.lat();
        longitudeInput.value = place.geometry.location.lng();
      }
    });

    countrySelect.addEventListener('change', function() {
      autocomplete.setComponentRestrictions({ country: this.value });
    });
  }
});
