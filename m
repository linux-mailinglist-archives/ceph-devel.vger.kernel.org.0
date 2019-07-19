Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3186E764
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jul 2019 16:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfGSOc1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 10:32:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:41204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727717AbfGSOc0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 10:32:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 276D3B005;
        Fri, 19 Jul 2019 14:32:25 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 1/4] libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer
Date:   Fri, 19 Jul 2019 15:32:19 +0100
Message-Id: <20190719143222.16058-2-lhenriques@suse.com>
In-Reply-To: <20190719143222.16058-1-lhenriques@suse.com>
References: <20190719143222.16058-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 include/linux/ceph/buffer.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/buffer.h b/include/linux/ceph/buffer.h
index 5e58bb29b1a3..11cdc7c60480 100644
--- a/include/linux/ceph/buffer.h
+++ b/include/linux/ceph/buffer.h
@@ -30,7 +30,8 @@ static inline struct ceph_buffer *ceph_buffer_get(struct ceph_buffer *b)
 
 static inline void ceph_buffer_put(struct ceph_buffer *b)
 {
-	kref_put(&b->kref, ceph_buffer_release);
+	if (b)
+		kref_put(&b->kref, ceph_buffer_release);
 }
 
 extern int ceph_decode_buffer(struct ceph_buffer **b, void **p, void *end);
