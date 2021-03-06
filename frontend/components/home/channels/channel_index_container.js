import {connect} from 'react-redux'
import ChannelIndex from './channel_index'
import {logout} from '../../../actions/session_actions'
import {openModal} from '../../../actions/modal_actions'
import {changeActiveChannel} from '../../../actions/channel_actions'


const msp = (state,ownProps) => {
    const currentServer = ownProps.currentServer
    if (!currentServer) return {};
     
    return ({
            currentUser: state.entities.users[state.session.id],
            currentServer: currentServer,
            channels: Object.values(state.entities.channels).filter(channel => channel.serverId == currentServer.id)
        })
}


const mdp = dispatch => ({
    logout: () => dispatch(logout()),
    openModal: modal => dispatch(openModal(modal)),
    changeActiveChannel: data => dispatch(changeActiveChannel(data))

})

export default connect(msp, mdp)(ChannelIndex)