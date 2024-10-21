document.addEventListener('turbolinks:load', () => {
  const countrySelect = document.getElementById('country-select');
  const regionSelect = document.getElementById('region-select');
  const cityInput = document.getElementById('city-input');

  if (countrySelect && regionSelect && cityInput) {
    countrySelect.addEventListener('change', () => {
      const countryCode = countrySelect.value;
      fetch(`/locations/regions?country=${countryCode}`)
        .then(response => response.json())
        .then(regions => {
          regionSelect.innerHTML = '<option value="">Select a region</option>';
          regions.forEach(region => {
            regionSelect.innerHTML += `<option value="${region[1]}">${region[0]}</option>`;
          });
        });
      cityInput.value = '';
    });

    regionSelect.addEventListener('change', () => {
      cityInput.value = '';
    });
  }
});
