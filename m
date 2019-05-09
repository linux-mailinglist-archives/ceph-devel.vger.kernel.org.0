Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E7718833
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2019 12:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfEIKL4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 May 2019 06:11:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44844 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfEIKLz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 May 2019 06:11:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49A47r7151887;
        Thu, 9 May 2019 10:11:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=neR6KgNTfO3pr9d8gVWPxShCmiFnAFlvpMLhr9CMJKc=;
 b=v4ZKiMpxTD1jLCtxQhxvk07Li/h8O1tL6dXkCkzjkLuXs80ypU2gLp7jKP3M5tC8eFGH
 QnEurOkncfKMMDmqcSDBEeAYZ/vcX6u8b7syn7fw4s8HWxLSRavxi+YdHB/QY9vWQ8J4
 8PO/Hb+FVnrF4eJwq3EJ/tpVRa8swxelUQJImJWxjv4JwCY4Do/0I4bDX6sbEh05yZdo
 FsyZBhSYr7sRVqQtasoCnVK86KgpgRXyQW6k+t8iw3BlAG5pP3ty1ZKNPi8RDaVvUDUQ
 pbwGawp3DV70baeEU+driTIApmvCpuVPPAK323BfciWonl+aKQ47HwXulAWP0Zzsrrt3 Aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2s94bg9s8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 10:11:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49AB6JC028094;
        Thu, 9 May 2019 10:11:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2schvyr9tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 10:11:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x49ABWds004114;
        Thu, 9 May 2019 10:11:32 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 03:11:32 -0700
Date:   Thu, 9 May 2019 13:11:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: Silence a checker warning on the error path
Message-ID: <20190509101125.GC7024@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905090062
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905090062
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The problem is that if ceph_mdsc_build_path() fails then we set "path"
to NULL and the "pathlen" variable is uninitialized.  The we call
ceph_mdsc_free_path(path, pathlen) to clean up.  Since "path" is NULL,
the function is a no-op but Smatch and UBSan still complain that
"pathlen" is uninitialized.

This patch doesn't change run time, it just silence the warnings.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ceph/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index b3fc5fe26a1a..a14d64664878 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -52,7 +52,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	struct rb_node *rp;
-	int pathlen;
+	int pathlen = 0;
 	u64 pathbase;
 	char *path;
 
-- 
2.18.0
