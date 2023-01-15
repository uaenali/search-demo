<template>
  <div class="container">
    <div class="card">
      <div class="item-title">当前进度</div>
      <div class="rate">
        <el-steps :active="2" align-center style="margin-top:20px">
          <el-step title="项目创建" description="2010/10/10 14:20:23"></el-step>
          <el-step title="数据集上传" description="进度39%"></el-step>
          <el-step title="建库" description="未开始"></el-step>
        </el-steps>
      </div>
    </div>
    <div class="card">
      <div class="item-header">
        <div class="item-title">项目信息</div>
        <div class="right-button">
          <el-button type="primary" size="medium" @click="handleEdit">编辑项目信息</el-button>
          <el-button type="info" plain @click="handleDelete">删除项目</el-button>
        </div>
      </div>
      <div class="line"></div>
      <el-descriptions :column="1">
        <el-descriptions-item label="项目名称">直流知识数据库</el-descriptions-item>
        <el-descriptions-item label="项目描述">18100000000</el-descriptions-item>
        <el-descriptions-item label="数据集">
          内容库
          手动上传
        </el-descriptions-item>
        <el-descriptions-item label="检索配置">综合检索(xxx检索模型)、内容检索(xxx检索模型)</el-descriptions-item>
        <el-descriptions-item label="创建时间">2019-09-10 10:44</el-descriptions-item>
      </el-descriptions>
    </div>
    <!--  -->
  </div>
</template>

<script>
export default {
  data () {
    return {
    }
  },
  methods: {
    handleEdit () {
      console.log('弹窗')
    },
    handleDelete () {
      console.log('删除')
    }
  }
}

</script>
<style lang="less" scoped>
.container {
  background: #f6f6f6;
  padding: 14px;
  .item-header {
    display: flex;
    justify-content: space-between;
  }
  .item-title {
    color: #44484f;
    font-weight: 500;
  }
  .card {
    background: #fff;
    padding: 14px 20px 30px;
    margin-bottom: 12px;
  }
  .line {
    border: .5px solid #ccc;
    margin-top: 10px;
    margin-bottom: 25px;
  }
}
</style>
