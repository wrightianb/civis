import React from 'react';
import { browserHistory } from 'react-router';

class AddressForm extends React.Component {

  handleSubmit = (e) => {
    e.preventDefault();
    let address = this.address.value
    this.updateAddress(address)
  }

  geolocate = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition( position => {
        let coords = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        console.log(coords);
        let url = 'https://maps.googleapis.com/maps/api/geocode/json?'
        let key = 'AIzaSyCk8j46oOc98pfId6TdgvjgDqCcEkJxB40'
        $.ajax({
          url: `${url}latlng=${coords.lat},${coords.lng}&key=${key}`,
          type: 'GET'
        }).done( data => {
          let address = data.results[0].formatted_address;
          this.updateAddress(address);
        }).fail( err => {
          Materialize.toast('Error');
        });
      });
    } else {
      Materialize.toast("Can't Geolocate.")
    }
  }

  updateAddress = (address) => {
    $.ajax({
      type: 'PATCH',
      url: `/api/user/address`,
      dataType: 'JSON',
      data: { address }
    }).done(data => {
      Materialize.toast('Address Updated', 3000);
      if (this.props.addressEntered)
        this.props.addressEntered();
    }).fail( data => {
      Materialize.toast('Invalid address, Please try again', 3000);
    });
  }

  render(){
    return(
      <div>
        <span className='card-title center'>
          Find your legislators by zip code or address.
        </span>
        <form className='center' onSubmit={this.handleSubmit}>
          <div className="row">
            <input
             ref={ n => this.address = n}
             className="col s12 m8 offset-m1"
             placeholder='Zip code or Address'
             required
             autoFocus
            />
            <input className='btn blue-grey' type='submit'/>
          </div>
        </form>
        <button className="btn" onClick={this.geolocate}>Geolocate</button>
      </div>
    );
  }
}

export default AddressForm;
