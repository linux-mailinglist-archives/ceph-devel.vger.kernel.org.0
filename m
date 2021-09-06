Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E963401916
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Sep 2021 11:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbhIFJo0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Sep 2021 05:44:26 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27168 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241568AbhIFJoX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Sep 2021 05:44:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1868kAJH024764;
        Mon, 6 Sep 2021 09:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=3uLZEqYIRoKx43BdaZZk37I+ft/sNYNCqRNRT7fYgwM=;
 b=zF9dYN3nlMNsh0Ae+L1uSojSvJddX57GiUEFH8QeRcQZbtvdN+xt9UnPrtWZT4hUltUL
 eLCnPRs519jgS+Mq4HRxueYjlGv6Dhg/oIKGJVVHTWjtam2dOBC+yLd/VsqUxwfK2Qbz
 ejd+MU5C7HztEMBYiTAtWB1jIR29kDsQa4jVnG4unSubLA9zb55uJ0gPpVOx1U5kaSLQ
 dhO7/yMQnHSavFFCem2BbfxJ7GFBYgesfrXI4zY2jK1yTpoAorZwrAlibAAfdgxe8U2i
 UKYASXoXAfteSHl086dMy2qIOWMMUFYNjaxWhGwufyQsBTudwKt0oWT1FdYh7laMEseo Hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=3uLZEqYIRoKx43BdaZZk37I+ft/sNYNCqRNRT7fYgwM=;
 b=vQ4S7UHsujooAQxb0ExikIDgZwhCZfFLg86LLp+oy0tVMg9cRADbsnr2l/Ul3lIvc8Qa
 YK9K/rhVms2kCio3tl1O/RKKxeBRr4+L9Yua48U91oVzbtC3oDtgcOMmtQdiLw6fD2fP
 RfnXhIwF6Khisqy4oxUGQfladegmy7BBFiWtGsvedzDjBs8oUNABhbMPd1jihTIs/5KN
 LcBIEdsGpXE9YzTug52Wn1R+Gr19Q78YI2IAnhB4Fj90psoYL/W2m5duRy2uYSoCgkZR
 j83OONJKjVFtGOUP3Pz+NEV3JXQ0l2E9aLOJke6ltxcFpGqDR/2wmWGDDnVmyKHm2EA0 lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3avy761q76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 09:43:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1869eid2036136;
        Mon, 6 Sep 2021 09:43:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 3auwwv4hu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 09:43:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlBA05jvRhWr1NOeTM8cvzZZzPULJ3EYHW0MWj5VHqqgaF1RexT9OTp3pe1RwLZbNRLkz9qYPbpv1/DSvcJTB67o1A+pRg09Sq0XBn7hOCiZTuzhtvzQzOSIbupgfB8Sg/3AZAJJSZct3oRn7NTfMdUgsT+MgaKLJxVnmKgba/AgsPZBVXwRUEzSOyqWfUOBkPDusjWKq0yk6epAEy+kLxtmhKxk5BEjvXqyfWqM5WFJv449nxsJ8jnn1RcfrxU+reaUinkOMPp2vXPls8lxN5niIGaN6rRsTXDSB3vvsbhf853v52W/+010Ege9Y7SqX8aW6Dk/VPDvQkt8xNZnLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3uLZEqYIRoKx43BdaZZk37I+ft/sNYNCqRNRT7fYgwM=;
 b=lheHWPLIuHC1O8OsbSx95uSvfaRc2Jc0e5W7jaPadv0LJ42YE+UROlB2NagSbsn/28k1Y68Im3fKjHEz3gy1GGdFOm8Sy0G5c5cAmnFUuGg8i+DvO9qDcJ/YUdZtdYxjSPVNCH6gpoSfgmzy0NnV3xnIs/ADQwMZjC2eaSKS3rAgRXpRvzyVB1Crlm6t+ngbWoQvuTjTg6k36x3SPSHEmhQmOA/764btdGDLfezkha7JWWQoxFakQ44oYHXvIULxrsZvr3+o3oj49ZIRrrsZ7/0sz3YM8Yb1OwvdaUG+NOnbc/6aM3SSCt9MtBN8L6qP9IEpE/WlB/WYJVUtGghVbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uLZEqYIRoKx43BdaZZk37I+ft/sNYNCqRNRT7fYgwM=;
 b=iark0xALx8+yqZ+H7Vu3NuO4DO6Wm1XPi8L/jVQ1PA/57y1jPZ2c9VKW0X/FnbRUK7BE7Em2C8jq+EChwrelyzpJ94uaPt5VoIvj5wYFJgmawy87dnuKuQ6A2PlkxJ37Y4O/RFCgzAgM90NJ0L7rqP0+N6YyiMfHPxK038eZdCo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1567.namprd10.prod.outlook.com
 (2603:10b6:300:25::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Mon, 6 Sep
 2021 09:43:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 09:43:12 +0000
Date:   Mon, 6 Sep 2021 12:43:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: fix off by one bugs in unsafe_request_wait()
Message-ID: <20210906094301.GB10957@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Mon, 6 Sep 2021 09:43:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d36f3da-98e7-439e-c441-08d9711abdad
X-MS-TrafficTypeDiagnostic: MWHPR10MB1567:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1567611590DC1891BF3910878ED29@MWHPR10MB1567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SWz2qTdmniD/RIHPUFuOlu+FNww/n0XxsOWVXscfpkkMhq0T3WHPdB8X5+hPGnjofhmRkChs2LZZ1GbXSmLJ+SkxnlghHxYPDfy8YSSoiS2N3YCY1IKy3TThnTbg36x6Zi5KOfLcd05IMeToNaSO1FHh1efzuY5ev8Z0d9oC7kRgrx22YPN5auaOIfWmEW0U0ZZKWX1yUUYnVeT9T3rWy6Lnv3hqAnvmz0dbfnKILe6JC8rN/NQNO3Z8O1hewrYVXEgwWQf7keEbma5NodgaJPIU2bWpLK8HP0WczWHcshdwUXmptIgEAjod+Fq8F5d7x0L9fBnUC9nktEglOrMpCGNP84TwDmGJJfK49/4eV9WOitcHOut5w0SH8KiynB4BTXd61NKSQ6AIEjDSmWArd4yzxqkq8FKUwcZoLl9iKs1KM6N08EXYUY7IMsGtxncr7rAeTfCVralqiCmWg4LDT7YO0YgpxvWebWC11LAfC5f+NiuqOxp8Pbwp1zsJ6rNcZEkw01/BQpWuZQkmjOMCDxEndEdQyzE99XSbGaZU43ApyEg88BzPXx/dPMTkBte9qWkP7jMlYxY9tf0X+jw3supq0qhoxKHJetQEYl03JW12H3Rjvdeb1DVFX0ZlPwOG4My7TBRRsq1i/cUawLT/ejrtqKVH377Z+EzLf6GdJPwihSKqLH4Ml6L4jnpKC6Jyx3MG8g6nMRYQQh6ovB4gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(396003)(366004)(478600001)(316002)(110136005)(26005)(33716001)(66476007)(956004)(2906002)(4744005)(4326008)(1076003)(33656002)(5660300002)(44832011)(66556008)(186003)(66946007)(9686003)(6666004)(86362001)(38100700002)(6496006)(38350700002)(9576002)(52116002)(83380400001)(8936002)(8676002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XeIpC061WO5fJT4GC1B5yAwVFz7yslt3ggxMEhkLonAxsPZpEyQOK2Bjby5k?=
 =?us-ascii?Q?79GIkspy6PWLcLgW1U2yrgC85gPzPB2UZOhWx0mu81QvV/UohV2mS1tVRFe4?=
 =?us-ascii?Q?eJaRPBwmfFN7DAUSwyU4JkPq2Q4I2NYB1eEmn+CVNyI5E4xhFFMVR182Y7CV?=
 =?us-ascii?Q?/lWaomUzxcNvz1wGDjFMJhC9GoueKvNdYX9IcLLh2TJdPy9IEfjqtHAVy8FC?=
 =?us-ascii?Q?gqtgzbqVaLaLtnfUTw5O0jKIlDkGiew92AfM/kdKMusLkx5h8XjdOIe7dZ5I?=
 =?us-ascii?Q?Q3KdcoIqExYeLzCkopf4+vu7NG/sf2JqxXypO0pyhZ9DmEYXLgW1Ryr6IMLb?=
 =?us-ascii?Q?2D1q3UYb2m9s1VJYfUf+srsMTl1UcPPCFrCaEYib5QnvshdUfAlHgqxDmQ7h?=
 =?us-ascii?Q?WTSpSjSqCXZm9kihuR2cy4kSPA44Vl3oK1zxjhB9E7+IdmTdzJNOWC6wT48S?=
 =?us-ascii?Q?HgjjOX4bXGpossyh3g5dbTtm4hlUPd6cGUuO3qxfU0L4kVjEivyn/3Rf8pE9?=
 =?us-ascii?Q?Rst0jYwpx+gXhpTwtPaaljZ/rSAhG20wghkqcBaoxF5JcatHNPl6upyIPvJK?=
 =?us-ascii?Q?VD7qIYSAo1PNiASGLhf9oPBQwOM0d+HJFip1It1g6oamLklaAZFsTl0RXAF1?=
 =?us-ascii?Q?ikBBmxu4ugMzQYkXKjQ5CdDqB1tZB+eYnvQjqL+IE6OMHgSgGd9r/PHb7ukZ?=
 =?us-ascii?Q?nREG444jIUvLREN2uogxbBRY6aSC30FL7DH5tAwWxQ9FbGceOHoFvO1+igiI?=
 =?us-ascii?Q?tzHx66B3zwzo9I0L/KLuPtWwsRe7PLfeI34aj5PTQq50AEPQlmn/fqhNZvrl?=
 =?us-ascii?Q?w36ACDD83y+wK+mmlWMp521KWRx3wdTdOBr7wWq0PNEbi0i0GiPsVemiqQeU?=
 =?us-ascii?Q?VtM2Ufi3flaf6rRBRV01olwhUfwpJVPpL4OB01rnyuFHow56nYBiXns1FEcT?=
 =?us-ascii?Q?HSVHxA2KbrZJrtxHDjSxANMQ9nGuqSMHJzHAv817V1LYyrUjEEMUBarpZLuk?=
 =?us-ascii?Q?k9Qz1Dq2/qyfOVRmHzOQSO8/ecR3kTTKYZPLGQmacDGyrycCTqYP8sBSIaUi?=
 =?us-ascii?Q?7a3hcWq+dPU60eVFX5SKowLOYLbmUEs9QuKBuIAxSHiI39o64jHY+EygpSTO?=
 =?us-ascii?Q?FyFby5C5/iI1yDV7oGXc64EgOO7nydsOfF3RwPrINxE6xsjoJm78f1VNWU6y?=
 =?us-ascii?Q?4lQVWj7S5IJ50ZELjR7xGpPkzZDWyQtRkgKkwt20OolieWk6L4TtycZYVqfL?=
 =?us-ascii?Q?KOLM0USkkFz8pF5ymcVj6rLsWCSwzAtDKA4PcJeGQlpFyPgTmIm5VJ4GSjLl?=
 =?us-ascii?Q?+k6qTOLI/goiQ6ZHMvppB3LD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d36f3da-98e7-439e-c441-08d9711abdad
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 09:43:12.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtHBVcATAocMffKDPfBqYFrzwTx3g9yQkgY73JuxW/aKpkCDODrQuP1+IfFU5SxDBRv7a6I8oyu4/uoK6qKjIuwgdDdDyBzgxDsVXETGZA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1567
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10098 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109060061
X-Proofpoint-GUID: H6CvFnUqmWnAuN4kPsq8q1fQLGkU6wTc
X-Proofpoint-ORIG-GUID: H6CvFnUqmWnAuN4kPsq8q1fQLGkU6wTc
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The "> max" tests should be ">= max" to prevent an out of bounds access
on the next lines.

Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ceph/caps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 26c5029629a4..ebbad9080422 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2260,7 +2260,7 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds > max)) {
+				if (unlikely(s->s_mds >= max)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					goto retry;
 				}
@@ -2274,7 +2274,7 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds > max)) {
+				if (unlikely(s->s_mds >= max)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					goto retry;
 				}
-- 
2.20.1

