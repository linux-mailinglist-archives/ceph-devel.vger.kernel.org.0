Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE846313B
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 11:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhK3KnW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 05:43:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5022 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234553AbhK3KnV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:43:21 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU9TRdV020991;
        Tue, 30 Nov 2021 10:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=SxyDEL7tVdcV1aGVs0zKD5sJTikxvAbhnSCTkMxj5QI=;
 b=aPkcbMKvRBEw5VmGNCJ0RI/JpfBliAwcBtf5VwP8S2v0xEBhmrPGHgW5PjRDN6L+lpmB
 Hp954949bsmADN6+rkjJny/5HODAfV0364RD1Myp/PwYS8XLAWFzdUqZ0a4fLFyUunl3
 JyEn5KBocpx7ALmC/zTW8e1mVySvz5+y55UhvyY0zlZadKJcudVF+gCV3GT9giBKWIbb
 h7yVBaVTP06yHBPJY/yuqB/l6gCf2P3RJk8tQ2rZXB9ryo4SXBrQJ+HWGuS/SeJcOvQl
 mFX80p4CrOQ02zG9ohnXCFs5iwpE0lke4o8w1mBwq9Y6EWjhkYRSA9JyP+J9CSPqHM7T /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmvmwr9ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 10:39:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AUAVbBX094326;
        Tue, 30 Nov 2021 10:39:57 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by aserp3030.oracle.com with ESMTP id 3ckaqeejar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 10:39:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHN+VZ1liCCHgrppRpZmPc6shz5Im6noBOaJmSwYuNE18mjpHbyC1l9uxRZE2yi+91qvlpHhPCZBnJ6kH2zBOhZ/hkjbfqtXyfLpfR+SVCftVrIAc5w8FxCQSc5Fi2Eu0L5lvirgmDdjlsOeolXFUImBgef0aAnBX/Cagg4b+WONOjvqrjq2mPUBBiOmdsDwmhttmQkIZj8cC8mtX7NIt93UwO9vLJCKe8CbT2ZrDbrk5yy+j43x9LDfpFsrIpdeGY41+FBsKVgpImxClv/b7A2jnrW9o+vJByhOUR0qu9YUqASNrtdqC37Nhcem2f7Jg4Fbtrz2+Qms/5e25Smzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxyDEL7tVdcV1aGVs0zKD5sJTikxvAbhnSCTkMxj5QI=;
 b=Vau+BN476tN/TjaGOo74h6dZ9sqAHtiotfX27ai/c1leVZfR/rJ7p8ByQWmbUyDX3M6igbj8maxpscBD79o1lRWq0bt3BEmD0GgU5eZlPHP4pq9tIu7q6cK2R6wjVGE6+5LIfc1FDycyQZJP2YVnHBsLj1J+4O2+uvVZWxDMZN+uCeK6QqDaglzRTpqOh18D7vm6b34UYXLia54aGPwNf3+FsCvtA0RRlGui/FGsEfKIqJThINN9ODxq1yRBDbN85HMkNusrIc1uN4n7eiUtAMnBCBo31wy+sxrFclrP+POvNrYBLuZ1/RqbHj0HflvCOXpDsQtO3WLatAJgrywv9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxyDEL7tVdcV1aGVs0zKD5sJTikxvAbhnSCTkMxj5QI=;
 b=LHZn0mBA3cv35wjOkZpQMH+l6ZzMpIb+539VpD9xDPMGH+aDRKSOCdK2FZmBW5j0MVN16D2NB4a3gLT/ytF4mWeqLcXIa1etBVkMMWj59fJiMxXTV7KkevgQaMsxvQ8Xs9LOcEnR/LySJ55K0rBjO4RANIDxXTeUgMDkn3ghQGU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1357.namprd10.prod.outlook.com
 (2603:10b6:300:21::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 10:39:56 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 10:39:56 +0000
Date:   Tue, 30 Nov 2021 13:39:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     zyan@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [bug report] ceph: encode inodes' parent/d_name in cap reconnect
 message
Message-ID: <20211130103947.GA5827@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 10:39:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50a19eb4-05c5-4ae4-eb3d-08d9b3edbfed
X-MS-TrafficTypeDiagnostic: MWHPR10MB1357:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1357CD176A6FEB01B71521F18E679@MWHPR10MB1357.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FFd3zAkgAxXQuuU+tYOZoTgV4iUJQgf/nqidGENqNs2GK768lzF4GUMEe5oYJqhf5Ge3/hbM7J8c3In8ZCg9WUuAnIC5zmp/JKyIkrn/X0ndrS/avbbbB7xdLodiSviwcYPcUyoCAHjVY0uJffDmWiqUBOCKINZkNoe6tcV6XTXqEp3ole3vCjQImVaa7yWUszFCEst7bvnWRtqlfn/hi6eMsQTcgMirt2h1pw6r74Hn0E+2pSTWoVmLaz6r9yrjKDqtXUNHu4O53STYZG71U9qz+8ZS3QQvHiOHLSEWZIT4XNulWj82OjYaxRZOqolbZ42EOg4dJfcYlY7LC+jH6Js7okABZU8j9wHSYQiipIpmbD5p2Bf0Z1N5t8MyIWHZVWJgFPfq6fUXqg896UXpllDafh+Umz5qeH4gQdTv+eZM2GapTxjPpDXcIOg7w3MIV0ad0EBVWpkJrMg2F9HvIxua7OMET14cR1oSLh10J5/uhynwHjheXSuQ5ZejFzZs87OZZ2Xb+eCGL3XfF3LhZE69WWX0laufxmtelNM5z7dlBDz+xVV/IaKO8YVcOWkuJBbvN/KHhpeYcDcod8qQrjT2/UjpfWwQVqchN+SgFv+2CpkxvTBzTobbR+mvKc4Mcxlz/c7WssBa94ggb3+c1rw99af9D2kJJt4g3UoPu+Tw6jNGkRWC1UgZNGPTEueru+SP7ZFURUxQH9kc83hTPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(33716001)(9576002)(316002)(66476007)(8936002)(66946007)(44832011)(38100700002)(6666004)(83380400001)(38350700002)(956004)(15650500001)(9686003)(26005)(6496006)(186003)(5660300002)(86362001)(33656002)(508600001)(1076003)(8676002)(52116002)(6916009)(4326008)(66556008)(55016003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+sJIDxYl8A5Xa8n5GCy7gHsUZ+ECXyhJYgmjtJZcy1e7jyQY6MZddOc2XVF?=
 =?us-ascii?Q?QvwXZKn3Lb2HwnblH++0jkv2CsgtIySR411i50Hv0+WYU1IbV1BAjSqx5gXE?=
 =?us-ascii?Q?yuX38uha40obqleMl8jiyP4E/iXFKw+pcHVktLtfNCKq7fd5T9C33qO5jvhx?=
 =?us-ascii?Q?16VZNJp/nkykp26TiXiG0BNIcSHXvTEjdO6ZKtRXLQCnrOWwRqZ1//oyHbvv?=
 =?us-ascii?Q?gCqgdAYRPN2pVANk6irtx0RncdEnuS0oyBlMwvs7q+d8NWmzJnurI62dzO42?=
 =?us-ascii?Q?+nQ7jzYOqXsy3RyNIgwt83DmIHO5cSC/piBgXKK8e6z4R6VQpSsoaduIAIkr?=
 =?us-ascii?Q?pj4BaU26w9jyCBpctR2Irs7qmDMvZXqKfgClO346jnXGlM6J9v9ceewvuibZ?=
 =?us-ascii?Q?6YHj4acFKBUETFI7QHmLjsEsLmjKEHwgYbBD/bqJROlBCwpF3mLzIigPswHB?=
 =?us-ascii?Q?uhmIFwZUWzScmtfGDl6LzXH8hbucciFE2XQ11HRwGgos9GxCIALHm9BIvNVL?=
 =?us-ascii?Q?p9LrM0oW/6KHoAwx1OotFaaw8cY4FBDB6K78Ayf5kuHVhyEaB5U7jkexW66s?=
 =?us-ascii?Q?KEb3qT7i6VePg6GmCCvPPNW54eaQMWgOMTUMMlv2cPFUt5spD1ncsIT4kF4u?=
 =?us-ascii?Q?ZtnQ0u0es3mTerBV+dxHzf0s/k/SS9ApoNHUbUlmU+UDB5B/d5TkMILogE9c?=
 =?us-ascii?Q?Qer3C3T+IiyYhxPOlEFH0E9xhlntactv8ZrNkNuL5ij+9oFY80WOw2LznqVm?=
 =?us-ascii?Q?3noTxacEDLnobNSs52RT/QpxhT9T0gOWonNvEj/ZeU3qILtjQ4Edf8HAPY4D?=
 =?us-ascii?Q?DEzdBullACsk1XGv0ZhKA8TprDkF9X4ddz+7tEYfdYLnaKqF5cFNi/FX733N?=
 =?us-ascii?Q?Ygc7+Z4wldSLPrYMuOeAvu0MwNyjI7LUvV+hsXZFPJJqrkdrly/xqhqv3PML?=
 =?us-ascii?Q?U9hfwScDwH6yucTxJUJ5E0ju9zAVBRRLHQHVvr+s3oZhlxZ88A1u+j36GAea?=
 =?us-ascii?Q?sf4+jiUYRAzUPJEUJu0FO6yyhSO8lXnICHU7jRVFQxVKCzBBbHcFtgkzvKRY?=
 =?us-ascii?Q?wKibe+e7Yu6yo3cXsM3IbHiAdw9Q/K7ApYzEGaoholB5oJ9ZC/28D/nj11/b?=
 =?us-ascii?Q?2INBP4WxYkUpVS4HQVa6ux7mjDyg4UZ5AH1viwIkdbLav4wUJ6ptu59+7AY/?=
 =?us-ascii?Q?4F3TF6HXxg/+5DCAceMav6XDUAYuuJzHDSI8hb6vRBg2Q7qGcaL8vUU1UmI6?=
 =?us-ascii?Q?1R7LFhYihAOyryzoyVSa9qOEggKkfcvO3rqbGLIJ7tlTo2WoQzHqNVw5Igjg?=
 =?us-ascii?Q?lw8ZUzXjjaqUDaIiW0tM60w2VuwUVNxAp0M0/NQTeGkRf1L7CW1p17/T8LHB?=
 =?us-ascii?Q?9QRCbVvXTPGj/1DKh369wiN9D5Bj6YVMMeue0J9+cxWoUuYMLVOJF1E177RW?=
 =?us-ascii?Q?plOCbk7Cs9PldcIUZKpwizbVvJ4qq29EdZ0PjooYXJnWTQ20EMsjBR/beZD5?=
 =?us-ascii?Q?EZ/8L2PyppreN4nD3N4Xe4OmZszjzSS45F3MM5dSXB9I2hBFOawkQmbRIpKK?=
 =?us-ascii?Q?5oECdGYASFMIBWgVA0fQWfP2gQPbvJIPP56TVDupDQmH7DFkp55xRYuy1wyq?=
 =?us-ascii?Q?b2KfifauV+dt1f+IrZzP0MnG7wz+2DeW+NwZfjBRRUGJXGYe8ul3HIbZnmYc?=
 =?us-ascii?Q?inOZP373K+GBx5xeohjmfSUM+O8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a19eb4-05c5-4ae4-eb3d-08d9b3edbfed
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 10:39:55.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAIV9Ejqq30cEP2iX0FwCfBnlF1xXPdqMilkgZhDJHVTRXbnadrnCBBjPTf1qicbC074bYr+QZWs/TpLnHN2BxQV2utS0EDfSHYSORHi1f0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1357
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=817 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300060
X-Proofpoint-ORIG-GUID: b5Pff4bg7j2sZd9pnCPvwq3QS-dSWchm
X-Proofpoint-GUID: b5Pff4bg7j2sZd9pnCPvwq3QS-dSWchm
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Yan, Zheng,

The patch a33f6432b3a6: "ceph: encode inodes' parent/d_name in cap
reconnect message" from Aug 11, 2020, leads to the following Smatch
static checker warning:

	fs/ceph/mds_client.c:3848 reconnect_caps_cb()
	error: uninitialized symbol 'pathlen'.

fs/ceph/mds_client.c
    3674 static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
    3675                           void *arg)
    3676 {
    3677         union {
    3678                 struct ceph_mds_cap_reconnect v2;
    3679                 struct ceph_mds_cap_reconnect_v1 v1;
    3680         } rec;
    3681         struct ceph_inode_info *ci = cap->ci;
    3682         struct ceph_reconnect_state *recon_state = arg;
    3683         struct ceph_pagelist *pagelist = recon_state->pagelist;
    3684         struct dentry *dentry;
    3685         char *path;
    3686         int pathlen, err;
    3687         u64 pathbase;
    3688         u64 snap_follows;
    3689 
    3690         dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
    3691              inode, ceph_vinop(inode), cap, cap->cap_id,
    3692              ceph_cap_string(cap->issued));
    3693 
    3694         dentry = d_find_primary(inode);
    3695         if (dentry) {
    3696                 /* set pathbase to parent dir when msg_version >= 2 */
    3697                 path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
    3698                                             recon_state->msg_version >= 2);
    3699                 dput(dentry);
    3700                 if (IS_ERR(path)) {
    3701                         err = PTR_ERR(path);
    3702                         goto out_err;
                                 ^^^^^^^^^^^^^
"pathlen" is uninitialized on this goto.  It doesn't cause a bug.  It
just looks weird.

    3703                 }
    3704         } else {
    3705                 path = NULL;
    3706                 pathlen = 0;
    3707                 pathbase = 0;
    3708         }
    3709 
    3710         spin_lock(&ci->i_ceph_lock);
    3711         cap->seq = 0;        /* reset cap seq */
    3712         cap->issue_seq = 0;  /* and issue_seq */
    3713         cap->mseq = 0;       /* and migrate_seq */
    3714         cap->cap_gen = atomic_read(&cap->session->s_cap_gen);
    3715 
    3716         /* These are lost when the session goes away */
    3717         if (S_ISDIR(inode->i_mode)) {
    3718                 if (cap->issued & CEPH_CAP_DIR_CREATE) {
    3719                         ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
    3720                         memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
    3721                 }
    3722                 cap->issued &= ~CEPH_CAP_ANY_DIR_OPS;
    3723         }
    3724 
    3725         if (recon_state->msg_version >= 2) {
    3726                 rec.v2.cap_id = cpu_to_le64(cap->cap_id);
    3727                 rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
    3728                 rec.v2.issued = cpu_to_le32(cap->issued);
    3729                 rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
    3730                 rec.v2.pathbase = cpu_to_le64(pathbase);
    3731                 rec.v2.flock_len = (__force __le32)
    3732                         ((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
    3733         } else {
    3734                 rec.v1.cap_id = cpu_to_le64(cap->cap_id);
    3735                 rec.v1.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
    3736                 rec.v1.issued = cpu_to_le32(cap->issued);
    3737                 rec.v1.size = cpu_to_le64(i_size_read(inode));
    3738                 ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
    3739                 ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
    3740                 rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
    3741                 rec.v1.pathbase = cpu_to_le64(pathbase);
    3742         }
    3743 
    3744         if (list_empty(&ci->i_cap_snaps)) {
    3745                 snap_follows = ci->i_head_snapc ? ci->i_head_snapc->seq : 0;
    3746         } else {
    3747                 struct ceph_cap_snap *capsnap =
    3748                         list_first_entry(&ci->i_cap_snaps,
    3749                                          struct ceph_cap_snap, ci_item);
    3750                 snap_follows = capsnap->follows;
    3751         }
    3752         spin_unlock(&ci->i_ceph_lock);
    3753 
    3754         if (recon_state->msg_version >= 2) {
    3755                 int num_fcntl_locks, num_flock_locks;
    3756                 struct ceph_filelock *flocks = NULL;
    3757                 size_t struct_len, total_len = sizeof(u64);
    3758                 u8 struct_v = 0;
    3759 
    3760 encode_again:
    3761                 if (rec.v2.flock_len) {
    3762                         ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
    3763                 } else {
    3764                         num_fcntl_locks = 0;
    3765                         num_flock_locks = 0;
    3766                 }
    3767                 if (num_fcntl_locks + num_flock_locks > 0) {
    3768                         flocks = kmalloc_array(num_fcntl_locks + num_flock_locks,
    3769                                                sizeof(struct ceph_filelock),
    3770                                                GFP_NOFS);
    3771                         if (!flocks) {
    3772                                 err = -ENOMEM;
    3773                                 goto out_err;
    3774                         }
    3775                         err = ceph_encode_locks_to_buffer(inode, flocks,
    3776                                                           num_fcntl_locks,
    3777                                                           num_flock_locks);
    3778                         if (err) {
    3779                                 kfree(flocks);
    3780                                 flocks = NULL;
    3781                                 if (err == -ENOSPC)
    3782                                         goto encode_again;
    3783                                 goto out_err;
    3784                         }
    3785                 } else {
    3786                         kfree(flocks);
    3787                         flocks = NULL;
    3788                 }
    3789 
    3790                 if (recon_state->msg_version >= 3) {
    3791                         /* version, compat_version and struct_len */
    3792                         total_len += 2 * sizeof(u8) + sizeof(u32);
    3793                         struct_v = 2;
    3794                 }
    3795                 /*
    3796                  * number of encoded locks is stable, so copy to pagelist
    3797                  */
    3798                 struct_len = 2 * sizeof(u32) +
    3799                             (num_fcntl_locks + num_flock_locks) *
    3800                             sizeof(struct ceph_filelock);
    3801                 rec.v2.flock_len = cpu_to_le32(struct_len);
    3802 
    3803                 struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
    3804 
    3805                 if (struct_v >= 2)
    3806                         struct_len += sizeof(u64); /* snap_follows */
    3807 
    3808                 total_len += struct_len;
    3809 
    3810                 if (pagelist->length + total_len > RECONNECT_MAX_SIZE) {
    3811                         err = send_reconnect_partial(recon_state);
    3812                         if (err)
    3813                                 goto out_freeflocks;
    3814                         pagelist = recon_state->pagelist;
    3815                 }
    3816 
    3817                 err = ceph_pagelist_reserve(pagelist, total_len);
    3818                 if (err)
    3819                         goto out_freeflocks;
    3820 
    3821                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
    3822                 if (recon_state->msg_version >= 3) {
    3823                         ceph_pagelist_encode_8(pagelist, struct_v);
    3824                         ceph_pagelist_encode_8(pagelist, 1);
    3825                         ceph_pagelist_encode_32(pagelist, struct_len);
    3826                 }
    3827                 ceph_pagelist_encode_string(pagelist, path, pathlen);
    3828                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
    3829                 ceph_locks_to_pagelist(flocks, pagelist,
    3830                                        num_fcntl_locks, num_flock_locks);
    3831                 if (struct_v >= 2)
    3832                         ceph_pagelist_encode_64(pagelist, snap_follows);
    3833 out_freeflocks:
    3834                 kfree(flocks);
    3835         } else {
    3836                 err = ceph_pagelist_reserve(pagelist,
    3837                                             sizeof(u64) + sizeof(u32) +
    3838                                             pathlen + sizeof(rec.v1));
    3839                 if (err)
    3840                         goto out_err;
    3841 
    3842                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
    3843                 ceph_pagelist_encode_string(pagelist, path, pathlen);
    3844                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
    3845         }
    3846 
    3847 out_err:
--> 3848         ceph_mdsc_free_path(path, pathlen);
    3849         if (!err)
    3850                 recon_state->nr_caps++;
    3851         return err;
    3852 }

regards,
dan carpenter
