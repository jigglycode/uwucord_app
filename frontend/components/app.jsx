import React from "react";
import NavContainer from "../components/nav/nav_container"
import {Route,Switch} from "react-router-dom"
import LoginContainer from "../components/session/login_container"
import SignUpContainer from "../components/session/signup_container"
import SplashContainer from "./splash/splash_container";
import SideChannelsContainer from "./home/channels/side_channels_container"
import Modal from './modal'

import {AuthRoute, ProtectedRoute} from '../util/route_util'

const App = () => (
    <>
         <Modal />
         <Switch>
        <ProtectedRoute path="/channels/@me" component={SideChannelsContainer} />
        <AuthRoute path ="/login" component={LoginContainer} />
        <AuthRoute path="/register" component={SignUpContainer} />
        <AuthRoute  path="/" component={NavContainer}/>
         </Switch>
    
    </>
)

export default App