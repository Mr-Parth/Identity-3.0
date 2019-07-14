<template>
 <div>
  <h1 class="title">Login for OAuth</h1>

  <div class="row">
    <div class="col-md-3">

    <div class="form-group">
        <label for="description" >Client Id</label>
        <input class="form-control" placeholder="Enter your name" type="text" v-model="client_id">
    </div>
    <div class="form-group">
        <label for="description" >Scope</label>
        <input class="form-control" placeholder="Scope" type="text" v-model="scope">
    </div>
    <div class="form-group">
               <label for="description" >token  :- </label><p>{{access_token}}</p>
    </div>
      <button class="btn btn-primary" :disabled="disableSubmit" @click="performSubmit">Login</button>
      <!-- <strong v-show="submitting">Submitting...</strong> -->

      </div>
    </div>
  </div>

</template>
<script>
import mixin from '../libs/mixinViews';
export default{
    mixins:[mixin],
    data(){
        return{
            access_token:'',
            client_id:'',
            scope:'',
        }
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
            this.access_token=this.makeid(40);
            this.setToken();

        },
        setToken(){
            window.bc.getMainAccount().then(account =>{
                window.bc.contract().addToken(
                    this.client_id,
                    this.access_token,
                    this.scope,{
                        from:account
                   },(err) => console.log(err,)
          )
        })
        .catch(error => console.log(error));
        }

    }
}
</script>