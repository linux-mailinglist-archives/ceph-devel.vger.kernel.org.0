Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39595FEBC4
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Oct 2022 11:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiJNJhK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Oct 2022 05:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJNJhI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Oct 2022 05:37:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9853E16086B;
        Fri, 14 Oct 2022 02:37:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29E9KSL6020215;
        Fri, 14 Oct 2022 09:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=dOSZcsYJb8yp8m92zJDmr3Rr4BiLs14yWkFbx8TcZzc=;
 b=YEjRaKNpx7Bm35qrVi77o2CHiR29BL0g4dn0WSdlU/Ubtozw1mVKg9Q/V9CQO2rY+f6b
 4fBcCgTi9z4DvNTRuQ+yX/e8Cm6awotMKp2uuJLuYiPzr6IAxpX3vsVN4QrMhSDILKbk
 Pyf9eyvt9lYDCps0yQoBi7H7VM3WUc1VSS7LUoRSxP5p/tZJPw9uxg8/8zvt6Jg0d9gT
 7wN2F6OwVB8o9O09KG/yDJm2zfWuJglXdalEfI+/B7ouSNidtm8d1NiW5Vm2+vej4hCa
 IQ3oWXXAwGrd+07IeSNdYQNHXVTCIeUjcdL6TGu/yoiqZF6dQ4Ka+M5t3HFKtiME0PY+ rA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k6kgmtjbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:37:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29E8p4VP020773;
        Fri, 14 Oct 2022 09:37:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn6sr1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:37:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BowHN9lPw/BYdTwG1dTSWSl4VYaqlkPOBKhs/smlxfvQkzkbO9DVDXBDOzTqIsl9qFz8iEmml2nfeZVBCiF4CDVkY6xp9De8v/mHceTPl2w4cvRbz9ZKHSGeY/2Mchnv99fzifG4MY0mujPbze7ZcenD3DIVbtVErVvJi5LqSHkg7UGhbyAFiZ6uhobC87b/+7oHJYrttjxauXlByfFNwwhPjIjPfsy4lDWARNwQFWyEEGeHaK+qT1skzTg46RY/E36OxNDKeIYtly5uaBGTgr3fUO+RtbtZ+cITby9Kg+dUncYvBTTBHDoy7sJr6/oVJOLhWGUXXxCagqDjSRF3/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOSZcsYJb8yp8m92zJDmr3Rr4BiLs14yWkFbx8TcZzc=;
 b=dtub/Ok3o3vRLGj2Kl/mPXRYuVg+bBjOCquDAuO5rBlGYrCpf1BDOacK0T5G8wGCRsSIrBYsTYSdx7llfCIw91iTb4aiB6TlSpes9zDk2W3Q53tBO8beDoKquYwGM6vac1BIJx84G1TfjfOdRqaU2wMAKnE5P9b4VAiFvfEXNtpQxfSXUul2Pf3BeSRMVGVNf2ZWkfbMTh+6M1h4dvIi4Kk0oNkZe3TJiE/gp9abf1uazGnPPJFkXFX+4EIN7G19GMPBGOX5N7LLhKhE1eMntK8rXupfgrwRygfuR+IxdIAvzc6IsbuFoFkymmXdriVBqDR7yJkPshv0v8NwytCLjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOSZcsYJb8yp8m92zJDmr3Rr4BiLs14yWkFbx8TcZzc=;
 b=uzoMfP0q4QDCkhSI9kczJjRcNwbJdYZjDhGMTkesU7qGca0eH03hYxfVLQuQarWHpWKuFtjqmZMQxhn63h8tJZqk1pRXfUjDJFY86sjREesjw0Nrs/DqFiQVygkUdD6iRg+FlLV9jEFpTlilNVSWU7K2Bcpdp/SYwkgXePGFlFI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 09:36:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Fri, 14 Oct 2022
 09:36:58 +0000
