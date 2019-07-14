## Identity 3.0

### Screenshots of Dapp

![alt text](https://raw.githubusercontent.com/Mr-Parth/Identity-3.0/master/captured/1.png "Cap")
![alt text](https://raw.githubusercontent.com/Mr-Parth/Identity-3.0/master/captured/2.png "Cap")
![alt text](https://raw.githubusercontent.com/Mr-Parth/Identity-3.0/master/captured/3.png "Cap")
![alt text](https://raw.githubusercontent.com/Mr-Parth/Identity-3.0/master/captured/4.png "Cap")
![alt text](https://raw.githubusercontent.com/Mr-Parth/Identity-3.0/master/captured/5.png "Cap")


### Quick Installation
1) Download the project and decompress it into the folder **~/idm** (or wherever you want).
2) Start ganache (or your private blockchain).
3) Open the terminal (if you are using Windows you **must use the Power Shell**) in the folder **~/idm** and run the command:
```sh
$ truffle console --network ganache
```
4) If ganache is running you should be inside the truffle console; now run the following command in the truffle console:
```sh
> migrate --reset --compile-all
```
5) If the migration was successful, copy the file **~/idm/build/contracts/Users.json** into the folder **~/idm/app-users/src/assets/**
6) Open another terminal in the folder **~/idm/app-users** and run the command:
```sh
$ npm install
```
7) Once all the dependencies are installed run the command:
```sh
$ npm run dev
```
If everything went fine, the terminal will display a message similar to:
```sh
DONE  Compiled successfully in 5166ms           15:54:53

Your application is running here: http://localhost:8080
```
8) Open the browser, go to the URL shown by your terminal and play with the DApp!

**NOTE:** if you want to try to add more user profiles you have to install metamask in your browser, then import the accounts into metamask and finally change account on metamask in order to register a new user.
