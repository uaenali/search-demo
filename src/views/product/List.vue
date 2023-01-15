<template>
  <div class="container">
    <el-form :model="queryForm" ref="queryForm" class="top">
      <el-form-item>
        <el-select v-model="queryForm.search_condition_type" placeholder="请选择" clearable style="width:100px;">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
            </el-option>
        </el-select>
        <el-input v-model="queryForm.search_condition_value" placeholder="请输入" @keyup.enter.native="handleQuery" style="width:250px;"></el-input>
      </el-form-item>
      <el-date-picker
        v-model="queryForm.rangeTime"
        type="daterange"
        range-separator="~"
        start-placeholder="开始日期"
        end-placeholder="结束日期">
      </el-date-picker>
    </el-form>
    <div class="main">
      <div class="add-button">
        <el-button type="primary" size="medium" @click="handleAdd">+ 新建项目</el-button>
      </div>
      <div class="content">
        <!-- 表格 -->
        <el-table
          :data="tableData"
          style="width: 100%"
          :header-cell-style="{background:'#fafafa',color:'#606266','text-align': 'center'}"
          :cell-style="{'text-align':'center'}"
        >
          <el-table-column prop="project_name" label="项目名称" width="150" :show-overflow-tooltip="true"></el-table-column>
          <el-table-column prop="description" label="项目描述" width="200" :show-overflow-tooltip="true"></el-table-column>
          <el-table-column prop="config" label="检索demo配置" width="180"></el-table-column>
          <el-table-column prop="createTime" label="创建时间" width="180">
            <!-- <template slot-scope="scope">
              <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
            </template> -->
          </el-table-column>
          <el-table-column prop="status" label="状态" width="200">
            <template slot-scope="scope">
              <i :class="`tab_status${approveBgc(scope.row.status)}`"></i>
              {{scope.row.status}}
            </template>
          </el-table-column>
          <el-table-column fixed="right" label="操作">
            <template slot-scope="scope">
              <el-button @click="handleClick(scope.row)" type="text" size="small">查看</el-button>
              <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
              <el-button @click.native.prevent="deleteRow(scope.$index, tableData)" type="text" size="small">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <!-- 弹框 -->
        <Dialog
          ref="dialog"
          :receiveOpen="receiveOpen"
          :editData = "editJSON"
          @dialogClose="dialogClose"
        />

        <!-- 分页 -->
          <!-- <pagination
            v-show="total > 0"
            :total="total"
            :page.sync="queryForm.pn"
            :limit.sync="queryForm.ps"
            @pagination="handleQuery"
            class="pagination"
          /> -->
      </div>
    </div>
  </div>
