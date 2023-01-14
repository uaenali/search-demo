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
          <el-table-column prop="status" label="状态" width="200" :formatter="statusFormat">
            <!-- <template slot-scope="scope">
              <dict-tag :options="statusOptions" :value="scope.row.status"/>
            </template> -->
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
        <el-dialog :title="title" :visible.sync="open" width="50%" class="iframe-dialog" append-to-body>
          <el-form ref="ruleForm" :model="ruleForm" :rules="rules" label-width="80px" class="demo-form">
            <el-form-item label="项目标题" prop="project_name">
              <el-input v-model="ruleForm.project_name" placeholder="请输入" clearable />
            </el-form-item>
            <el-form-item label="项目描述" prop="description">
              <el-input
                v-model="ruleForm.description"
                placeholder="请输入"
                type="textarea"
                maxlength="100"
                rows="5"
                show-word-limit
              />
            </el-form-item>
            <el-form-item>
              <el-button v-if="isEdit" type="primary" size="medium">提交</el-button>
            </el-form-item>

            <div class="datasets">
              <el-form-item label="数据集" prop="datasets">
                <el-input v-model="ruleForm.datasets" placeholder="请输入" filterable clearable style="width:115px;"/>
                <!-- 下拉列表 -->
                <el-select
                  v-model="ruleForm.datasets"
                  placeholder="请选择"
                  filterable
                  clearable
                  style="width:115px;"
                >
                  <el-option
                    v-for="(item,index) in datasetsList"
                    :key="index"
                    :label="item.label"
                    :value="item.value"
                    size="small"
                  ></el-option>
              </el-select>
                <el-button type="info" plain icon="el-icon-search" style="margin-bottom: 10px;">内容库</el-button>
                <el-upload
                  class="upload-demo"
                  action="https://jsonplaceholder.typicode.com/posts/"
                  :on-change="handleChange"
                  :file-list="fileList">
                  <el-button type="info" plain icon="el-icon-upload">手动上传</el-button>
                </el-upload>
              </el-form-item>
            </div>
            <el-form-item label="检索配置" prop="config">
              <el-table
                ref="multipleTable"
                :data="modelData"
                border
                :header-cell-style="{background:'#fafafa',color:'#606266','text-align': 'center'}"
                :cell-style="{'text-align':'center'}"
              >
                <el-table-column label="检索Demo" width="240" prop="searchDemo">
                  <template slot-scope="scope">
                    <!-- 综合检索 -->
                    <el-checkbox>{{scope.row.searchDemo}}</el-checkbox>
                  </template>
                </el-table-column>
                <el-table-column label="检索模型" prop="searchModel">
                  <template slot-scope="scope">
                    <el-select
                      size="small"
                      v-model="scope.row.searchModel"
                      placeholder="请选择"
                      filterable
                      clearable
                    >
                      <el-option
                        v-for="item in scope.row.modelList"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                      >
                      </el-option>
                    </el-select>
                  </template>
                </el-table-column>
              </el-table>
            </el-form-item>
          </el-form>
          <!-- 底部 -->
          <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitForm">确定建库</el-button>
            <el-button @click="stage">暂存</el-button>
          </div>
        </el-dialog>
        <!-- 分页 -->
          <!-- <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="currentPage4"
            :page-sizes="[100, 200, 300, 400]"
            :page-size="100"
            layout="->,total, sizes, prev, pager, next, jumper"
            :total="400">
          </el-pagination> -->
          <pagination
            v-show="total > 0"
            :total="total"
            :page.sync="queryForm.pn"
            :limit.sync="queryForm.ps"
            @pagination="handleQuery"
            class="pagination"
          />
      </div>
    </div>
  </div>
</template>
<script>
// import {getList, addProduct, editProduct, delProduct} from '@api/product/list.js'
export default {
  data () {
    return {
      // 总条数
      total: 0,
      isEdit: false,
      searchDemo: false,
      // 上传
      fileList: [{
        name: 'food.jpeg',
        url: 'https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg?imageMogr2/thumbnail/360x360/format/webp/quality/100'
      }, {
        name: 'food2.jpeg',
        url: 'https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg?imageMogr2/thumbnail/360x360/format/webp/quality/100'
      }],
      options: [
        {value: '选项1', label: '项目名称'},
        {value: '选项2', label: '项目描述'},
        {value: '选项3', label: '检索demo配置'},
        {value: '选项4', label: '状态'}
      ],
      // 内容库下拉列表
      datasetsList: [
        {value: '1', label: '直流数据库'},
        {value: '2', label: '知识库'}
      ],
      queryForm: {
        pn: 1,
        ps: 10,
        search_condition_type: '全部',
        rangeTime: [],
        search_condition_value: '' // 检索值
      },
      currentPage4: 4,
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
      // 弹框
      ruleForm: {
        project_name: '',
        description: '',
        datasets: '',
        config: '',
        searchDemo: '',
        checked: [],
        searchModel: ''
      },
      // 弹窗标题
      title: '',
      // 是否显示弹出层
      open: false,
      // 表单校验
      rules: {
        project_name: [{ required: true, message: '必填字段项目标题未填写,无法提交', trigger: 'blur' }],
        description: [{ required: true, message: '不能为空', trigger: 'blur' }],
        datasets: [{ required: true, message: '不能为空', trigger: 'blur' }]
        // config: [{ required: true, message: '不能为空', trigger: 'blur' }]
      },
      modelData: [
        {
          searchDemo: 'comprehensive',
          modelList: [
            {value: '1', label: '内容检索V1'},
            {value: '2', label: '内容检索V2'}
          ]
        },
        {
          searchDemo: 'summary',
          modelList: [
            {value: '1', label: '内容检索V1'},
            {value: '2', label: '内容检索V2'}
          ]
        }
      ]
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
    // 公告状态字典翻译
    statusFormat (row, column) {
    //   return this.selectDictLabel(this.statusOptions, row.status)
    },
    // handleSizeChange (val) {
    //   console.log(`每页 ${val} 条`)
    // },
    // handleCurrentChange (val) {
    //   console.log(`当前页: ${val}`)
    // },
    // upload
    handleChange (file, fileList) {
      this.fileList = fileList.slice(-3)
    },
    // 重置
    resetBtn () {
      this.ruleForm = {
        project_name: undefined,
        description: undefined,
        datasets: undefined,
        config: undefined,
        searchDemo: undefined,
        searchModel: undefined
      }
      // this.resetForm("ruleForm");
      // this.$refs.ruleForm.resetFields()
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
    // 新增
    handleAdd () {
      this.resetBtn()
      this.title = '新建项目'
      this.isEdit = false
      this.open = true
    },
    // 查看
    handleClick () {
      this.$router.push('/product/detail')
    },
    // 编辑
    handleEdit (row) {
      this.resetBtn()
      this.title = '编辑项目'
      this.isEdit = true
      this.ruleForm = JSON.parse(JSON.stringify(row))
      this.open = true
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
    },
    // 确定建库
    submitForm () {
      // 校验
      this.$refs.ruleForm.validate(valid => {
        console.log(valid)
        if (!valid) {
          this.$message.error('必填字段项目标题未填写,无法提交')
          return
        }
        const request = this.isEdit ? this.editProduct : this.addProduct
        request(this.ruleForm).then(() => {
          this.handleQuery()
        })
        this.open = false
      })
    },
    // 暂存
    stage () {
      this.open = false
      this.resetBtn()
    }
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

// .el-form-item__content {
//   position: relative;
// }
// .el-button--info.is-plain {
//   position:absolute;
//   top: 0;
//   right: 0;
// }

</style>
