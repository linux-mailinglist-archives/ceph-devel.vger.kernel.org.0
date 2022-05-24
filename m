Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFEF533092
	for <lists+ceph-devel@lfdr.de>; Tue, 24 May 2022 20:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240394AbiEXSjp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 May 2022 14:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiEXSjo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 May 2022 14:39:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B686D58385
        for <ceph-devel@vger.kernel.org>; Tue, 24 May 2022 11:39:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIdKrG001831;
        Tue, 24 May 2022 18:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=oVMjZEcQxOP7ZlophJDJF3JEt/WKC4YiKHevkwEAKzI=;
 b=IgIRMvsFiC5GLhlN0BPiDNSFRm4v11cMO55q9FQ2V6A60ZTrh84VIG3F7BnTRfVGmDVM
 qfLnIRWjoPPxvv5zocqrVLm2YMKOzaHkMtxaGCXcy/HihdlZNjC20dgE3SvwVPh6ines
 5ue1PdQwBpPVGY/U0YCxrNqUSlGfvkH3k4nOtNFhlf4rxXy6AdOTSCGtiyQ1uFUYgmIn
 pyEBIJV6qzavzjxoL9Vmqab0zw8jzMq0YFxq+BJX+Ewu9bJPRBVHuV95wK5EgPYki8MQ
 i2u1vEVw+QNnIQPQ2gq0iUaWC+EmEXUBtoqNaYQLoUHqEBajK3ZiI3hbQxWOl9V/A/Ry fg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93t9r63q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:39:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OIaL3n035354;
        Tue, 24 May 2022 18:39:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x51f8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:39:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnS1t0DBJtCSbGgG6T9DF/F2hKIXcsbG8rgIJuOCOr9r6ECL7A3PjmJjSt8RI3k+Uxk0pjafAhR+4Hy71/XbZb7CAny0t8X593wpX1KGugCwX6aZ8U/yB0WOvS0ZkniYfOUdFaCuO6eNwmk0y+DkABJP068Xqw1oFbOciBm+rnlGAhp9oBX/SOQj1O4Bocq2AvnUmvbLYN3c8c8+gKpRlBPXZizY3/WioZhq2QniZiyg/qntiQpp4r9im/wYysigORkHdfFkGQbPSf8S0TW7zkNGZ2p//lulYUn+LPyLqgrg+s1Fs0QpUbxYF9zJbRcFnVeeiMSDwPc7y3i514mU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVMjZEcQxOP7ZlophJDJF3JEt/WKC4YiKHevkwEAKzI=;
 b=ElIa/AiLFCYC2nGCKJ6GYdGfbr9TM8afsCkH52sEiz7Lh+kUV6gS3ENhWfG/IjdqhrZ52a8FgkiMSmUzTvHzTkkzYIDyPpQTMBrAqPriMUbaJ5FeBqpW1Rp+qV+38R0N2ozYqaMFPRnudpEILmRxaMaHdcZ3x6V/G4g0/ZX5oafWfYbFeUV9AVb1XmywHKTKFxnNugCE6B83xQ7XERbjVyVzPkeGR1LAr3N688zqe3LMmdZaFkIsSGkjPd51KEvDWAYUxUQj0BzyMWmjF5X8CspP9v+zobO7lNbPWZ1b/6ldDioBsTXEqAUy824cpfDNqmlPc6Ml44garAAPLztEKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVMjZEcQxOP7ZlophJDJF3JEt/WKC4YiKHevkwEAKzI=;
 b=YUIOd/QTcz5JgeChlN4+f2a5eda30NiHa5zsRafV9cku6m7JQt4T4zz8evMhLzma4nkzQVMp7aH9iOYaxcZAFF6NH7lI/x5LWMW8bgfyaTFCxLOY19Ahh7k0Feki3/GOSYGLlTlr983k3oP36slmqwNE4CF0jK6uXjBOVbWfwAg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB2891.namprd10.prod.outlook.com
 (2603:10b6:5:61::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Tue, 24 May
 2022 18:39:29 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:39:29 +0000
Date:   Tue, 24 May 2022 21:39:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Jeff Layton <jlayton@kernel.org>
Cc:     lkp@intel.com, kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:wip-fscrypt 53/64] fs/ceph/file.c:1896
 ceph_sync_write() error: uninitialized symbol 'assert_ver'.