</template>
<script>
import Dialog from '../../components/Dialog.vue'
// import {getList, addProduct, editProduct, delProduct} from '@api/product/list.js'
export default {
  components: { Dialog },
  data () {
    return {
      editJSON: {},
      receiveOpen: false,
      // 总条数
      total: 0,
      // isEdit: false,
      // searchDemo: false,
      // 顶部检索选择
      options: [
        {value: '选项1', label: '项目名称'},
        {value: '选项2', label: '项目描述'},
        {value: '选项3', label: '检索demo配置'},
        {value: '选项4', label: '状态'}
      ],
      queryForm: {
        pn: 1,
        ps: 10,
        search_condition_type: '全部',
        rangeTime: [],
        search_condition_value: '' // 检索值
      },
      // 表格假数据
      tableData: [
        {
          project_name: '项目1',
          description: '这个是一个1111111111111111111111111111项目',
          config: '配置**',
          createTime: '2016-05-02',
          status: '构建完成'
        },
        {
          project_name: '项目2',
          description: '这个是一个***项目',
          config: '配置**',
          createTime: '2016-05-02',
          status: '状态1'
        },
        {
          project_name: '项目3',
          description: '这个是一个***项目',
          config: '配置**',
          createTime: '2016-05-02',
          status: '状态1'
        },
        {
          project_name: '项目4',
          description: '这个是一个***项目',
          config: '配置**',
          createTime: '2016-05-02',
          status: '状态1'
        },
        {
          project_name: '项目5',
          description: '这个是一个***项目',
          config: '配置**',
          createTime: '2016-05-02',
          status: '状态1'
        },
        {
          project_name: '项目6',
          description: '这个是一个***项目',
          config: '配置**',
          createTime: '2016-05-02',
          status: '状态1'
        },
        {
          project_name: '项目7',
          description: '这个是一个***项目',
          config: '配置**',
          createTime: '2016-05-02',
          status: '状态1'
        }
      ],
      colorClass: {
        草稿: 'bg-stop',
        已提交: 'bg-sub',
        建库中: 'bg-ing',
        构建中: 'bg-ing',
        构建完成: 'bg-pass',
        解析异常: 'bg-reject'
      }
    }
  },
  created () {
    this.init()
    this.handleQuery()
  },
  methods: {
    init () {
      // 内容库
      // datasetsAPI ().then((res) => {
      //   if (res.code == '200') {
      //     this.datasets = res.data;
      //   }
      // })
    },
    approveBgc (statue) {
      const bgc = this.colorClass[statue] || ''
      if (bgc) return ` ${bgc}`
      return ''
    },
    // 搜索
    handleQuery () {
      console.log('1111')
      // getList(this.queryForm).then(res => {
      //   if (res.code === '200') {
      //     this.queryParams.pn = 1
      //     this.total = res.total
      //     this.tableData = res.rows
      //   }
      // })
    },
    // 查看
    handleClick () {
      this.$router.push('/product/detail')
    },
    // 弹框
    dialogClose () {
      this.receiveOpen = false
      // this.editJSON = {}
    },
    // 新增
    handleAdd () {
      console.log('打开新增弹窗')
      // this.resetBtn()
      this.receiveOpen = true
      this.$refs['dialog'].addBtn = false
      this.$refs['dialog'].title = '新增项目'
      // this.title = '新建项目'
      // this.isEdit = false
    },
    // 编辑
    // handleEdit (row) {
    handleEdit (e) {
      console.log('打开编辑弹窗')
      this.editJSON = e
      this.receiveOpen = true
      this.$refs['dialog'].addBtn = true // 为编辑页时，显示提交按钮
      this.$refs['dialog'].title = '编辑项目'
      // this.resetBtn()
      // this.title = '编辑项目'
      // this.isEdit = true
      // this.ruleForm = JSON.parse(JSON.stringify(row))
    },
    // 删除
    deleteRow (index, rows) {
      this.$confirm(
        '是否确认删除', '警告',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )
        .then(() => {
          rows.splice(index, 1)
          // delProduct({id: rows.id}).then(() => {
          //   this.$message.success('删除成功')
          //   this.handleQuery()
          // })
        })
        .catch(() => {})
    }
    // 重置
    // resetBtn () {
    //   this.ruleForm = {
    //     project_name: undefined,
    //     description: undefined,
    //     datasets: undefined,
    //     config: undefined,
    //     searchDemo: undefined,
    //     searchModel: undefined
    //   }
    //   // this.resetForm("ruleForm");
    //   // this.$refs.ruleForm.resetFields()
    // },
    // 弹框关闭并请求查询
    // tabData (val) {
    //   this.receiveOpen = false
    //   this.$refs['dialog'].handleResetForm()
    //   this.handleQuery()
    // }
  }
}
</script>

<style lang="less" scoped>
@background: #fff;
.top {
  display: flex;
  justify-content: space-between;
  background: @background;
  padding: 20px 20px 0px;
}

.add-button {
  border: 1px solid #ddd;
  padding:16px 20px;
  background: @background;
}
.main {
  padding: 14px;
}
.content {
  border: 1px solid #ddd;
  border-top: 0;
}
.pagination {
  padding: 20px;
  background: @background;
}
/deep/ .el-dialog {
  padding: 14px;
}
.tab_status {
  display: inline-block;
  width: 7px;
  height: 7px;
  border-radius: 7px;
  margin-right: 5px;
}

// .el-form-item__content {
//   position: relative;
// }
// .el-button--info.is-plain {
//   position:absolute;
//   top: 0;
//   right: 0;
// }

</style>
