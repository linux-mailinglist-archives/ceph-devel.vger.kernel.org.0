Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B47C2CF467
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Dec 2020 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgLDSzE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Dec 2020 13:55:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47555 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgLDSzD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Dec 2020 13:55:03 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1klGDl-0003af-DS; Fri, 04 Dec 2020 18:54:21 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: remove redundant assignment to variable i
Date:   Fri,  4 Dec 2020 18:54:21 +0000
Message-Id: <20201204185421.1149669-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable i is being initialized with a value that is never read
and it is being updated later with a new value in a for-loop.  The
initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8f1d7500a7ec..b70937caa7a7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1243,7 +1243,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 {
 	struct ceph_msg *msg;
 	struct ceph_mds_session_head *h;
-	int i = -1;
+	int i;
 	int extra_bytes = 0;
 	int metadata_key_count = 0;
 	struct ceph_options *opt = mdsc->fsc->client->options;
-- 
2.29.2

