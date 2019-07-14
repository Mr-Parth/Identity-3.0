<template>
 <div class="container bgcustom-light p-5 rounded">
  <h1 class="title">Description</h1>

  <div class="row">
    <div class="col-12 col-md-6 text-center my-auto">

      <h5><strong>Identity Need To Be Secure and Generalised over Platforms</strong></h5>
      <h6 class="pb-3">Dapp implementation is proven Philosopher Stone </h6>
      <ul class="list-group">
        <li class="list-group-item">Oauth Registration for Organisations</li>
        <li class="list-group-item">User Registration</li>
        <li class="list-group-item">Oauth Authentication</li>
        <li class="list-group-item">All User listing for authority if need to exist</li>
      </ul>
      <p style="font-size:13px;">And ALL OF THIS IS HANDLED USING <strong>SMART CONTRACT</strong></p>

    </div>
    <div class="col-12 col-md-6 text-center my-auto">
      <h6>Install Metamask</h6>
      <h6>Start Ganache</h6>
      <h6>Set Metamask to Ganache port</h6>
      <h6>For complications on connection, check ganache port in truffle.js</h6>

    </div>
    </div>
  </div>

</template>
<script>

import mixin from '../libs/mixinViews';
export default {
    mixins: [mixin],
    data(){
        return{
            name:'',
            pname: '',
            client_id:'',
            client_secret:''
            
        }
    },
    methods:{
      getClientName(){
        window.bc.getMainAccount().then(account => {
        window.bc.contract().getOwnProfile.call({
            from: account
          },
          (error, userDet) => {
            if (userDet) {
              this.name=userDet[1];
              
            }
          else{console.log("error: ",error);}
          }
        );
      });
      },
      setClientName(){
        this.getClientName();
        window.bc.getMainAccount().then(account => {
          window.bc.contract().registerClient(
            this.name,{
              from: address
          },
            )
        })
      },
        performSubmit(){
          this.setClientName();
          console.log(this.name)
          this.generateCreds();
          this.setCreds();
        },
        makeid(length) {
            var result     = '';
            var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            var charactersLength = characters.length;
            for ( var i = 0; i < length; i++ ) {
                result += characters.charAt(Math.floor(Math.random() * charactersLength));
            }
            return result;
          },

        generateCreds(){

          this.client_id = this.makeid(32);
          this.client_secret = this.makeid(32);  
        },
        setCreds(){ 
        window.bc.getMainAccount()
        .then(account => {
          window.bc.contract().addClientApp(
            this.pname,
            this.client_id,
            this.client_secret, {
              from: account,
            },(err) => console.log(err,)
          )
        })
        .catch(error => console.log(error));
        this.getProfile();
        },
      getProfile() {
      window.bc.getMainAccount().then(account => {
        window.bc.contract().getClientProfile.call({
            from: account
          },
          (error, clientDet) => {
            if (clientDet) {
              console.log("det: ",clientDet);

            }


            console.log(error);
          }
        );
      });
    }

    },

    computed: {

    disableSubmit() {

      return (
        !this.pname.length ||
        !this.blockchainIsConnected()
      );
    }
  },
}
</script> 