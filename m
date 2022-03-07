Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F474D0102
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Mar 2022 15:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241712AbiCGOWl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Mar 2022 09:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiCGOWi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Mar 2022 09:22:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150626D383;
        Mon,  7 Mar 2022 06:21:44 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227C1VpK006962;
        Mon, 7 Mar 2022 14:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=lffEXXIofKpdgs4JrSbGzOgnSDXiZTSZjQa4CsPg/7U=;
 b=oBf9Elkrd1mjwqjFAwr6WBf6ta9+G8gqY70TnF0OEdpXSDNhX/ahFiPgN/19of23sGL2
 5CsaUSCvQl9NhPhX6oBIQS5v1kyUKAJ5wjyx00942zVwHmUdy+FJlB2R6+cPOdgvWyq0
 56jMt/V437xmfyKCxGx1InXLfY/mKKkhCZp4pMg26+wx5YT3BTIPspRYaiWJJLA3dBcP
 PIoofx8Y094XhvfBk6Nmo16ecmswo62CgMTHqd9tnZhniaWYUGkt9omKp71k2WL5lpwD
 VqqcrTUhndJ/nc05xJexE6ww6N58cYWc9qbImWEKEKwzLNv3GEDfqdORj+s43QxqoRfg 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2bxjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 14:21:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227EFF3J101011;
        Mon, 7 Mar 2022 14:21:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3ekvytjwuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 14:21:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amifqk6NR4ry1JUDwm+0PHd3zrzKlgV7qfBHJxJ2+KG8nfiz2KAm/5hLB96A1dzLnL5AB4W3eKvQuzJ506/iG5m8Yj0+94oozJVrWkC+g13oQBdXwG8qY150ybi44cvF3huGxrWATQIdyH6pSagfZaORtSKgq9kCEsFm9IuXNPm6/ePP6iOG2KppOXIaQC3n8H5UKIsBXY25gZOdiWLnWkyKnL3BY9T6BUFhVySwFIke4t8cV+5K6Sh0GllEtKiGlH0GMXfLx19V9WIUvUDR+HXjzJZ9L+gnTVW8Uhs3FeoPBMJt5UlOncv37BD19dHQREqie64muR/q9s9W+4h9SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lffEXXIofKpdgs4JrSbGzOgnSDXiZTSZjQa4CsPg/7U=;
 b=PzoeMlxJx4YdteJA5WT0TZxrDeRBGV7TRStil+8YnxBEYflznf32dHmcZ1z3ynSEIBYCJ42iuQkxgx1fz+/Vr0Q4+VNFVkRnA707zyfHXkIZh9KPSM8atKZPY8IHefIJiQjZp3xINJKJpy24xyJZQQ5Yg2lr9Ab4AtqWYJNRyrZUOOA7RlfEiJawI0l8+h0g0S5DmF49hhpYbarfLALSRjRRjSvZ4HbckZkqFdtkwRviiuBiS5UH/X/Bzt4lGY6SGmhosX42ftJtWMUlXMXauxvvgL3x3cQh0UGRYJ4g9ZirZbjhR7br/BkR7UDg+Eg3PdWUOdu234ch+U4YVYf3vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lffEXXIofKpdgs4JrSbGzOgnSDXiZTSZjQa4CsPg/7U=;
 b=xtgOJjyE/m0ME1fH7L6twY/FnRDr9Zyq3xo/QVw1hTP2QqQlMaEdy2h/yFluUBAs+BVLYwlkQA0Tmbf7/DzFA543Wq9pDpyjf3o/lOPodDuENGpd2nzdmNLE4kHa9zGI7YrXwU1K55YTEfxEzmizZ+gmL8WNnP8UihyHd/Ss9wk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BY5PR10MB4355.namprd10.prod.outlook.com
 (2603:10b6:a03:20a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 14:21:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 14:21:35 +0000
Date:   Mon, 7 Mar 2022 17:21:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: uninitialized variable in debug output
Message-ID: <20220307142121.GB19660@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7ac18fc-5ea2-4ae3-6fd5-08da0045c8e8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4355:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB435566301F597F2AED50F74A8E089@BY5PR10MB4355.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcyZm1En6acNx6S1y1zRjFSTWj0Yp+yqv8x8+/ZfJEZwc08mY9f2YnW9mliTCrfFvd/tHvSTKQV/Rsa8+l2KYW24+ccCsPaz9LEK4rMA/+0/6+sHJMvYCt0jEe7oWEKclQjtbOzxnFvyuerlNuYa0OeCbBooGE8BcPltgLNUKWbK8c7lZxhzHqaNHxmxfij5xKpW/3pdls7Mco7gGPtelDAbdWlDaSUfqEUU0JXEG4cn7/wpNOo8Tjg5zSGKhrJKJOUihNzwgJ1Z/LF7jGbdMwV4++H5BnoUvCjQSzieo3/exD1QG/WKIPSNawuE50ghSCXzBYoPtAacVy5zpCnuj5uxhhtlk/uzGZdVKCSd/08c1nemwZQR2QsQRyCCFYiJeyeeybKYxO6o476aLJPOVlT5PNNeE7YjETFJdZc/QpGzfgWsWYbzNXP//wyVHE3XKuDvCycT38QxTD2gmGLpej/B4uPQKvqxrZPmZiWyHQY+8VzFMtuC6w6Pboo1x8Yh3PQkVePpe3QOLCrW7cXPoME1V7MjRN/7t0EfBy9yCiyyspbZvXBbwkI4tVOjy+yyrC9NjzbtF0d7nwy4McBhiGLggDPZuPAuOcYts7DSHNHnvYDUhAgsmUVSKIfam+X9/8PyHZLtnkLT5ExAUo9nCPG2IpS2NxVkEx8o+Kg5AOZsScugmUgDpnmGMXlJggEEa8Wkr74NjbxyHFOmU0Jn7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(110136005)(38100700002)(38350700002)(33716001)(54906003)(83380400001)(66556008)(316002)(66946007)(4744005)(6666004)(5660300002)(86362001)(508600001)(6506007)(44832011)(33656002)(8936002)(52116002)(6512007)(26005)(186003)(1076003)(2906002)(66476007)(8676002)(4326008)(9686003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+79uFb8eCCmc3ukqIL1QAdLhBI4vB/0eG2N3iW9Ux5VkU79ZobqLZdROonNW?=
 =?us-ascii?Q?74a9oSwiyHq3bM1Q1tugVfTD9spSGtgC03B+p0rADNAcfKOX6fgj/Ddq9OAW?=
 =?us-ascii?Q?mOMcUE9aCRyQvnzfqFygmoyN2lXkaKBwpwt+7gSgnHYIXv/clN57fodJ+hPd?=
 =?us-ascii?Q?4EAcSzS4sj8KCVUm5WtMYLxqTB0GFkrK43uwL1mHvXo5EhEMn4qrvTqYY1IX?=
 =?us-ascii?Q?e50Iel9XLagEeseBQcCUCM4izCE9ykV2gA94Akosd1FOK8quzIxOOiBySboN?=
 =?us-ascii?Q?6hV7dxvBFFeNkSyIbUsGMK1DsCYDgEsEQ+TJJlG1A0QBbOTaP0xAGVvV5J4w?=
 =?us-ascii?Q?R12SteNd1rnTnwkjsAoq6yoE3IF+fFvP7R+e80OuUjffs2c2HOrivSOJ9wGn?=
 =?us-ascii?Q?TVT32kiMRGeKtRm/ZphUuq2QmmU7t2e/zUyXlN/jk5FoPfsJ9Pneu22FCoRR?=
 =?us-ascii?Q?Z9gFrz2Kwt5j9AEUqWvy3GXgAnbosiePclEZ3LZt2TUmAPnMEVsl7DfwbTN4?=
 =?us-ascii?Q?DQLGps8AGy1VveEtFE4qNPOEKiR3GAKIMxxBZntXly4cdP6yMcCqMYKERUGZ?=
 =?us-ascii?Q?Vbl9ZJ6O+tgqgLQyfG4SDYxFp1AsL88/xAmNFrXuh6+Sw7whdiQxsHJicxPh?=
 =?us-ascii?Q?owZSxCAvjF/HjtlA5Ppxr9LnSOo46d3hn6entWhaM6wpLRNdFEsAOL88+rP6?=
 =?us-ascii?Q?W9ka+ffoFMDOUYzYv98D0MLP1ocRq341OoQ0NqhNPdDMwIjp3B7R6gkB/FQ3?=
 =?us-ascii?Q?30LvRP55RzLir8pmBrsd2eaK7exmaB9ELaCItixNIs9mi9StBq/+gOlPDVxf?=
 =?us-ascii?Q?D27/SyzNe/DjHUT4mHrjh64x8hvmcYYC1a3jArHAnKqe039T2yZxb0thlgbC?=
 =?us-ascii?Q?cHLadmCEwoAr+BmVapZUJawuCNtF2updf4GCDRZoPzSXe93Gk/P6GtTxbg8Z?=
 =?us-ascii?Q?DKlVC7kRv4xgQ0viZfVt5q8lJZQhjZ/NWG9h7iIjowDChn1Mcq3uWJognZDm?=
 =?us-ascii?Q?xh//GATy77VA3Jt3I2Pl/5h38dMueoCKXHeXPG0OjKsW++ryQdfswNPH3SUC?=
 =?us-ascii?Q?2iKjq68mafpgLVlpwAr07BXxuazUoLstQs0bD3OJvhULCISMlN4SqM5B2j2j?=
 =?us-ascii?Q?0HQijLYk5couuucIqxyhhNlno+2lqQvTB6vAfg3veMDq4kdCHyNQtVxklICe?=
 =?us-ascii?Q?PeAZUzBh2oAG/YcdWHlxgvRJyM2JGZW4pJ5lydfRI0ZNUVz6zUUB2BMxhaJZ?=
 =?us-ascii?Q?G+zgm4eYNQFbrXOinZmRb3u8zkTQsJiePDvwAnHlEW845V9HoZ5/K5xgYeLH?=
 =?us-ascii?Q?AruAbcFL7zfBrl8VJiuy9qJ2dZ6u2zMZt7+LpyQkTaDUK4nSm+NU0EdvRBn3?=
 =?us-ascii?Q?wEZiB/f1XMSJb9Y2GRqvS9+iqUcbtghVMmo+CFywxjGgOgPQRCSHlUl7aE1f?=
 =?us-ascii?Q?5gEyUoErBKSDE70G/D8s6AxzzQOlJOs2KMe6GfiCGu2U8UVEiksgwCfiWbev?=
 =?us-ascii?Q?K7cFaynqNWvm3aRwDebfqm/zgDuZ7NHI6s7MxHkD5BT9GF7KK5ro+S31zEDd?=
 =?us-ascii?Q?+ZVLdesMlTUUmwwR/4w3P6h+VpIIz3YJNywYw9bLlz86+gGwnI4LV7VpSmjz?=
 =?us-ascii?Q?r2tnciB6fBFKoLzFS/FrJiNyQAxwuqKwPXyzh0Ca55PwpjGHDt56WHJ1eHfq?=
 =?us-ascii?Q?tEZs+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ac18fc-5ea2-4ae3-6fd5-08da0045c8e8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 14:21:35.2734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoCMRSHayWwPQIRk4cv9fdqghcZmb+r32I1nYmokhI4MDIooSh4UJjYiH9x32VkojzqbK6BV7DYqTp+Gdq6RYiQ1V3ZFHaLJakEdpZ1Aimk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4355
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070083
X-Proofpoint-ORIG-GUID: ubBspT6-bsMN9meIUsjRUDUb_ojruFIk
X-Proofpoint-GUID: ubBspT6-bsMN9meIUsjRUDUb_ojruFIk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If read_mapping_folio() fails then "inline_version" is printed without
being initialized.

Fixes: 083db6fd3e73 ("ceph: uninline the data on a file opened for writing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ceph/addr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3c1257b09775..0d4120297ede 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1632,9 +1632,10 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_osd_request *req;
 	struct ceph_cap_flush *prealloc_cf;
 	struct folio *folio = NULL;
+	u64 inline_version = -1;
 	struct page *pages[1];
-	u64 len, inline_version;
 	int err = 0;
+	u64 len;
 
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
-- 
2.20.1

