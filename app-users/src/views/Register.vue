<template>
<div>
  
  <div class="container bgcustom-light p-5 rounded">

        <div class="row ">
          <div class="col-lg-5 d-none d-lg-block bg-register-image"> 
            <img class="img-fluid img-thumbnail rounded-circle " src="https://pbs.twimg.com/profile_images/968698422751518720/zeP0peZp.jpg" />
          </div>
          <div class="col-lg-7  text-center">
            <div>
              <h1 class="h4 text-gray-900 mb-4">Create an Account!</h1>
            </div>
           
            <div class="form-group row">
              <div class="col-3"></div>
              <div class="col-6 mb-3 mb-sm-0 pb-2 ">
              <input class="form-control p-2" id="rc" placeholder="Name" type="text" v-model="userName"></div>
              <div class="col-3"></div>

            </div>

            <div class="form-group row" >
              <div class="col-3"></div>
              <div class="col-6 pb-2" >
                <span style="color:gray">Date Of Birth</span>
                <input class="form-control p-2 " id ="rc" type="date" v-model="userDob" >
              </div>
              <div class="col-3"></div>
              
            </div>

          <div class="form-group row">
              <div class="col-3"></div>
              <div class="col-6 pb-2" >
                <span style="color:gray">Upload Documents Zip</span>
                <input  type="file" @change="captureFile" class="form-control-file p-3">
                <button class="btn" @click="uploadToIpfs">Upload</button><br>
              </div>
              <div class="col-3"></div>

          </div>
          <div class="form-group row">
              <div class="col-3"></div>
              <div class="col-sm-6 mb-3 mb-sm-0">
              <input placeholder=" Password " id ="rc" type="password" class="form-control" v-model="password">
              </div>
              <div class="col-3"></div>
          </div>
          <div class="form-group row">
            <div class="col-3"></div>
            <div class="col-sm-6 mb-3 mb-sm-0">
            <button class="btn btn-primary" :disabled="disableSubmit" @click="performSubmit">Register</button></div>
            <div class="col-3"></div>
          </div>
          <div class="form-group row">
            <div class="col-sm-6 mb-3 mb-sm-0">
              <strong v-show="submitting">Submitting...</strong>

              <strong class="text-danger"></strong>
              <div v-show="errorStr" class="alert alert-danger mt-3" role="alert">
                {{ errorStr }}
                <br>
                <small>Check the browser console for more details.</small>
              </div>

              <div v-show="successMessage" class="alert alert-success mt-3" role="alert">
                <strong>You've been registerd!</strong>
                <br>
                You will be redirected to the profile page <strong>once the block will be mined!</strong>
              </div>
            </div>
          </div>
          </div>
      </div>
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
      userName: '', // variable binded with the name's input field
      userDob: '', // varialbe binded to the status's input filed
      userId: 0, // user ID from the blockchain

      userAddressAccount: '0x0', // address of the user
      balance: 0, // balance of the user
      userIpns: '',
      password: '',
      submitting: false, // true once the submit button is pressed
      successMessage: false, // true when the user has been registered successfully

      tmoConn: null, // contain the intervalID given by setInterval
      tmoReg: null, // contain the intervalID given by setInterval
      errorStr: null, // it shows the error message
      buffer: '',
      dr:'',
  }
  },
  computed: {
    /**
     * It disables the submit button when the the name or userStatus are not filled
     * or the submit button is pressed or the connection with the blockchin is
     * not established.
     */
    disableSubmit() {

      return (
        !this.userName.length ||
        !this.userIpns.length ||
        this.submitting || 
        this.validatedDate()||
        !this.blockchainIsConnected()
      );
    }
  },

  created() {
    // it checks every 500ms if the user is registered until the connection is established
    this.redirectIfUserRegistered();
  },

  methods: {
    /**
     * Perform the registration of the user when the submit button is pressed.
     *
     * @return {void}
     */
    performSubmit() {
      this.submitting = true;
      this.errorStr = null;
      this.successMessage = false;

      window.bc.getMainAccount()
        .then(address => this.performUserRegistration(address));
    },
    validatedDate(){
        // if(this.userDob >= )
    },
    /**
     * Show the form error.
     *
     * @param {object} err
     * @return {void}
     */
    showErrorMessage(err) {
      console.error(err);

      this.errorStr = null;

      if (err) this.errorStr = err.toString();

      if (!this.errorStr) this.errorStr = 'Error occurred!';
    },

    /**
     * Perform the user registration cannling the smart contract
     * function registerUser.
     *
     * @param {string} address
     * @return {void}
     */
    performUserRegistration(address) {
      console.log(this.userDob);
      window.bc.contract().registerUser(
        this.userName,
        this.userDob,
        this.userIpns,
        this.password, {
          from: address,
          gas: 800000
        },
        (err, txHash) => {
          this.submitting = false;

          if (err) {
            this.showErrorMessage(err);
          } else {
            this.successMessage = true;

            // it emits a global event in order to update the top menu bar
            Event.$emit('userregistered', txHash);

            // the transaction was submitted and the user will be redirected to the
            // profile page once the block will be mined
            this.redirectWhenBlockMined();
          }
        }
      )
    },

    /**
     * Check if the user visitng this page is registered: if the user is already
     * registered he will be redirected to the Profile page.
     *
     * @return {void}
     */
    redirectIfUserRegistered() {
      this.tmoConn = setInterval(() => {
        // checking first the connection
        if (this.blockchainIsConnected()) {
          // stopping the interval
          clearInterval(this.tmoConn);

          // calling the smart contract
          this.isRegistered().then(res => {
            if (res) {
              // redirecting to the profile page
              this.$router.push("profile");
            }
          });
        }
      }, 500);
    },

    /**
     * Once the user submitted his registration this funciton checks every 1000 ms
     * if the registration is successfully. Once the user is registered he will be
     * redirected to the profile page.
     *
     * NOTE: in order to check if the user has been registered successfully the
     * function has to check several time because the block can take several
     * minutes to be mined (depending on the the blockchain you are using).
     *
     * @return {void}
     */
    redirectWhenBlockMined() {
      this.tmoReg = setInterval(() => {
        if (this.blockchainIsConnected()) {
          this.isRegistered()
            .then(res => {
              if (res) {
                // stopping the setInterval
                clearInterval(this.tmoReg);

                // redirecting the user to the profile page
                this.$router.push("profile");
              }
            })
            .catch(error => this.showErrorMessage(error));
        }
      }, 1000);
    },

      captureFile(file){
        console.log("Capturing..");

        const reader = new FileReader();

        reader.readAsArrayBuffer(file.target.files[0]);
        reader.onloadend = async () => {
          this.buffer = await this.convertToBuffer(reader.result);
        };
      },

    async convertToBuffer(reader) {
      return Buffer.from(reader);
    },

    async uploadToIpfs(){
      console.log("Upload");
      let hashedText;
      hashedText = await ipfs.add(this.buffer)
        console.log('hash',hashedText);
        this.userIpns=hashedText[0].hash
    },
  }
}
</script>
<style>
#rc {
  border-radius: 12px;
  border: 2px solid rgb(97, 97, 96);
 

}
</style>