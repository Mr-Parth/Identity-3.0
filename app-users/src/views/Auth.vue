<template>
 <div class="container bgcustom-light p-5 rounded">
  <h1 class="title">OAuth Registration</h1>

  <div class="row">
    <div class="col-12 col-md-6 text-center my-auto">

      <h5>It is for services (like Medium)</h5>
      <h5>to generate Oauth Credentials,</h5>
      <h5>to integrate in their authentication</h5>

    </div>
    <div class="col-12 col-md-5 text-center">
    <label for="description" >Company/Project</label>
    <div class="row form-group">
    <div class="col-8 ">
    <input class="form-control" placeholder="Enter your name" type="text" v-model="pname">
    </div>
    <div class="col-4">
    <button class="btn btn-primary" :disabled="disableSubmit" @click="performSubmit">Generate</button>
    </div>
    </div>
    <div class="form-group">
        <label for="description" >Client Id </label>
        <input class="form-control rounded-50" placeholder="Client_Id" type="text" v-model="client_id" readonly>
    </div>
    <div class="form-group">
        <label for="description" >Client Secret</label>
        <input class="form-control" placeholder="Client Secret" type="text" v-model="client_secret" readonly>
    </div>
      
      <!-- <strong v-show="submitting">Submitting...</strong> -->

      </div>
    <div class="col-1"></div>
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