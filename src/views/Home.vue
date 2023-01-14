<template>
  <el-container class="page-home">
    <el-header>
      <img class="header-logo" src="@/assets/icons/logo.png">
      <span class="title">检索产品Demo</span>
      <div class="userinfo">
        <img src="@/assets/icons/avatar.png" alt="" class="avatar">
        <div class="info">
          <span class="name">用户名称</span>
          <span class="user-id">ID:22334455</span>
        </div>
      </div>
    </el-header>
    <el-container>
      <el-aside width="200px">
        <el-menu :router="true">
          <el-submenu v-for="(item, index) in menu" :key="index" :index="String(index)">
            <template #title>
              <i class="el-icon-menu"></i>
              <span>{{item.title}}</span>
            </template>
            <el-menu-item v-for="child in item.children" :key="child.link" :index="child.link">{{child.title}}</el-menu-item>
          </el-submenu>
        </el-menu>
      </el-aside>
      <el-main>
        <router-view></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>
<script>
export default {
  data () {
    return {
      // 导航数据
      menu: [
        {
          title: 'Dashboard',
          children: [
            {title: '其他', link: '/dashboard/types'}
          ]
        },
        {
          title: '项目管理',
          children: [
            {title: '项目列表', link: '/product/list'}
          ]
        }
      ]
    }
  }
}
</script>
<style lang="less">
.page-home {
  height: 100%;
  .el-header {
    background: #000;
    display: flex;
    height: 54px;
    width: 100%;
    justify-content: start;
    align-items: center;
    padding: 0 30px;
    font-weight: 500;
    line-height: 54px;
  }
  .header-logo {
    height: 39px;
    padding-right: 20px;
  }
  .title{
    font-family: PingFangSC-Regular,PingFang SC,sans-serif;
    font-weight: 600;
    font-style: normal;
    font-size: 19px;
    color: #fff;
    text-align: center;
    }
  .userinfo {
    display: flex;
    flex-direction:row;
    align-items:center;
    margin-left: 900px;
    height:54px;
  }
  .avatar {
    height: 39px;
    margin-right: 10px;
    vertical-align: middle;
  }
  .info {
    color:#fff;
    font-size: 12px;
  }
  .el-aside {
    height: 100vh;
  }
  .el-menu {
    background: #fff;
    height: 100%;
  }
  .el-main {
    padding: 0;
    background: #f6f6f6;
  }
}
</style>
