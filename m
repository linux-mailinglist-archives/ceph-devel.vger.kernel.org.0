Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D22A30B75E
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 06:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhBBFsf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 00:48:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45786 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhBBFsd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Feb 2021 00:48:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1125jUYx116374;
        Tue, 2 Feb 2021 05:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=kenLy4XfNXQb01OCnERXUsEkRmrVX/7wHYI2QLjigvI=;
 b=miTjRRm6vPZ0KuE1dh2il9Kbl1xBzhDrBPQszKhFy3Z+DedC7QvSsAXCb+YsxPP2bJ87
 Txs2il3xCKtgJh4l4E+Nz2+j4KnCtN5MA8YweguxKaKAcUpR1pfsJ5qGtpI98JYFR9R/
 /DbonnJJRaGgiPPsK7ILv5luQ926MCtsSfoXbLbPslcxAkUIdDcVp+LBeVSXYIgMX/KR
 dsPqQeADZUuXmprBMX5CWiNh6w2Hsp/QlryDC4thZr4+PRHON4ZQbpESnpkSOrhtXnIf
 SECI4n318pm1taijzRPkJood0GlaAKozjm7mQMo2zpnUED6xcAzQO+z7wgNr/UwHMeh1 uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyas3a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 05:47:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1125iuO8150502;
        Tue, 2 Feb 2021 05:47:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 36dhbxqgpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 05:47:46 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1125ljWf001505;
        Tue, 2 Feb 2021 05:47:45 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Feb 2021 21:47:45 -0800
Date:   Tue, 2 Feb 2021 08:47:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: Fix an Oops in error handling
Message-ID: <YBjne8A1gn0mvQtT@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020039
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020039
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The "req" pointer is an error pointer and not NULL so this check needs
to be fixed.

Fixes: 1cf7fdf52d5a ("ceph: convert readpage to fscache read helper")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5eec6f66fe52..fb0238a4d34f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -273,7 +273,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 	if (err)
 		iput(inode);
 out:
-	if (req)
+	if (!IS_ERR_OR_NULL(req))
 		ceph_osdc_put_request(req);
 	if (err)
 		netfs_subreq_terminated(subreq, err);
-- 
2.29.2

