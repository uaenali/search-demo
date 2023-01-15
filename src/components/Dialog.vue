<template>
  <el-dialog :title="title" :visible.sync="queryOpen" width="50%" :before-close="handleClose">
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
        <el-button v-if="addBtn" type="primary" size="medium">提交</el-button>
      </el-form-item>

      <div class="datasets">
        <el-form-item label="数据集" prop="datasets">
          <!-- 下拉列表 -->
          <el-select
            v-model="ruleForm.datasets"
            placeholder="请输入"
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
        <el-table-column width="55">
          <template slot-scope="scope">
            <el-checkbox v-model="modelData[scope.$index].isDelete"></el-checkbox>
          </template>
        </el-table-column>
        <el-table-column label="检索Demo" width="240" prop="searchDemo">
            综合检索
            <!-- <template slot-scope="scope">
              <el-checkbox border>{{scope.row.searchDemo}}</el-checkbox>
            </template> -->
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
</template>
<script>
export default {
  props: ['receiveOpen', 'editData'],
  data () {
    return {
      restaurants: [],
      // 编辑页提交按钮
      addBtn: false,
      // 弹窗标题
      title: '',
      // 弹框是否显示
      queryOpen: this.receiveOpen,
      // open: false,
      // 查询参数
      ruleForm: {
        state: '',
        project_name: '',
        description: '',
        datasets: '',
        config: '',
        searchDemo: '',
        checked: [],
        searchModel: ''
      },
      // 表单校验
      rules: {
        project_name: [{ required: true, message: '必填字段项目标题未填写,无法提交', trigger: 'blur' }],
        description: [{ required: true, message: '不能为空', trigger: 'blur' }],
        datasets: [{ required: true, message: '不能为空', trigger: 'blur' }]
        // config: [{ required: true, message: '不能为空', trigger: 'blur' }]
      },
      // 上传
      fileList: [{
        name: 'food.jpeg',
        url: 'https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg?imageMogr2/thumbnail/360x360/format/webp/quality/100'
      }, {
        name: 'food2.jpeg',
        url: 'https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg?imageMogr2/thumbnail/360x360/format/webp/quality/100'
      }],
      // 内容库下拉列表
      datasetsList: [
        {value: '1', label: '直流数据库'},
        {value: '2', label: '知识库'}
      ],
      // 弹窗中表单假数据
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
  watch: {
    receiveOpen (val) {
      this.queryOpen = val
    },
    // 修改
    editData (val) {
      this.ruleForm = JSON.parse(JSON.stringify(val))
    }
  },
  methods: {
    // 弹窗关闭
    handleClose () {
      this.queryOpen = false
      this.$emit('fatherClose')
    },
    // upload
    handleChange (file, fileList) {
      this.fileList = fileList.slice(-3)
    },
    // 确定建库
    submitForm () {
      // 校验
      this.$refs.ruleForm.validate(valid => {
        console.log(valid)
        if (valid) {
        //   if (this.modelType === 0) {
        //     addList(this.ruleForm).then(() => {
        //       this.handleQuery()
        //     })
        //     // 如果状态 是0为新增，1为编辑，编辑时要深拷贝
        //   } else {
        //     editList(this.ruleForm).then(() => {
        //       this.handleQuery()
        //     })
        //   }
          // 清空表单数据
          this.queryOpen = false
          // this.$refs.ruleForm.resetFields()
          this.handleQuery()
        } else {
          this.$message.error('必填字段项目标题未填写,无法提交')
          return false
        }
        // if (!valid) {
        //   this.$message.error('必填字段项目标题未填写,无法提交')
        //   return
        // }
        // const request = this.isEdit ? this.editProduct : this.addProduct
        // request(this.ruleForm).then(() => {
        //   this.handleQuery()
        // })
        this.queryOpen = false
      })
    },
    // 暂存
    stage () {
      this.queryOpen = false
      // this.resetBtn()
    }
  }
}
</script>
