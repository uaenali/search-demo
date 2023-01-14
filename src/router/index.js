import Vue from 'vue'
import Router from 'vue-router'
import Home from '../views/Home'

Vue.use(Router)

// 实例化
export default new Router({
  routes: [
    {path: '/', redirect: '/product/list'},
    {path: '/home',
      component: Home,
      children: [
        // {path: '/dashboard/types', component: () => import('../views/dashboard/types')},
        // 项目管理
        {path: '/product/detail', component: () => import('../views/product/Detail')},
        {path: '/product/list', component: () => import('../views/product/List')}
      ]
    }
  ]
})
