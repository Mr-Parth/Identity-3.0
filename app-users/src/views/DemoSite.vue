<template>

  <div class="container bgcustom-light p-5 rounded">
    <h1 class="title">Demo Page</h1>
    <div class="text-center">    
      <h4>For implementing our login OAuth service, service need to register </h4>
    <h4>itself on our Identity Management Contract (Ethereum Network)</h4>
    <h5 class="pt-3">Hello {{userAddressAccount}}</h5>
    <div class="form-group row">
    <div class="col-3"></div>
    <div class="col-sm-6 mb-3 mb-sm-0">
    <input placeholder="Enter Password " id ="pass" type="password" class="form-control" >
    </div>
    <div class="col-3"></div>
    </div>
    <button class="btn btn-primary mt-4" @click="performSubmit"> Login With Deauth </button>
    </div>

  </div>
  

</template>

<script>
// importing common function
import mixin from '../libs/mixinViews';
import ipfs from '../libs/ipfs.js';
export default {
  mixins: [mixin],

  data() {
    return {
        client_id:"INK4eK8RKUTs15lSYJLe4c5e7BO9fNKE",
        access_token:"",
        scope:"",
        userName: '', // variable binded with the name's input field
        userDob: '', // varialbe binded to the status's input filed
        userId: 0, // user ID from the blockchain

        userAddressAccount: '0x0', // address of the user
        balance: 0, // balance of the user
        userIpns: '',
        password: '',
  }
  },
  created() {
    this.getProfile();
  },

  methods:{         
          makeid(length) {
            var result     = '';
            var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            var charactersLength = characters.length;
            for ( var i = 0; i < length; i++ ) {
                result += characters.charAt(Math.floor(Math.random() * charactersLength));
            }
            return result;
          },
        performSubmit(){
            if (document.getElementById("pass").value == this.password){
            this.access_token=this.makeid(40);
            this.setToken();}
            else{
              alert("Invalid Password");
            }

        },
        setToken(){
            window.bc.getMainAccount().then(account =>{
                window.bc.contract().addToken(
                    this.client_id,
                    this.access_token,
                    this.scope,{
                        from:account
                   },(err) => console.log(err,)
          );alert("TOKEN VERIFIED AND STORED IN CONTRACT | USER LOGIN SUCCESSFUL")
        })
        .catch(error => console.log(error));
        },
      getProfile() {
      window.bc.getMainAccount().then(account => {
        window.bc.contract().getOwnProfile.call({
            from: account
          },
          (error, userDet) => {
            if (userDet) {
              this.userId = userDet[0].toNumber();
              this.userName = userDet[1];
              this.userDob = userDet[2];
              this.userAddressAccount = userDet[3];
              this.userIpns = userDet[4];
              this.password = userDet[5];
            }

            this.setErrorMessage(error);
          }
        );
      });
    }

  }
}
</script>
