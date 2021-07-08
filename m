Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF93BFA04
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 14:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhGHM1s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 08:27:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31048 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhGHM1r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 08:27:47 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 168CCW5Z019751;
        Thu, 8 Jul 2021 12:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=/J9tOlyxjK0WFd31+cyIROU0I8BwULqZaAoR08ZNiPo=;
 b=nVvJso2vxEBPFZxiTdZf/05Elk29u7Dutne6Z302gj8JUN+gjMEgLRihwTD1TI5cWPPp
 ytbpkz2P3V3Du3nwgCcbb7kaYasnm2YZFwjnji4Ql9R3tNvfQttsl41QdnGAxIyB1S8W
 1AB4Y3h6IJiJ7hIHtjqtGUx0uxLr8yusNMXz6otg23VU+jBO3udXXooFm82PJI7FpiyQ
 vxCy9irAwuF0vP24Q7Tz94iuUy5FJV+MN/htUEuMLBW7chpqj4pozEBoY6FORbKMuRZV
 CDfPRLNPs560I5yv3RI7ZzBnfa6Ddpt1Dh6sKrJJfM06F6/T6jXncJlSYGIFSd+CFwQP lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nbsxtbq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 12:25:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 168CGcYa117443;
        Thu, 8 Jul 2021 12:25:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 39k1p08qc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 12:25:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/shfW74AFGPwauuAxzNJnTykd1m8Zjq3LLSZ6CplIiudlLvoietialI95yKHuEAlzq07Xb0blB2sxxnJFQTEKfCxRnjYH7AKP4lPaXQa8E3FSg2K7PUHE2T7C4zkskUPHvkfZ7vbBwABys0GZtgZrJ5MoECXXBFX9cIolN/zySrBby27BpQYr01q06tfvmOiNGCSsOLM83JLd2Wpcj8SR35ts5fyUDCoEouxrtFfTjQf1S8TiJpADhOKSqSFOOjzUeqOpa+dvDAhWt8nFXRjbFJWrIudwrjHK1wbGpapCC9lBx601Qitmrocyn4emfTcf76qld22oPsw2jlzDyzeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J9tOlyxjK0WFd31+cyIROU0I8BwULqZaAoR08ZNiPo=;
 b=hr9FtGyZkVJKR04gKYdEqsGi75r4mVqLRegXnuCbNUFzCAzTTakl7yHFZFHUAZrPRQdesJXvMx6Z5BpfFQyy1XLPgXQY9CoOcdee9vhqW1lJwnx5Ll8Yh+I3jeCHLw20FmbP96ZqkRjVASU6nw9MfcodZyj7KG6wRuGAl4TqBKZst8of+wkOsFZRCWP3OiXSl/8ohSrfzBD+eXUJnh/rPefFpohRYqh6m9Dv0Ko4NhzASclwDfdyv36Q3rX/1s3/q2BID0uFhCcla2mDb8T9u4XGWHzKuw4jD0g1GKPFAa5oPKFHviwuKVYkrzXg8MGdk2hTygSM8BdxGynuDdcX7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J9tOlyxjK0WFd31+cyIROU0I8BwULqZaAoR08ZNiPo=;
 b=e+dk2AebBKDo/JvpGfY6/b0wUaaWgDkSmlObmerLfUmndRerHPGs7+QsL1tTZGqybZr0eaLUuYyMxNmbMPgbuvQzqVbDkMPcgT8Mjg7nOiUM/hxGrjw+/F5wCHLuVcx3fw6lx+T0sSNTOk4sZkycfgoi/wWdVv5ISjnIyKhslWk=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1822.namprd10.prod.outlook.com
 (2603:10b6:300:10b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 12:24:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 12:24:58 +0000
Date:   Thu, 8 Jul 2021 15:23:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Xiubo Li <xiubli@redhat.com>
Cc:     lkp@intel.com, kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
Subject: [ceph-client:testing 6/8] fs/ceph/caps.c:2272 unsafe_request_wait()
 warn: potentially one past the end of array 'sessions[s->s_mds]'
Message-ID: <202107081225.Sgpea8vn-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0005.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0005.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Thu, 8 Jul 2021 12:24:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69b63a5a-0c58-48ff-342c-08d9420b64b2
X-MS-TrafficTypeDiagnostic: MWHPR10MB1822:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB18221618C46FCDC1B63829858E199@MWHPR10MB1822.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DEKApeTd3uDTprS7nJyw0kSAxJZIvoBNBsxOfQdbuhaV24gu89tuwB8TKsLVMIdVQNassiVTk3v7t7b2Xm1R1r0xAencFGibqr+eJTQ4iockm1Qmf7/p5+M6AMq+WVkxUbuXhuz0+UQRKcCF1Qe6XNWB3PdkSk79se9ERK2CDxkJxDI+dAkzCPFF/+dZr1TLVWbWjofVDr2Dl6jPWPPh3X/qO63EO9pgu35Rcq3QKW0xw9DxORMaRfk8yZo8AiXMW9xxzfqHCkZX+n9egtCQyaPEMZEsE0ONX44q63snSqQOwh2d0WB1+EwsCzoOrlBZNJxYDuXUXQxtBKZcsPR9UuqCfu3b/oovDhSyIjZRgjTNqTo6+exC1m6Wh4I9dRSbCUIVrNhJ4HgWacWy4IvkWxAEHDqfnMthFQA4taMdhv0LaBNJJ+zPyMSDir48MSDC3XD957BXwppUFqtI+F/9PVaqYQ1rNwYW+FrvDspw2aISk2+ukNuVGEm59ZSnlbO5wT/ghiswkMKDRfbWfIYBOTaICuA4k0vCoZ1WA/nGgltkh9u5hm0owuuAEQHDzRbEPWg0duPq3sYBqWYy+1NbhecJCZdqEnhP+NhV+nEklCA8nmPz7H0ibk3pb7MMu2BWjcCbQrIWwtAKaVrlhmheUivIi794jrxn1VN4KyTgT7JCOQHdv6XpIIVpcwC0iqsoAkBdv/BOiNFUJZ4XIJgHRTQBc+NXK+jKPAa9THJpxEsLhfnKODaHSAtLLSjy90lZ2BW+bLX3YdXM1BjLW5IidF8c0YEB1Lk4D9nBo3yFK9upfmCic82ijws+R3TXe7e8TUJrBbg9cRLGBdzeyaqsFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(478600001)(86362001)(52116002)(83380400001)(6496006)(1076003)(38100700002)(316002)(6666004)(4326008)(5660300002)(8936002)(9686003)(66946007)(66556008)(66476007)(8676002)(38350700002)(6916009)(186003)(4001150100001)(26005)(966005)(2906002)(36756003)(956004)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?veqvdvYDHgA7/ohrPoBavBjO/jdZrFwPTDcAWuF/RUjuzpMzFPPNrcM4Slv1?=
 =?us-ascii?Q?nw5QhFklZw3gUX/FO2XnuE1MdJD5aqcbROKuepQbXIBhx3BJxqu6C+JKKx/D?=
 =?us-ascii?Q?0lkjPCuBRJFnLhD9r08RLw9vHOtNEosZM8tBWFoPhv3DG32fueBqyktXDWtG?=
 =?us-ascii?Q?Mmgw9dzio//Enb7sc5szOEQDFcoV52ebrXVueWec3wfVx+ynRdWDhGVIeevE?=
 =?us-ascii?Q?PP0ph6SLzxpPOPPLFlra672pXa2A4czV28/xNHH4qA8vUBiG5xMPbLW6tUox?=
 =?us-ascii?Q?z7sY1Gz1p/UKvLdE4b+aXfOU3ZkbSC6S6NFwa6Zs1ZFq9WXHUYuIaoJgcKC8?=
 =?us-ascii?Q?xbbOA5jUQlejmLoMm1Yw/ULY5W+a6n83F+Q8dWJjy1bcpcawt63ujxcy6ktv?=
 =?us-ascii?Q?5FzsUO87Rn6NZrp7eGJdW19k8g2k8WiiK6BTa7F8xsyFc1ssZM89oteFGHSE?=
 =?us-ascii?Q?iPQDmcgPHu8oTc0+c6r5T3sn2KamEqLhIb8rgn3FW2WzLoLyNtG/BXzEMIeJ?=
 =?us-ascii?Q?x1AlEPV4W3sZ9r1u5cHYOylEe5XRFUQaVdxf/fX5kO4VmLIDssWLe7yUbqYo?=
 =?us-ascii?Q?teHhkSJSKHeXuB7lAbE+t53dQ7H/ZDVKJU96NfPLcV2xw7xLzL7wAw9+RmR5?=
 =?us-ascii?Q?2dO4EGYX0jU8JreZSgd1DnZnBEgaJlGCN0EYrgUX1sMJaNZvgDEQxIq1LbVg?=
 =?us-ascii?Q?3RaxBvMfapVtb/6mh243B5kdHpLAOF1XcT7zlugb6D0xYWnHp/C3UcqU4fXs?=
 =?us-ascii?Q?fv+96JNH8mVdvF4rsv1Dc4gv1C+1ITnMOPTHAo+kLAJ9+5QavSGZv/OBy0/f?=
 =?us-ascii?Q?ZnaAYvE3TJkKM6QkUaz70dsijJ3KIgc9Di5OZlYvoGsspU6OBheYJG+dojM7?=
 =?us-ascii?Q?5JYetBXWUoLFFQTrvUVehjCJXnWojhTqbssS/UJzxIX3d2G0+6KBb44h5BAq?=
 =?us-ascii?Q?zeCO4kQ7LEqvVe5VwruwkrXPMnkmHI9ki/pQkzCXjDVvhoLb3zTYt71PQKMy?=
 =?us-ascii?Q?nSZuJMtIgieIbW/rR4LK4rPH7x9ehFB5sfpGvwUt5yal/7s6b6Xhk4PitVp0?=
 =?us-ascii?Q?scMCmIbFxW+zZFgVBBjiKxdhQnJ7eyTkGkxqPGYKc+VxHEmW/JNnbLZvMDaG?=
 =?us-ascii?Q?d3sXtSD6AXIaVWZTje+MOmFVupSnEq/5ih2MpoReVv5g9HsKGe2dSdSvYVfD?=
 =?us-ascii?Q?55AjgKUQmvTNc4FDuSrZGa5GzrvNsGhj9fBXzBNhAB1Mbrw/b04LRpxW3Ez0?=
 =?us-ascii?Q?mBYQffSwrDOTM4HckeQzqmHfwWPRQ0HMi2Y7Ey1Im6eHxAM54y1tqXwwNc6H?=
 =?us-ascii?Q?k9QvPKJjWOTdxHaOR3SI8fDp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b63a5a-0c58-48ff-342c-08d9420b64b2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 12:24:58.2211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFdt6syeKeQDyhmU0eEfb0LE82+qhbOP9TfxDCFVjFBq600eZGu5UuyUwsGLZrLBzgJvHjmpBUA+L4xXl/JlJHjGIcEqKvNJXXs9FSwD7Y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1822
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10038 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107080069
X-Proofpoint-ORIG-GUID: 9vsN1xTgR0oCN3y3t7GRMpaUKHNxwIWC
X-Proofpoint-GUID: 9vsN1xTgR0oCN3y3t7GRMpaUKHNxwIWC
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   64887ecca52b9d754c09837b7242b80463bda63c
commit: dcdb5c3121f827d6bd92a11f3ad0f0cc27e3d133 [6/8] ceph: flush the mdlog before waiting on unsafe reqs
config: s390-randconfig-m031-20210707 (attached as .config)
compiler: s390-linux-gcc (GCC) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
fs/ceph/caps.c:2272 unsafe_request_wait() warn: potentially one past the end of array 'sessions[s->s_mds]'

Old smatch warnings:
fs/ceph/caps.c:2286 unsafe_request_wait() warn: potentially one past the end of array 'sessions[s->s_mds]'

vim +2272 fs/ceph/caps.c

68cd5b4b7612c2 Yan, Zheng  2015-10-27  2216  static int unsafe_request_wait(struct inode *inode)
da819c8150c5b6 Yan, Zheng  2015-05-27  2217  {
dcdb5c3121f827 Xiubo Li    2021-07-05  2218  	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
da819c8150c5b6 Yan, Zheng  2015-05-27  2219  	struct ceph_inode_info *ci = ceph_inode(inode);
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2220  	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2221  	int ret, err = 0;
da819c8150c5b6 Yan, Zheng  2015-05-27  2222  
da819c8150c5b6 Yan, Zheng  2015-05-27  2223  	spin_lock(&ci->i_unsafe_lock);
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2224  	if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2225  		req1 = list_last_entry(&ci->i_unsafe_dirops,
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2226  					struct ceph_mds_request,
da819c8150c5b6 Yan, Zheng  2015-05-27  2227  					r_unsafe_dir_item);
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2228  		ceph_mdsc_get_request(req1);
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2229  	}
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2230  	if (!list_empty(&ci->i_unsafe_iops)) {
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2231  		req2 = list_last_entry(&ci->i_unsafe_iops,
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2232  					struct ceph_mds_request,
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2233  					r_unsafe_target_item);
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2234  		ceph_mdsc_get_request(req2);
68cd5b4b7612c2 Yan, Zheng  2015-10-27  2235  	}
da819c8150c5b6 Yan, Zheng  2015-05-27  2236  	spin_unlock(&ci->i_unsafe_lock);
da819c8150c5b6 Yan, Zheng  2015-05-27  2237  
dcdb5c3121f827 Xiubo Li    2021-07-05  2238  	/*
dcdb5c3121f827 Xiubo Li    2021-07-05  2239  	 * Trigger to flush the journal logs in all the relevant MDSes
dcdb5c3121f827 Xiubo Li    2021-07-05  2240  	 * manually, or in the worst case we must wait at most 5 seconds
dcdb5c3121f827 Xiubo Li    2021-07-05  2241  	 * to wait the journal logs to be flushed by the MDSes periodically.
dcdb5c3121f827 Xiubo Li    2021-07-05  2242  	 */
dcdb5c3121f827 Xiubo Li    2021-07-05  2243  	if (req1 || req2) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2244  		struct ceph_mds_session **sessions = NULL;
dcdb5c3121f827 Xiubo Li    2021-07-05  2245  		struct ceph_mds_session *s;
dcdb5c3121f827 Xiubo Li    2021-07-05  2246  		struct ceph_mds_request *req;
dcdb5c3121f827 Xiubo Li    2021-07-05  2247  		unsigned int max;
dcdb5c3121f827 Xiubo Li    2021-07-05  2248  		int i;
dcdb5c3121f827 Xiubo Li    2021-07-05  2249  
dcdb5c3121f827 Xiubo Li    2021-07-05  2250  		/*
dcdb5c3121f827 Xiubo Li    2021-07-05  2251  		 * The mdsc->max_sessions is unlikely to be changed
dcdb5c3121f827 Xiubo Li    2021-07-05  2252  		 * mostly, here we will retry it by reallocating the
dcdb5c3121f827 Xiubo Li    2021-07-05  2253  		 * sessions arrary memory to get rid of the mdsc->mutex
dcdb5c3121f827 Xiubo Li    2021-07-05  2254  		 * lock.
dcdb5c3121f827 Xiubo Li    2021-07-05  2255  		 */
dcdb5c3121f827 Xiubo Li    2021-07-05  2256  retry:
dcdb5c3121f827 Xiubo Li    2021-07-05  2257  		max = mdsc->max_sessions;
dcdb5c3121f827 Xiubo Li    2021-07-05  2258  		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
                                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"sessions" is allocated here.  It has "max" elements.


dcdb5c3121f827 Xiubo Li    2021-07-05  2259  		if (!sessions) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2260  			err = -ENOMEM;
dcdb5c3121f827 Xiubo Li    2021-07-05  2261  			goto out;
dcdb5c3121f827 Xiubo Li    2021-07-05  2262  		}
dcdb5c3121f827 Xiubo Li    2021-07-05  2263  		spin_lock(&ci->i_unsafe_lock);
dcdb5c3121f827 Xiubo Li    2021-07-05  2264  		if (req1) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2265  			list_for_each_entry(req, &ci->i_unsafe_dirops,
dcdb5c3121f827 Xiubo Li    2021-07-05  2266  					    r_unsafe_dir_item) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2267  				s = req->r_session;
dcdb5c3121f827 Xiubo Li    2021-07-05  2268  				if (unlikely(s->s_mds > max)) {
                                                                                     ^^^^^^^^^^^^^^
This test is off by one.  It should be >= max.


dcdb5c3121f827 Xiubo Li    2021-07-05  2269  					spin_unlock(&ci->i_unsafe_lock);
dcdb5c3121f827 Xiubo Li    2021-07-05  2270  					goto retry;
dcdb5c3121f827 Xiubo Li    2021-07-05  2271  				}
dcdb5c3121f827 Xiubo Li    2021-07-05 @2272  				if (!sessions[s->s_mds]) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2273  					s = ceph_get_mds_session(s);
dcdb5c3121f827 Xiubo Li    2021-07-05  2274  					sessions[s->s_mds] = s;