Message-ID: <202205250038.pULlmpTX-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e9f73cc-23a3-49e0-9b04-08da3db4bbcb
X-MS-TrafficTypeDiagnostic: DM6PR10MB2891:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2891FF805F73DBD486140C708ED79@DM6PR10MB2891.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86UvjC0GW4aY7/ZLZ5eX+6/nKhGfTsvf+viqtIRBHguqcl6Lgutb3W4AEDGdzEDDy8B06qVB0/dsSlEDwHmPouZ6Kxpx6sxhG4tm9NjT8GLuLU5l5NApnAYqpUDS7xVQokJWtIa9bwEUHfuvk8aoFyikOqIu4WiDFH6Sy4TSv8jh2fUHYWB7zPFnc6l6SHNVa1yVgpa9cEHrx82oCuQyakGV3IlBUJeYGVI6TPhmIOe67+dCf7wiFn9nkrB/8cgegklkCttmyWplZr/ll+EDOzDNd2440oOvSYpb0Yl6NuDPCZhb45CkZ9GE0i4VJU27Q3iNcf240do+i6EqQF+1zTuB3ZLonukCyT6AvMFnCdaDAfhmvN0f+ErPoC5kdhtlCQTtWl3CGu3nkr9DGfLE2MpaUEz1+M6Gx+QJ/Joo5GiMhCmy7UmWqOVtSXn49a96qG/MeI/PufhdKZjer1o6jUjpjq69WuOyJ9yvfjiLE5d3BYdToGum+Zd4vCr9hVYpA60n3pUoMGvmFxBSDmb476sKfNPKgVCqZnd6XRPBn26qNmvvMuVcsQP5jydCx1dQhXW/DnGZzogufLWC8FCeZrvqnRvjNc5DvK/uJROo4wXiIm0vdkSyqjGsrzIozOQ2PKsVV5r01usma+QDNtFvON2hIs03o98yCnqYRx3FnHiIcRTl5sXQl7HP8VvTLdHaFqaj4dOsiYj2lq9UfSxFsGGJpnTyjvWsZND6izNaTLfbemJFNha6shAx1dkm5icW4bvaWguYBigDCsNmdU2PRciOLH+4w/qGgnf8tMt0s/S5i1Bv4DUnecXLc9iKc3/RE2A4bb9cFz0iymdVUbeQ+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(8936002)(83380400001)(30864003)(44832011)(6666004)(966005)(6486002)(5660300002)(508600001)(86362001)(26005)(38350700002)(9686003)(52116002)(38100700002)(316002)(36756003)(6512007)(8676002)(4326008)(1076003)(186003)(66556008)(66946007)(66476007)(6506007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?suix5YMMBjK0cdtnLLZomeT5ctS82bSu9ym9z5HYpn4OyZ9P1Dom8f8DLHLe?=
 =?us-ascii?Q?ovFc88IjsTO7h6cbNoS667OpB1MrC9sRn0iueRiuKHKUCO4lVnDh5O4PX2a5?=
 =?us-ascii?Q?eYH5M964Ky7aAWFfqaEQDvfYGDd8ph7KF0deyWYHqe9bPFjOH8uDxJgTEEOF?=
 =?us-ascii?Q?yPWhWuR9J1aIp17H2pN4RqVgfR4xHYY2S5dMY9MbJ40C6qH1XGBsoDm8KkUV?=
 =?us-ascii?Q?jTcsu6fNwsjYSduWc746l/rhvdLU2nrTTEeB2HhqUUgp3mnFKJjCv7F03hcH?=
 =?us-ascii?Q?9EArWojqyM1nVyHNVQgnbcz+xflnXSlGwBEJ9Otd/mObIv3H8o0H8rcWqNPo?=
 =?us-ascii?Q?TTBJf60oW93orqH+fM196gxIX6z2ZOV15g7AROv+92CIh5b01F6CcdsOhMno?=
 =?us-ascii?Q?S+o16x4PD1AyrfSThOruDNUilGaL0uZRq7r7RY/Hi2IgXsIsiuoJqluEUNBP?=
 =?us-ascii?Q?ts4MkCJcJhh37k81QBt0khyGA9cXnbsPoPMjM06y786svzAlT6uwIx9mqCCp?=
 =?us-ascii?Q?V19yEmgatc6TYl4EDAzm7xVtjAPPKwJmFW3HH3wATY1wpQ4I/ldr9A4VcGbu?=
 =?us-ascii?Q?ZI7bx/2cU6jPso0nEHCJa6G7C84KVn/DaG5SraOtMolnO6upWrjIGZ8pVKuW?=
 =?us-ascii?Q?A23Od196kvLH7aaAthB7JcJCmj99KMrM6eaJtsCttVNQXmTgxkmqnh8z6+Mz?=
 =?us-ascii?Q?vLg7HSgmpLxqlQ97FoRMG3nORHyW0HybTsIE0n1N2bDCEIeUoMTvVw4go5UG?=
 =?us-ascii?Q?meYSbL6EGfdpZ1UPOF89G3i3h+ZHkqewXDCR+SOX/bLdwvKEXfANCYP1GQ3k?=
 =?us-ascii?Q?SR7iQrvMJv1SmSLsDy91ifcy3YBqFUDiUTowVgL5I1HPuAeagbn4l9+zGons?=
 =?us-ascii?Q?VLbzRS9G7PZFzrTsbvvh7ZxgNNau/aqIjuBfuBTBAyM/nKX7B878tHd20f/i?=
 =?us-ascii?Q?cM6/h7U+uCOd9pouvx6VZ+GVzzOxgwwPcucAI3br2j38R6SxOhShLfv/aN3Z?=
 =?us-ascii?Q?uIlE5sr9DsxM8HiZJ3Sy29nTdTClno11XDaKNELzmz3kZnkBy0nBJNK8lJC3?=
 =?us-ascii?Q?8nYCzrdxMydnsKNz/TKzXXGc63L/jZDG1cQ5lrBY21wWeFk7IGQTh3+ht3ay?=
 =?us-ascii?Q?oWYUKscEpFNNtEjRpe9tQOAPowuspVwO1TWTWeN0i1e5XJnLJy7DoVC0shu/?=
 =?us-ascii?Q?fjiLj/JmziniQCVlstfW+DLM57SB72xY3s5UvPjXWwuLziw6EPoXtd2K3GQM?=
 =?us-ascii?Q?7KDbaLocPCnMzacJRyi8k2LAbOhpdjJ4elR19ljQzLKfnu8XygLWHgaFglvh?=
 =?us-ascii?Q?WM+6bxnE45yFjsedZ7liRMCJ5EfWubUhPhr+fl6yqwWa9p6VSL4wwtLAMDXl?=
 =?us-ascii?Q?cTRSRw056pOwJF3zASKueiL3IwjPiYoSW4KDnLUn0QIKPW5Zk7QWNo9ovInS?=
 =?us-ascii?Q?wRVJ7GNWmnnzdPjfU9BVTL3q61gtJ1gTpwoJuR3xRapD9kRX4wKDm5f6v+G+?=
 =?us-ascii?Q?l9eHySCBK9eAUpGT65groZds3kxaZx6Nr7tA6KQrJRQOvwClHfTCSR/2cV98?=
 =?us-ascii?Q?lSws6xoR2mkKwF8WOOKFth/ob4ePzIPJjNc322eYLoKVmZ7kngwMoRm4ROZT?=
 =?us-ascii?Q?ke8UkXpADihbHnvi70919STcyWxBIQjT5K+xOCnSOE4M79gB/SJL4YzN5wkg?=
 =?us-ascii?Q?9CR2QJoMCBmLm1S8v/Bf9GoVnSVQgiXhpE0a5i7MyFeCuZo3FvnBdYpngTfP?=
 =?us-ascii?Q?NUxN9U0N+5iGRZIjVAEBSSA/KjxQNz4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9f73cc-23a3-49e0-9b04-08da3db4bbcb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:39:29.1061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHXdCGAPYqfiPUfvxUZHLbb0ulbtj7NGLj2hAcr/H1xiV0D2HcHed2P3Jve5QnLsjw0ZVg06FNr5UJOXTALIMnWs+wc0j8lrDGOQLcEFl1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2891
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_07:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205240091
X-Proofpoint-ORIG-GUID: d3Mvtg1FmYQZgIclE9LjEy8p4dWsiNVj
X-Proofpoint-GUID: d3Mvtg1FmYQZgIclE9LjEy8p4dWsiNVj
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git wip-fscrypt
head:   9ab30a676da19ce5d83364306a03d643dd446aca
commit: 6341655663fe166fd30acca6b4e692d2fafb02e5 [53/64] ceph: add read/modify/write to ceph_sync_write
config: microblaze-randconfig-m031-20220524 (https://download.01.org/0day-ci/archive/20220525/202205250038.pULlmpTX-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.3.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
fs/ceph/file.c:1896 ceph_sync_write() error: uninitialized symbol 'assert_ver'.

Old smatch warnings:
fs/ceph/file.c:146 iter_get_bvecs_alloc() warn: Please consider using kvcalloc instead of kvmalloc_array

vim +/assert_ver +1896 fs/ceph/file.c

06fee30f6a31f10 Yan, Zheng         2014-07-28  1550  static ssize_t
5dda377cf0a6bd4 Yan, Zheng         2015-04-30  1551  ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
5dda377cf0a6bd4 Yan, Zheng         2015-04-30  1552  		struct ceph_snap_context *snapc)
e8344e668915a74 majianpeng         2013-09-12  1553  {
e8344e668915a74 majianpeng         2013-09-12  1554  	struct file *file = iocb->ki_filp;
e8344e668915a74 majianpeng         2013-09-12  1555  	struct inode *inode = file_inode(file);
e8344e668915a74 majianpeng         2013-09-12  1556  	struct ceph_inode_info *ci = ceph_inode(inode);
e8344e668915a74 majianpeng         2013-09-12  1557  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
6341655663fe166 Jeff Layton        2021-01-27  1558  	struct ceph_osd_client *osdc = &fsc->client->osdc;
e8344e668915a74 majianpeng         2013-09-12  1559  	struct ceph_osd_request *req;
e8344e668915a74 majianpeng         2013-09-12  1560  	struct page **pages;
e8344e668915a74 majianpeng         2013-09-12  1561  	u64 len;
e8344e668915a74 majianpeng         2013-09-12  1562  	int num_pages;
e8344e668915a74 majianpeng         2013-09-12  1563  	int written = 0;
e8344e668915a74 majianpeng         2013-09-12  1564  	int ret;
efb0ca765ac6f49 Yan, Zheng         2017-05-22  1565  	bool check_caps = false;
fac02ddf910814c Arnd Bergmann      2018-07-13  1566  	struct timespec64 mtime = current_time(inode);
4908b822b300d2d Al Viro            2014-04-03  1567  	size_t count = iov_iter_count(from);
e8344e668915a74 majianpeng         2013-09-12  1568  
e8344e668915a74 majianpeng         2013-09-12  1569  	if (ceph_snap(file_inode(file)) != CEPH_NOSNAP)
e8344e668915a74 majianpeng         2013-09-12  1570  		return -EROFS;
e8344e668915a74 majianpeng         2013-09-12  1571  
1c0a9c2d9783604 Yan, Zheng         2017-08-16  1572  	dout("sync_write on file %p %lld~%u snapc %p seq %lld\n",
1c0a9c2d9783604 Yan, Zheng         2017-08-16  1573  	     file, pos, (unsigned)count, snapc, snapc->seq);
e8344e668915a74 majianpeng         2013-09-12  1574  
e450f4d1a5d633d zhengbin           2019-02-01  1575  	ret = filemap_write_and_wait_range(inode->i_mapping,
e450f4d1a5d633d zhengbin           2019-02-01  1576  					   pos, pos + count - 1);
e8344e668915a74 majianpeng         2013-09-12  1577  	if (ret < 0)
e8344e668915a74 majianpeng         2013-09-12  1578  		return ret;
e8344e668915a74 majianpeng         2013-09-12  1579  
400e1286c0ec3fd Jeff Layton        2021-12-07  1580  	ceph_fscache_invalidate(inode, false);
e8344e668915a74 majianpeng         2013-09-12  1581  	ret = invalidate_inode_pages2_range(inode->i_mapping,
09cbfeaf1a5a67b Kirill A. Shutemov 2016-04-01  1582  					    pos >> PAGE_SHIFT,
e450f4d1a5d633d zhengbin           2019-02-01  1583  					    (pos + count - 1) >> PAGE_SHIFT);
e8344e668915a74 majianpeng         2013-09-12  1584  	if (ret < 0)
e8344e668915a74 majianpeng         2013-09-12  1585  		dout("invalidate_inode_pages2_range returned %d\n", ret);
e8344e668915a74 majianpeng         2013-09-12  1586  
4908b822b300d2d Al Viro            2014-04-03  1587  	while ((len = iov_iter_count(from)) > 0) {
e8344e668915a74 majianpeng         2013-09-12  1588  		size_t left;
e8344e668915a74 majianpeng         2013-09-12  1589  		int n;
6341655663fe166 Jeff Layton        2021-01-27  1590  		u64 write_pos = pos;
6341655663fe166 Jeff Layton        2021-01-27  1591  		u64 write_len = len;
6341655663fe166 Jeff Layton        2021-01-27  1592  		u64 objnum, objoff;
6341655663fe166 Jeff Layton        2021-01-27  1593  		u32 xlen;
6341655663fe166 Jeff Layton        2021-01-27  1594  		u64 assert_ver;
6341655663fe166 Jeff Layton        2021-01-27  1595  		bool rmw;
6341655663fe166 Jeff Layton        2021-01-27  1596  		bool first, last;
6341655663fe166 Jeff Layton        2021-01-27  1597  		struct iov_iter saved_iter = *from;
6341655663fe166 Jeff Layton        2021-01-27  1598  		size_t off;
e8344e668915a74 majianpeng         2013-09-12  1599  
6341655663fe166 Jeff Layton        2021-01-27  1600  		ceph_fscrypt_adjust_off_and_len(inode, &write_pos, &write_len);
6341655663fe166 Jeff Layton        2021-01-27  1601  
6341655663fe166 Jeff Layton        2021-01-27  1602  		/* clamp the length to the end of first object */
6341655663fe166 Jeff Layton        2021-01-27  1603  		ceph_calc_file_object_mapping(&ci->i_layout, write_pos,
6341655663fe166 Jeff Layton        2021-01-27  1604  						write_len, &objnum, &objoff,
6341655663fe166 Jeff Layton        2021-01-27  1605  						&xlen);
6341655663fe166 Jeff Layton        2021-01-27  1606  		write_len = xlen;
6341655663fe166 Jeff Layton        2021-01-27  1607  
6341655663fe166 Jeff Layton        2021-01-27  1608  		/* adjust len downward if it goes beyond current object */
6341655663fe166 Jeff Layton        2021-01-27  1609  		if (pos + len > write_pos + write_len)
6341655663fe166 Jeff Layton        2021-01-27  1610  			len = write_pos + write_len - pos;
6341655663fe166 Jeff Layton        2021-01-27  1611  
6341655663fe166 Jeff Layton        2021-01-27  1612  		/*
6341655663fe166 Jeff Layton        2021-01-27  1613  		 * If we had to adjust the length or position to align with a
6341655663fe166 Jeff Layton        2021-01-27  1614  		 * crypto block, then we must do a read/modify/write cycle. We
6341655663fe166 Jeff Layton        2021-01-27  1615  		 * use a version assertion to redrive the thing if something
6341655663fe166 Jeff Layton        2021-01-27  1616  		 * changes in between.
6341655663fe166 Jeff Layton        2021-01-27  1617  		 */
6341655663fe166 Jeff Layton        2021-01-27  1618  		first = pos != write_pos;
6341655663fe166 Jeff Layton        2021-01-27  1619  		last = (pos + len) != (write_pos + write_len);
6341655663fe166 Jeff Layton        2021-01-27  1620  		rmw = first || last;
6341655663fe166 Jeff Layton        2021-01-27  1621  
6341655663fe166 Jeff Layton        2021-01-27  1622  		dout("sync_write ino %llx %lld~%llu adjusted %lld~%llu -- %srmw\n",
6341655663fe166 Jeff Layton        2021-01-27  1623  		     ci->i_vino.ino, pos, len, write_pos, write_len, rmw ? "" : "no ");
6341655663fe166 Jeff Layton        2021-01-27  1624  
6341655663fe166 Jeff Layton        2021-01-27  1625  		/*
6341655663fe166 Jeff Layton        2021-01-27  1626  		 * The data is emplaced into the page as it would be if it were in
6341655663fe166 Jeff Layton        2021-01-27  1627  		 * an array of pagecache pages.
6341655663fe166 Jeff Layton        2021-01-27  1628  		 */
6341655663fe166 Jeff Layton        2021-01-27  1629  		num_pages = calc_pages_for(write_pos, write_len);
6341655663fe166 Jeff Layton        2021-01-27  1630  		pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
6341655663fe166 Jeff Layton        2021-01-27  1631  		if (IS_ERR(pages)) {
6341655663fe166 Jeff Layton        2021-01-27  1632  			ret = PTR_ERR(pages);
6341655663fe166 Jeff Layton        2021-01-27  1633  			break;
6341655663fe166 Jeff Layton        2021-01-27  1634  		}
6341655663fe166 Jeff Layton        2021-01-27  1635  
6341655663fe166 Jeff Layton        2021-01-27  1636  		/* Do we need to preload the pages? */
6341655663fe166 Jeff Layton        2021-01-27  1637  		if (rmw) {

"assert_ver" is only initialized when "rmw" is true.


6341655663fe166 Jeff Layton        2021-01-27  1638  			u64 first_pos = write_pos;
6341655663fe166 Jeff Layton        2021-01-27  1639  			u64 last_pos = (write_pos + write_len) - CEPH_FSCRYPT_BLOCK_SIZE;
6341655663fe166 Jeff Layton        2021-01-27  1640  			u64 read_len = CEPH_FSCRYPT_BLOCK_SIZE;
6341655663fe166 Jeff Layton        2021-01-27  1641  			struct ceph_osd_req_op *op;
6341655663fe166 Jeff Layton        2021-01-27  1642  
6341655663fe166 Jeff Layton        2021-01-27  1643  			/* We should only need to do this for encrypted inodes */
6341655663fe166 Jeff Layton        2021-01-27  1644  			WARN_ON_ONCE(!IS_ENCRYPTED(inode));
6341655663fe166 Jeff Layton        2021-01-27  1645  
6341655663fe166 Jeff Layton        2021-01-27  1646  			/* No need to do two reads if first and last blocks are same */
6341655663fe166 Jeff Layton        2021-01-27  1647  			if (first && last_pos == first_pos)
6341655663fe166 Jeff Layton        2021-01-27  1648  				last = false;
6341655663fe166 Jeff Layton        2021-01-27  1649  
6341655663fe166 Jeff Layton        2021-01-27  1650  			/*
6341655663fe166 Jeff Layton        2021-01-27  1651  			 * Allocate a read request for one or two extents, depending
6341655663fe166 Jeff Layton        2021-01-27  1652  			 * on how the request was aligned.
6341655663fe166 Jeff Layton        2021-01-27  1653  			 */
6341655663fe166 Jeff Layton        2021-01-27  1654  			req = ceph_osdc_new_request(osdc, &ci->i_layout,
6341655663fe166 Jeff Layton        2021-01-27  1655  					ci->i_vino, first ? first_pos : last_pos,
6341655663fe166 Jeff Layton        2021-01-27  1656  					&read_len, 0, (first && last) ? 2 : 1,
6341655663fe166 Jeff Layton        2021-01-27  1657  					CEPH_OSD_OP_SPARSE_READ, CEPH_OSD_FLAG_READ,
6341655663fe166 Jeff Layton        2021-01-27  1658  					NULL, ci->i_truncate_seq,
6341655663fe166 Jeff Layton        2021-01-27  1659  					ci->i_truncate_size, false);
e8344e668915a74 majianpeng         2013-09-12  1660  			if (IS_ERR(req)) {
6341655663fe166 Jeff Layton        2021-01-27  1661  				ceph_release_page_vector(pages, num_pages);
e8344e668915a74 majianpeng         2013-09-12  1662  				ret = PTR_ERR(req);
eab87235c0f5979 Al Viro            2014-04-03  1663  				break;
e8344e668915a74 majianpeng         2013-09-12  1664  			}
e8344e668915a74 majianpeng         2013-09-12  1665  
6341655663fe166 Jeff Layton        2021-01-27  1666  			/* Something is misaligned! */
6341655663fe166 Jeff Layton        2021-01-27  1667  			if (read_len != CEPH_FSCRYPT_BLOCK_SIZE) {
6341655663fe166 Jeff Layton        2021-01-27  1668  				ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1669  				ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1670  				ret = -EIO;
6341655663fe166 Jeff Layton        2021-01-27  1671  				break;
6341655663fe166 Jeff Layton        2021-01-27  1672  			}
6341655663fe166 Jeff Layton        2021-01-27  1673  
6341655663fe166 Jeff Layton        2021-01-27  1674  			/* Add extent for first block? */
6341655663fe166 Jeff Layton        2021-01-27  1675  			op = &req->r_ops[0];
6341655663fe166 Jeff Layton        2021-01-27  1676  
6341655663fe166 Jeff Layton        2021-01-27  1677  			if (first) {
6341655663fe166 Jeff Layton        2021-01-27  1678  				osd_req_op_extent_osd_data_pages(req, 0, pages,
6341655663fe166 Jeff Layton        2021-01-27  1679  							 CEPH_FSCRYPT_BLOCK_SIZE,
6341655663fe166 Jeff Layton        2021-01-27  1680  							 offset_in_page(first_pos),
6341655663fe166 Jeff Layton        2021-01-27  1681  							 false, false);
6341655663fe166 Jeff Layton        2021-01-27  1682  				/* We only expect a single extent here */
6341655663fe166 Jeff Layton        2021-01-27  1683  				ret = __ceph_alloc_sparse_ext_map(op, 1);
6341655663fe166 Jeff Layton        2021-01-27  1684  				if (ret) {
6341655663fe166 Jeff Layton        2021-01-27  1685  					ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1686  					ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1687  					break;
6341655663fe166 Jeff Layton        2021-01-27  1688  				}
6341655663fe166 Jeff Layton        2021-01-27  1689  			}
6341655663fe166 Jeff Layton        2021-01-27  1690  
6341655663fe166 Jeff Layton        2021-01-27  1691  			/* Add extent for last block */
6341655663fe166 Jeff Layton        2021-01-27  1692  			if (last) {
6341655663fe166 Jeff Layton        2021-01-27  1693  				/* Init the other extent if first extent has been used */
6341655663fe166 Jeff Layton        2021-01-27  1694  				if (first) {
6341655663fe166 Jeff Layton        2021-01-27  1695  					op = &req->r_ops[1];
6341655663fe166 Jeff Layton        2021-01-27  1696  					osd_req_op_extent_init(req, 1, CEPH_OSD_OP_SPARSE_READ,
6341655663fe166 Jeff Layton        2021-01-27  1697  							last_pos, CEPH_FSCRYPT_BLOCK_SIZE,
6341655663fe166 Jeff Layton        2021-01-27  1698  							ci->i_truncate_size,
6341655663fe166 Jeff Layton        2021-01-27  1699  							ci->i_truncate_seq);
6341655663fe166 Jeff Layton        2021-01-27  1700  				}
6341655663fe166 Jeff Layton        2021-01-27  1701  
6341655663fe166 Jeff Layton        2021-01-27  1702  				ret = __ceph_alloc_sparse_ext_map(op, 1);
6341655663fe166 Jeff Layton        2021-01-27  1703  				if (ret) {
6341655663fe166 Jeff Layton        2021-01-27  1704  					ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1705  					ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1706  					break;
6341655663fe166 Jeff Layton        2021-01-27  1707  				}
6341655663fe166 Jeff Layton        2021-01-27  1708  
6341655663fe166 Jeff Layton        2021-01-27  1709  				osd_req_op_extent_osd_data_pages(req, first ? 1 : 0,
6341655663fe166 Jeff Layton        2021-01-27  1710  							&pages[num_pages - 1],
6341655663fe166 Jeff Layton        2021-01-27  1711  							CEPH_FSCRYPT_BLOCK_SIZE,
6341655663fe166 Jeff Layton        2021-01-27  1712  							offset_in_page(last_pos),
6341655663fe166 Jeff Layton        2021-01-27  1713  							false, false);
6341655663fe166 Jeff Layton        2021-01-27  1714  			}
6341655663fe166 Jeff Layton        2021-01-27  1715  
6341655663fe166 Jeff Layton        2021-01-27  1716  			ret = ceph_osdc_start_request(osdc, req, false);
6341655663fe166 Jeff Layton        2021-01-27  1717  			if (!ret)
6341655663fe166 Jeff Layton        2021-01-27  1718  				ret = ceph_osdc_wait_request(osdc, req);
6341655663fe166 Jeff Layton        2021-01-27  1719  
6341655663fe166 Jeff Layton        2021-01-27  1720  			/* FIXME: length field is wrong if there are 2 extents */
6341655663fe166 Jeff Layton        2021-01-27  1721  			ceph_update_read_metrics(&fsc->mdsc->metric,
6341655663fe166 Jeff Layton        2021-01-27  1722  						 req->r_start_latency,
6341655663fe166 Jeff Layton        2021-01-27  1723  						 req->r_end_latency,
6341655663fe166 Jeff Layton        2021-01-27  1724  						 read_len, ret);
6341655663fe166 Jeff Layton        2021-01-27  1725  
6341655663fe166 Jeff Layton        2021-01-27  1726  			/* Ok if object is not already present */
6341655663fe166 Jeff Layton        2021-01-27  1727  			if (ret == -ENOENT) {
6341655663fe166 Jeff Layton        2021-01-27  1728  				/*
6341655663fe166 Jeff Layton        2021-01-27  1729  				 * If there is no object, then we can't assert
6341655663fe166 Jeff Layton        2021-01-27  1730  				 * on its version. Set it to 0, and we'll use an
6341655663fe166 Jeff Layton        2021-01-27  1731  				 * exclusive create instead.
6341655663fe166 Jeff Layton        2021-01-27  1732  				 */
6341655663fe166 Jeff Layton        2021-01-27  1733  				ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1734  				assert_ver = 0;
6341655663fe166 Jeff Layton        2021-01-27  1735  				ret = 0;
6341655663fe166 Jeff Layton        2021-01-27  1736  
6341655663fe166 Jeff Layton        2021-01-27  1737  				/*
6341655663fe166 Jeff Layton        2021-01-27  1738  				 * zero out the soon-to-be uncopied parts of the
6341655663fe166 Jeff Layton        2021-01-27  1739  				 * first and last pages.
6341655663fe166 Jeff Layton        2021-01-27  1740  				 */
6341655663fe166 Jeff Layton        2021-01-27  1741  				if (first)
6341655663fe166 Jeff Layton        2021-01-27  1742  					zero_user_segment(pages[0], 0,
6341655663fe166 Jeff Layton        2021-01-27  1743  							  offset_in_page(first_pos));
6341655663fe166 Jeff Layton        2021-01-27  1744  				if (last)
6341655663fe166 Jeff Layton        2021-01-27  1745  					zero_user_segment(pages[num_pages - 1],
6341655663fe166 Jeff Layton        2021-01-27  1746  							  offset_in_page(last_pos),
6341655663fe166 Jeff Layton        2021-01-27  1747  							  PAGE_SIZE);
6341655663fe166 Jeff Layton        2021-01-27  1748  			} else {
6341655663fe166 Jeff Layton        2021-01-27  1749  				if (ret < 0) {
6341655663fe166 Jeff Layton        2021-01-27  1750  					ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1751  					ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1752  					break;
6341655663fe166 Jeff Layton        2021-01-27  1753  				}
6341655663fe166 Jeff Layton        2021-01-27  1754  
6341655663fe166 Jeff Layton        2021-01-27  1755  				op = &req->r_ops[0];
6341655663fe166 Jeff Layton        2021-01-27  1756  				if (op->extent.sparse_ext_cnt == 0) {
6341655663fe166 Jeff Layton        2021-01-27  1757  					if (first)
6341655663fe166 Jeff Layton        2021-01-27  1758  						zero_user_segment(pages[0], 0,
6341655663fe166 Jeff Layton        2021-01-27  1759  								  offset_in_page(first_pos));
6341655663fe166 Jeff Layton        2021-01-27  1760  					else
6341655663fe166 Jeff Layton        2021-01-27  1761  						zero_user_segment(pages[num_pages - 1],
6341655663fe166 Jeff Layton        2021-01-27  1762  								  offset_in_page(last_pos),
6341655663fe166 Jeff Layton        2021-01-27  1763  								  PAGE_SIZE);
6341655663fe166 Jeff Layton        2021-01-27  1764  				} else if (op->extent.sparse_ext_cnt != 1 ||
6341655663fe166 Jeff Layton        2021-01-27  1765  					   ceph_sparse_ext_map_end(op) !=
6341655663fe166 Jeff Layton        2021-01-27  1766  						CEPH_FSCRYPT_BLOCK_SIZE) {
6341655663fe166 Jeff Layton        2021-01-27  1767  					ret = -EIO;
6341655663fe166 Jeff Layton        2021-01-27  1768  					ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1769  					ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1770  					break;
6341655663fe166 Jeff Layton        2021-01-27  1771  				}
6341655663fe166 Jeff Layton        2021-01-27  1772  
6341655663fe166 Jeff Layton        2021-01-27  1773  				if (first && last) {
6341655663fe166 Jeff Layton        2021-01-27  1774  					op = &req->r_ops[1];
6341655663fe166 Jeff Layton        2021-01-27  1775  					if (op->extent.sparse_ext_cnt == 0) {
6341655663fe166 Jeff Layton        2021-01-27  1776  						zero_user_segment(pages[num_pages - 1],
6341655663fe166 Jeff Layton        2021-01-27  1777  								  offset_in_page(last_pos),
6341655663fe166 Jeff Layton        2021-01-27  1778  								  PAGE_SIZE);
6341655663fe166 Jeff Layton        2021-01-27  1779  					} else if (op->extent.sparse_ext_cnt != 1 ||
6341655663fe166 Jeff Layton        2021-01-27  1780  						   ceph_sparse_ext_map_end(op) !=
6341655663fe166 Jeff Layton        2021-01-27  1781  							CEPH_FSCRYPT_BLOCK_SIZE) {
6341655663fe166 Jeff Layton        2021-01-27  1782  						ret = -EIO;
6341655663fe166 Jeff Layton        2021-01-27  1783  						ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1784  						ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1785  						break;
6341655663fe166 Jeff Layton        2021-01-27  1786  					}
6341655663fe166 Jeff Layton        2021-01-27  1787  				}
6341655663fe166 Jeff Layton        2021-01-27  1788  
6341655663fe166 Jeff Layton        2021-01-27  1789  				/* Grab assert version. It must be non-zero. */
6341655663fe166 Jeff Layton        2021-01-27  1790  				assert_ver = req->r_version;
6341655663fe166 Jeff Layton        2021-01-27  1791  				WARN_ON_ONCE(ret > 0 && assert_ver == 0);
6341655663fe166 Jeff Layton        2021-01-27  1792  
6341655663fe166 Jeff Layton        2021-01-27  1793  				ceph_osdc_put_request(req);
6341655663fe166 Jeff Layton        2021-01-27  1794  				if (first) {
6341655663fe166 Jeff Layton        2021-01-27  1795  					ret = ceph_fscrypt_decrypt_block_inplace(inode,
6341655663fe166 Jeff Layton        2021-01-27  1796  							pages[0],
6341655663fe166 Jeff Layton        2021-01-27  1797  							CEPH_FSCRYPT_BLOCK_SIZE,
6341655663fe166 Jeff Layton        2021-01-27  1798  							offset_in_page(first_pos),
6341655663fe166 Jeff Layton        2021-01-27  1799  							first_pos >> CEPH_FSCRYPT_BLOCK_SHIFT);
6341655663fe166 Jeff Layton        2021-01-27  1800  					if (ret < 0) {
6341655663fe166 Jeff Layton        2021-01-27  1801  						ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1802  						break;
6341655663fe166 Jeff Layton        2021-01-27  1803  					}
6341655663fe166 Jeff Layton        2021-01-27  1804  				}
6341655663fe166 Jeff Layton        2021-01-27  1805  				if (last) {
6341655663fe166 Jeff Layton        2021-01-27  1806  					ret = ceph_fscrypt_decrypt_block_inplace(inode,
6341655663fe166 Jeff Layton        2021-01-27  1807  							pages[num_pages - 1],
6341655663fe166 Jeff Layton        2021-01-27  1808  							CEPH_FSCRYPT_BLOCK_SIZE,
6341655663fe166 Jeff Layton        2021-01-27  1809  							offset_in_page(last_pos),
6341655663fe166 Jeff Layton        2021-01-27  1810  							last_pos >> CEPH_FSCRYPT_BLOCK_SHIFT);
6341655663fe166 Jeff Layton        2021-01-27  1811  					if (ret < 0) {
6341655663fe166 Jeff Layton        2021-01-27  1812  						ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1813  						break;
6341655663fe166 Jeff Layton        2021-01-27  1814  					}
6341655663fe166 Jeff Layton        2021-01-27  1815  				}
6341655663fe166 Jeff Layton        2021-01-27  1816  			}
124e68e74099090 Sage Weil          2009-10-06  1817  		}
e8344e668915a74 majianpeng         2013-09-12  1818  
e8344e668915a74 majianpeng         2013-09-12  1819  		left = len;
54f371cad7e715f Jeff Layton        2021-01-25  1820  		off = offset_in_page(pos);
e8344e668915a74 majianpeng         2013-09-12  1821  		for (n = 0; n < num_pages; n++) {
54f371cad7e715f Jeff Layton        2021-01-25  1822  			size_t plen = min_t(size_t, left, PAGE_SIZE - off);
54f371cad7e715f Jeff Layton        2021-01-25  1823  
6341655663fe166 Jeff Layton        2021-01-27  1824  			/* copy the data */
54f371cad7e715f Jeff Layton        2021-01-25  1825  			ret = copy_page_from_iter(pages[n], off, plen, from);
e8344e668915a74 majianpeng         2013-09-12  1826  			if (ret != plen) {
e8344e668915a74 majianpeng         2013-09-12  1827  				ret = -EFAULT;
e8344e668915a74 majianpeng         2013-09-12  1828  				break;
e8344e668915a74 majianpeng         2013-09-12  1829  			}
6341655663fe166 Jeff Layton        2021-01-27  1830  			off = 0;
e8344e668915a74 majianpeng         2013-09-12  1831  			left -= ret;
e8344e668915a74 majianpeng         2013-09-12  1832  		}
6341655663fe166 Jeff Layton        2021-01-27  1833  		if (ret < 0) {
6341655663fe166 Jeff Layton        2021-01-27  1834  			dout("sync_write write failed with %d\n", ret);
6341655663fe166 Jeff Layton        2021-01-27  1835  			ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1836  			break;
6341655663fe166 Jeff Layton        2021-01-27  1837  		}
e8344e668915a74 majianpeng         2013-09-12  1838  
6341655663fe166 Jeff Layton        2021-01-27  1839  		if (IS_ENCRYPTED(inode)) {
6341655663fe166 Jeff Layton        2021-01-27  1840  			ret = ceph_fscrypt_encrypt_pages(inode, pages,
6341655663fe166 Jeff Layton        2021-01-27  1841  							 write_pos, write_len,
6341655663fe166 Jeff Layton        2021-01-27  1842  							 GFP_KERNEL);
124e68e74099090 Sage Weil          2009-10-06  1843  			if (ret < 0) {
6341655663fe166 Jeff Layton        2021-01-27  1844  				dout("encryption failed with %d\n", ret);
124e68e74099090 Sage Weil          2009-10-06  1845  				ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1846  				break;
6341655663fe166 Jeff Layton        2021-01-27  1847  			}
124e68e74099090 Sage Weil          2009-10-06  1848  		}
124e68e74099090 Sage Weil          2009-10-06  1849  
6341655663fe166 Jeff Layton        2021-01-27  1850  		req = ceph_osdc_new_request(osdc, &ci->i_layout,
6341655663fe166 Jeff Layton        2021-01-27  1851  					    ci->i_vino, write_pos, &write_len,
6341655663fe166 Jeff Layton        2021-01-27  1852  					    rmw ? 1 : 0, rmw ? 2 : 1,
6341655663fe166 Jeff Layton        2021-01-27  1853  					    CEPH_OSD_OP_WRITE,
6341655663fe166 Jeff Layton        2021-01-27  1854  					    CEPH_OSD_FLAG_WRITE,
6341655663fe166 Jeff Layton        2021-01-27  1855  					    snapc, ci->i_truncate_seq,
6341655663fe166 Jeff Layton        2021-01-27  1856  					    ci->i_truncate_size, false);
6341655663fe166 Jeff Layton        2021-01-27  1857  		if (IS_ERR(req)) {
6341655663fe166 Jeff Layton        2021-01-27  1858  			ret = PTR_ERR(req);
6341655663fe166 Jeff Layton        2021-01-27  1859  			ceph_release_page_vector(pages, num_pages);
6341655663fe166 Jeff Layton        2021-01-27  1860  			break;
6341655663fe166 Jeff Layton        2021-01-27  1861  		}
6341655663fe166 Jeff Layton        2021-01-27  1862  
6341655663fe166 Jeff Layton        2021-01-27  1863  		dout("sync_write write op %lld~%llu\n", write_pos, write_len);
6341655663fe166 Jeff Layton        2021-01-27  1864  		osd_req_op_extent_osd_data_pages(req, rmw ? 1 : 0, pages, write_len,
6341655663fe166 Jeff Layton        2021-01-27  1865  						 offset_in_page(write_pos), false,
6341655663fe166 Jeff Layton        2021-01-27  1866  						 true);
26be88087ae8a04 Alex Elder         2013-04-15  1867  		req->r_inode = inode;
6341655663fe166 Jeff Layton        2021-01-27  1868  		req->r_mtime = mtime;
e8344e668915a74 majianpeng         2013-09-12  1869  
6341655663fe166 Jeff Layton        2021-01-27  1870  		/* Set up the assertion */
6341655663fe166 Jeff Layton        2021-01-27  1871  		if (rmw) {
6341655663fe166 Jeff Layton        2021-01-27  1872  			/*
6341655663fe166 Jeff Layton        2021-01-27  1873  			 * Set up the assertion. If we don't have a version number,
6341655663fe166 Jeff Layton        2021-01-27  1874  			 * then the object doesn't exist yet. Use an exclusive create
6341655663fe166 Jeff Layton        2021-01-27  1875  			 * instead of a version assertion in that case.
6341655663fe166 Jeff Layton        2021-01-27  1876  			 */
6341655663fe166 Jeff Layton        2021-01-27  1877  			if (assert_ver) {
6341655663fe166 Jeff Layton        2021-01-27  1878  				osd_req_op_init(req, 0, CEPH_OSD_OP_ASSERT_VER, 0);
6341655663fe166 Jeff Layton        2021-01-27  1879  				req->r_ops[0].assert_ver.ver = assert_ver;
6341655663fe166 Jeff Layton        2021-01-27  1880  			} else {
6341655663fe166 Jeff Layton        2021-01-27  1881  				osd_req_op_init(req, 0, CEPH_OSD_OP_CREATE,
6341655663fe166 Jeff Layton        2021-01-27  1882  						CEPH_OSD_OP_FLAG_EXCL);
6341655663fe166 Jeff Layton        2021-01-27  1883  			}
6341655663fe166 Jeff Layton        2021-01-27  1884  		}
124e68e74099090 Sage Weil          2009-10-06  1885  
6341655663fe166 Jeff Layton        2021-01-27  1886  		ret = ceph_osdc_start_request(osdc, req, false);
26be88087ae8a04 Alex Elder         2013-04-15  1887  		if (!ret)
6341655663fe166 Jeff Layton        2021-01-27  1888  			ret = ceph_osdc_wait_request(osdc, req);
124e68e74099090 Sage Weil          2009-10-06  1889  
8ae99ae2b40766a Xiubo Li           2021-03-22  1890  		ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
903f4fec78dd05a Xiubo Li           2021-05-13  1891  					  req->r_end_latency, len, ret);
124e68e74099090 Sage Weil          2009-10-06  1892  		ceph_osdc_put_request(req);
26544c623e741ac Jeff Layton        2017-04-04  1893  		if (ret != 0) {
6341655663fe166 Jeff Layton        2021-01-27  1894  			dout("sync_write osd write returned %d\n", ret);
6341655663fe166 Jeff Layton        2021-01-27  1895  			/* Version changed! Must re-do the rmw cycle */
6341655663fe166 Jeff Layton        2021-01-27 @1896  			if ((assert_ver && (ret == -ERANGE || ret == -EOVERFLOW)) ||

How do we know "rmw" is true at this point?

6341655663fe166 Jeff Layton        2021-01-27  1897  			     (!assert_ver && ret == -EEXIST)) {
6341655663fe166 Jeff Layton        2021-01-27  1898  				/* We should only ever see this on a rmw */
6341655663fe166 Jeff Layton        2021-01-27  1899  				WARN_ON_ONCE(!rmw);

Although this WARN_ON() suggests that it *is* true...

6341655663fe166 Jeff Layton        2021-01-27  1900  
6341655663fe166 Jeff Layton        2021-01-27  1901  				/* The version should never go backward */
6341655663fe166 Jeff Layton        2021-01-27  1902  				WARN_ON_ONCE(ret == -EOVERFLOW);
6341655663fe166 Jeff Layton        2021-01-27  1903  
6341655663fe166 Jeff Layton        2021-01-27  1904  				*from = saved_iter;
6341655663fe166 Jeff Layton        2021-01-27  1905  
6341655663fe166 Jeff Layton        2021-01-27  1906  				/* FIXME: limit number of times we loop? */
6341655663fe166 Jeff Layton        2021-01-27  1907  				continue;
6341655663fe166 Jeff Layton        2021-01-27  1908  			}
26544c623e741ac Jeff Layton        2017-04-04  1909  			ceph_set_error_write(ci);
26544c623e741ac Jeff Layton        2017-04-04  1910  			break;
26544c623e741ac Jeff Layton        2017-04-04  1911  		}
26544c623e741ac Jeff Layton        2017-04-04  1912  		ceph_clear_error_write(ci);
124e68e74099090 Sage Weil          2009-10-06  1913  		pos += len;
124e68e74099090 Sage Weil          2009-10-06  1914  		written += len;
6341655663fe166 Jeff Layton        2021-01-27  1915  		dout("sync_write written %d\n", written);
e8344e668915a74 majianpeng         2013-09-12  1916  		if (pos > i_size_read(inode)) {
124e68e74099090 Sage Weil          2009-10-06  1917  			check_caps = ceph_inode_set_size(inode, pos);
124e68e74099090 Sage Weil          2009-10-06  1918  			if (check_caps)
e8344e668915a74 majianpeng         2013-09-12  1919  				ceph_check_caps(ceph_inode(inode),
e8344e668915a74 majianpeng         2013-09-12  1920  						CHECK_CAPS_AUTHONLY,
124e68e74099090 Sage Weil          2009-10-06  1921  						NULL);
e8344e668915a74 majianpeng         2013-09-12  1922  		}
26544c623e741ac Jeff Layton        2017-04-04  1923  
e8344e668915a74 majianpeng         2013-09-12  1924  	}
e8344e668915a74 majianpeng         2013-09-12  1925  
e8344e668915a74 majianpeng         2013-09-12  1926  	if (ret != -EOLDSNAPC && written > 0) {
ee7289bfadda5f4 majianpeng         2013-08-21  1927  		ret = written;
e8344e668915a74 majianpeng         2013-09-12  1928  		iocb->ki_pos = pos;
124e68e74099090 Sage Weil          2009-10-06  1929  	}
6341655663fe166 Jeff Layton        2021-01-27  1930  	dout("sync_write returning %d\n", ret);
124e68e74099090 Sage Weil          2009-10-06  1931  	return ret;
124e68e74099090 Sage Weil          2009-10-06  1932  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

