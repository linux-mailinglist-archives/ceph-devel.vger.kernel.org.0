Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361F3788AD
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfG2Jnf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:35 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22670 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfG2Jne (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:34 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S3;
        Mon, 29 Jul 2019 17:43:00 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 01/15] libceph: introduce ceph_extract_encoded_string_kvmalloc
Date:   Mon, 29 Jul 2019 09:42:43 +0000
Message-Id: <1564393377-28949-2-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S3
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUJwFxUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiVAQBelf4pnXJvgAAsg
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we are going to extract the encoded string, there
would be a large string encoded.

Especially in the journaling case, if we use the default
journal object size, 16M, there could be a 16M string
encoded in this object.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 include/linux/ceph/decode.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
index 450384f..555879f 100644
--- a/include/linux/ceph/decode.h
+++ b/include/linux/ceph/decode.h
@@ -104,8 +104,11 @@ static inline bool ceph_has_room(void **p, void *end, size_t n)
  *     beyond the "end" pointer provided (-ERANGE)
  *   - memory could not be allocated for the result (-ENOMEM)
  */
-static inline char *ceph_extract_encoded_string(void **p, void *end,
-						size_t *lenp, gfp_t gfp)
+typedef void * (mem_alloc_t)(size_t size, gfp_t flags);
+extern void *ceph_kvmalloc(size_t size, gfp_t flags);
+static inline char *extract_encoded_string(void **p, void *end,
+					   mem_alloc_t alloc_fn,
+					   size_t *lenp, gfp_t gfp)
 {
 	u32 len;
 	void *sp = *p;
@@ -115,7 +118,7 @@ static inline char *ceph_extract_encoded_string(void **p, void *end,
 	if (!ceph_has_room(&sp, end, len))
 		goto bad;
 
-	buf = kmalloc(len + 1, gfp);
+	buf = alloc_fn(len + 1, gfp);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -133,6 +136,18 @@ static inline char *ceph_extract_encoded_string(void **p, void *end,
 	return ERR_PTR(-ERANGE);
 }
 
+static inline char *ceph_extract_encoded_string(void **p, void *end,
+						size_t *lenp, gfp_t gfp)
+{
+	return extract_encoded_string(p, end, kmalloc, lenp, gfp);
+}
+
+static inline char *ceph_extract_encoded_string_kvmalloc(void **p, void *end,
+							 size_t *lenp, gfp_t gfp)
+{
+	return extract_encoded_string(p, end, ceph_kvmalloc, lenp, gfp);
+}
+
 /*
  * skip helpers
  */
-- 
1.8.3.1


