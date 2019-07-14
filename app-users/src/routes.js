import Vue from 'vue';
import Router from 'vue-router';
import Profile from '@/views/Profile';
import List from '@/views/List';
import Register from '@/views/Register';
import Auth from '@/views/Auth';
import Description from "@/views/Description";
import DemoSite from "@/views/DemoSite";
import access from '@/views/access';
Vue.use(Router);

export default new Router({
    routes: [
        {
            path: '/',
            name: 'Description',
            component: Description
        },
        {
            path: '/demo',
            name: 'DemoSite',
            component: DemoSite
        },
        {
            path: '/list',
            name: 'List',
            component: List
        },
        {
            path: '/profile',
            name: 'Profile',
            component: Profile
        },

        {
            path: '/register',
            name: 'Register',
            component: Register
        },
        {
            path: '/auth',
            name: 'Auth',
            component: Auth
        },
        {
            path: '/access',
            name: 'Access',
            component: access
        },
    ],
    linkActiveClass: 'active'
});