Memory corrupting one element beyond the end of the array.

dcdb5c3121f827 Xiubo Li    2021-07-05  2275  				}
dcdb5c3121f827 Xiubo Li    2021-07-05  2276  			}
dcdb5c3121f827 Xiubo Li    2021-07-05  2277  		}
dcdb5c3121f827 Xiubo Li    2021-07-05  2278  		if (req2) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2279  			list_for_each_entry(req, &ci->i_unsafe_iops,
dcdb5c3121f827 Xiubo Li    2021-07-05  2280  					    r_unsafe_target_item) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2281  				s = req->r_session;
dcdb5c3121f827 Xiubo Li    2021-07-05  2282  				if (unlikely(s->s_mds > max)) {
                                                                                     ^^^^^^^^^^^^^^
Same.

dcdb5c3121f827 Xiubo Li    2021-07-05  2283  					spin_unlock(&ci->i_unsafe_lock);
dcdb5c3121f827 Xiubo Li    2021-07-05  2284  					goto retry;
dcdb5c3121f827 Xiubo Li    2021-07-05  2285  				}
dcdb5c3121f827 Xiubo Li    2021-07-05  2286  				if (!sessions[s->s_mds]) {
dcdb5c3121f827 Xiubo Li    2021-07-05  2287  					s = ceph_get_mds_session(s);
dcdb5c3121f827 Xiubo Li    2021-07-05  2288  					sessions[s->s_mds] = s;
dcdb5c3121f827 Xiubo Li    2021-07-05  2289  				}
dcdb5c3121f827 Xiubo Li    2021-07-05  2290  			}
dcdb5c3121f827 Xiubo Li    2021-07-05  2291  		}
dcdb5c3121f827 Xiubo Li    2021-07-05  2292  		spin_unlock(&ci->i_unsafe_lock);
dcdb5c3121f827 Xiubo Li    2021-07-05  2293  
dcdb5c3121f827 Xiubo Li    2021-07-05  2294  		/* the auth MDS */

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

