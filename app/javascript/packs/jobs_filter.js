document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('job-filter-form');
  const jobListings = document.getElementById('job-listings');
  let map;

  form.addEventListener('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(form);
    const searchParams = new URLSearchParams(formData);

    fetch(`${form.action}?${searchParams.toString()}`, {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      jobListings.innerHTML = data.job_listings_html;
      updateMap(data.job_coordinates);
    });
  });

  function initMap() {
    map = L.map('map').setView([0, 0], 2);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map);
  }

  function updateMap(coordinates) {
    if (!map) {
      initMap();
    }

    map.eachLayer(layer => {
      if (layer instanceof L.Marker) {
        map.removeLayer(layer);
      }
    });

    coordinates.forEach(coord => {
      L.marker([coord.lat, coord.lng])
        .addTo(map)
        .bindPopup(`<b>${coord.title}</b><br>${coord.company}<br>${coord.industry}`);
    });

    if (coordinates.length > 0) {
      map.fitBounds(L.latLngBounds(coordinates.map(coord => [coord.lat, coord.lng])));
    }
  }

  initMap();
});
