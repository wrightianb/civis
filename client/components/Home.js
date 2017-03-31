import React from 'react';
import { connect } from 'react-redux';
import { browserHistory, Link } from 'react-router';
import HomeCard from './HomeCard';
import AboutUs from './AboutUs';
import Footer from './Footer';
import About from './About';
import HomeLinks from './HomeLinks';
import civis from '../images/civis.svg';
import { homeCardStyle, accordian } from './styles.scss';

class Home extends React.Component {

  componentDidMount() {
    $('.parallax').parallax();
    $('.collapsible').collapsible();
  }

  render() {
    return(
      <div>
        <img src={civis} style={{height: "120px", margin: "0 auto", display: "block"}} />
        <div className="row">
          <div className="col s12 m10 offset-m1 l8 offset-l2">
            <div className={`card grey lighten-3 ${homeCardStyle}`}>
              <div className="card-content">
                <HomeCard />
              </div>
            </div>
          </div>
        </div>
          <HomeLinks />
          <ul className='collapsible' data-collapsible='accordion'>
            <li>
              <div className='center collapsible-header grey lighten-3'>
                <h3 className={accordian}>Click to Learn More</h3>
              </div>
              <div className='collapsible-body'><About /></div>
            </li>
          </ul>
          <Footer />
        </div>
      )
    }
  };

export default connect()(Home);