Date:   Fri, 14 Oct 2022 12:36:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: fix a NULL vs IS_ERR() check
Message-ID: <Y0kttQIe0+2Rw+SP@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR2P278CA0062.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:52::10) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CO1PR10MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: 44050144-b759-479d-b527-08daadc7a3e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jRn8d4P4YUQZXQtN8jknNJOdSkcmxLG/0NLI2cjrDzNlhTNRyeZ2jcIlowRSB6yUI3YXz1uCAi53qLjGIe5B/ppWPI5qtmz/AYpl5aB0pO5ezyuyQ7/NfKwjHXtZqSyl+RyELkQ4T6AQtU4YqACySe4rph+oX2BRALdgNK85P+XaboDJkBKR9N1Vjzro9tGjJ+0R+BtNw8dS1QnJJ1i922a3YCJJ7UjAc44sBhZYQH9NIY382LB9RrAlCKDexNiONPgj4jV3NwrSJ6Y3UIALgDIvdA1l/prEwow7we5nrBKxqaL2C8EkrpYPMAcxNCmKVlNs0lW+iswXgXFDch6tTh9t1Qy8gSjfCTu7KgtC8rKm6il/RUzcCcxEcAppUJFYXy3e73M6QEZsvfZruQLTrjkTrJFmwCThzviETb3O1cR+CCx8mOnUovum6j5DpzEB3W+ormT8KcvZFEAUtmZjhgR5P4HpOJHRVKZm89iUiJGUf1H94KrcL2RIeul2h0Gen+Px80uqpLrapGDDV0pATepSN8yDL50PN7ujfOtWCkGuWsSbfZepFT7xRWe6UwD7TnzuJa6HUdCfyrbcRLCG8YI5P/XstUeI7tLlh/5ZDZBGX2rYfZXVBXGthV3fUZ/W6itxo1iL9voM/3P35SbUWxbJjmf8cmvt4QMBqznjA1hGqZGqxX7nHW0+5EgZ30EO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(86362001)(2906002)(4744005)(38100700002)(5660300002)(186003)(9686003)(478600001)(66476007)(66946007)(33716001)(66556008)(316002)(26005)(6666004)(8676002)(8936002)(44832011)(6916009)(6512007)(41300700001)(4326008)(6486002)(54906003)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/FcA0N+Km2Ha/HOFCnipm5uvgqMly+vs4UWtMTc0osKCFK1oxrGaCJnQGnC?=
 =?us-ascii?Q?/J3xxOkmet+5GVi/tnP48ll/pjN6b0HbnCSap8c7Mn6aGTFVR+5J5tB5iVDG?=
 =?us-ascii?Q?i+CSifsWTCFNf0jFWtwrpeTMJQzh1J2eSVq/eV5NfE50fFVieeJwXuNB4ac0?=
 =?us-ascii?Q?hqzZu7TylFx5FlKouCbp6ne+9YoRnnfuHKPf/MZxjwQyj8jGXpFI5yocqVeS?=
 =?us-ascii?Q?GhVdtn/Vk6oMdMNw6sHGByq4gKzYMGQ5NMYcRqsypyY+eMSjQZuEW9uF5ITY?=
 =?us-ascii?Q?lXD4xfTqdPMExUsvxS830+3VbdrmsylakFk2Lkg6gHftku2teeIYQs51yvtq?=
 =?us-ascii?Q?ZpVCvGoREmf5IJgQ+KgXM/KN0/f0bEgFx/IOqj6+Epboa6XnqgbbQ6SyM8to?=
 =?us-ascii?Q?JBJw/dt4ibUxm9PjIazU5o+ZsP5Iaymcb129zlL4quM45R2nhtY/0900NXkp?=
 =?us-ascii?Q?g9o6cNZY2BlqOGG4CW9HFxmDSUceuRbgqz2G1HkyeDf4t9OtIbI7O92Aqfz3?=
 =?us-ascii?Q?Hqqi9ni+PxTxZaR2XjyYohvN125xDcgjeUbCm8/2IlJOsrv9EnojYLGSSxLF?=
 =?us-ascii?Q?Ji8c3a+CCfY+Yv8oWUrulLjwXxH13BF68vFXJY3j3ky0ZtN0mkks2UEMbXoj?=
 =?us-ascii?Q?fuRAkWMP3ZXsGVZfFtLswIL66tM658fdgtLJoXNkm0BFzwy5fFjhxT3t/zmu?=
 =?us-ascii?Q?0EKJTHDklFZ/y35ko1F2pAF6aUpyBf6zSfQ3kjb05cBam51GSoNraM9ZMHgw?=
 =?us-ascii?Q?GjmyaYyrjhMm++WSMMWWE8Svwnhzi8WrUtmSHp2oISGA2Snxt5toYjOnjs40?=
 =?us-ascii?Q?TsLoeR33Zi7HlnRjaunq36oSzCWYCRToVL2Trxv1gY0nhc2j6+bMJLHw0g2l?=
 =?us-ascii?Q?ZSD8I+/1SpZZeKQqsGpj6VsGccUDQVhFHgaOMt8l/vMdccc7ky0q0QS9rlTm?=
 =?us-ascii?Q?GlkVgMU4PRAy6Ep3l+slLrXYPePIAH89s5q0hwOy4bFPE9oppEYQvC0sVNF3?=
 =?us-ascii?Q?74So2lbZmfvfzCLsHXsSZo0ww0gYujbWqUJuVdnORLevdHJbUtgdNwFSmMJp?=
 =?us-ascii?Q?4KQ2yopyQAa+9sgWFewOr9q5YvuscVxk2aYp9ZwO2BcdNLnoyYVP2Y54cjR3?=
 =?us-ascii?Q?v/ZBD/4wdFLLHoPmgl1ckQ0kRP4S1UQj33vpXiKrzmKr23PbnoHum0SVjS6w?=
 =?us-ascii?Q?PXQ4IIr81FHmgBmf/CT42Nb9S1f2IBmqx0ZZrU1XHtxhsj+AR221y46S5DjZ?=
 =?us-ascii?Q?DsM9r7/H2g7Wc/lX/wS60CzVuQ0BUHugxDiYvowoMEdSDmkPF2m5IS7ovpva?=
 =?us-ascii?Q?vGBYlBQtUi+ZKSu8eFtgOsHJNHz28wFtkAxbAmyxqotMg65HTuqltIjqxSOg?=
 =?us-ascii?Q?YnG15oASeRLLEOJeFhatioGjLbvBVCV1idseoWfqU0jWfoH4IFV0chc1q7OK?=
 =?us-ascii?Q?5yrsxAJ8wRGCjaQ1sAFw52AqTwn/Dc22it/LsMuF6UZUJs4cxBa5P3s8aLPE?=
 =?us-ascii?Q?mCroQ3jFFXIWGnyOcX1xHgHHaZkb6B0/6rRtDJ0BDLynF1WvBjieOv6y1LZS?=
 =?us-ascii?Q?AVtYj4gTmpddaKpoYt9LcMW2vhHkwwiJEXsyPYY8KZ233L1YSfYKog4SboIY?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44050144-b759-479d-b527-08daadc7a3e6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 09:36:58.7655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IY6Q+EiuvEhUT4iuh5TlrRQngmv0aCMjLxexB0m1GsdKvXPmrpxGV7U3RTHYDsOs0AG5mXMAj7FaX5ZK1lBKXOxdI09F8+TjE7P3qExnLMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_05,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140054
X-Proofpoint-ORIG-GUID: RznIIQ6F69944uMPOLzEfuZf_jTYQDS7
X-Proofpoint-GUID: RznIIQ6F69944uMPOLzEfuZf_jTYQDS7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The ceph_lookup_inode() function returns error pointers.  It never
returns NULL.

Fixes: aa87052dd965 ("ceph: fix incorrectly showing the .snap size for stat")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4af5e55abc15..bad9eeb6a1a5 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2492,7 +2492,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 			struct inode *parent;
 
 			parent = ceph_lookup_inode(sb, ceph_ino(inode));
-			if (!parent)
+			if (IS_ERR(parent))
 				return PTR_ERR(parent);
 
 			pci = ceph_inode(parent);
-- 
2.35.1

