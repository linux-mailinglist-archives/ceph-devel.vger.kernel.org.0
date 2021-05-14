Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C03B3803A7
	for <lists+ceph-devel@lfdr.de>; Fri, 14 May 2021 08:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhENGbp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 May 2021 02:31:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2595 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhENGbp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 May 2021 02:31:45 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FhJVb3FnZzkWM4;
        Fri, 14 May 2021 14:27:51 +0800 (CST)
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 14:30:32 +0800
Received: from localhost.localdomain (10.175.102.38) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 14:30:32 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
CC:     <ceph-devel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH -next] ceph: make symbol 'ceph_netfs_read_ops' static
Date:   Fri, 14 May 2021 06:39:53 +0000
Message-ID: <20210514063953.3242049-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The sparse tool complains as follows:

fs/ceph/addr.c:316:37: warning:
 symbol 'ceph_netfs_read_ops' was not declared. Should it be static?

This symbol is not used outside of addr.c, so marks it static.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c1570fada3d8..5dfd18d84a3b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -313,7 +313,7 @@ static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
 		ceph_put_cap_refs(ci, got);
 }
 
-const struct netfs_read_request_ops ceph_netfs_read_ops = {
+static const struct netfs_read_request_ops ceph_netfs_read_ops = {
 	.init_rreq		= ceph_init_rreq,
 	.is_cache_enabled	= ceph_is_cache_enabled,
 	.begin_cache_operation	= ceph_begin_cache_operation,

