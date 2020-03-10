Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC0118088D
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 20:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCJTuz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 15:50:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36467 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgCJTuy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Mar 2020 15:50:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id g62so2759891wme.1
        for <ceph-devel@vger.kernel.org>; Tue, 10 Mar 2020 12:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GTI1lhGOtT5DQuyB6ZVfXBa1OAJXi8m5CNTStyrQhUg=;
        b=qtZbGPztB0ACQjvhqZ+M241u5E39puJ5mRZaHEaydLoi2ti1xdzknjuMgghAjGaqxx
         mLqsG9ilhR0C2Nkf0eJP11IF5luc8ivOUSnIT3kiGKi4WmDu9QIE+caw3SHzzezbbxL6
         xDTO9VKkNsHm4kFDTtLnaERjYUr3LOVbBH+fpeiLEUB2AGjwi10CXUTlaXL/ccaoDP//
         SAUoePxvYhRJsBMhhfMrXhB/a04qcqtVQ50IeP1ZoJsDm4i+DJRwbqaE4XMmhalFge/G
         tF4xRqE/THQrts8nkFoa4njRaQhosgCJn7HM+o0R+6tEETlSKftX4osHgAkqNktE7vge
         yEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GTI1lhGOtT5DQuyB6ZVfXBa1OAJXi8m5CNTStyrQhUg=;
        b=cZt0Mmy2gOXFDGX5urbuErHjO4/lSCPzC0lnLVHAszsjwL1LK39Vd6cLeK+TQNIFU5
         glyGRexf3LH340aMVUNH/9Smz9mFq7uwXbSZAE+tr4r4/O1OBnQO/zc3O1ZiRGEHAlcM
         X+B6XSlvUuzlw91ZXIFc+em9kRD2oSYrivYsh23k9VLkxoIZam7a3tRFYpPOvqj8ACce
         7qJQi0ydPgqUkyX7tvrsx4qRISY3oWoXfHlx7gacoXkM+VpK8DtictzsKIt1hsIn1ZnE
         qxYi5Y09JKDAH5Xtc4S9mfTRhkujs2VYtXb/s+5cIfZBKLfG0FjjIG72JqZWCBvfsI5v
         bA1g==
X-Gm-Message-State: ANhLgQ1OFsIUM1u0CEefeumeGrIav93QE+IAF6W3pgHVGn6TplqasqNf
        bX+DYa+32emDe1YMOXbf/dOCHiEH5O8=
X-Google-Smtp-Source: ADFU+vsyMvfQub7269thFip7VfklRytj1AptsRrOt4zuCzS+epoiAnScme45ppHoARx0WhhbeXbMAA==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr3676885wmj.150.1583869851861;
        Tue, 10 Mar 2020 12:50:51 -0700 (PDT)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i7sm52548473wro.87.2020.03.10.12.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 12:50:51 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH] libceph: fix alloc_msg_with_page_vector() memory leaks
Date:   Tue, 10 Mar 2020 20:50:37 +0100
Message-Id: <20200310195037.9518-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Make it so that CEPH_MSG_DATA_PAGES data item can own pages,
fixing a bunch of memory leaks for a page vector allocated in
alloc_msg_with_page_vector().  Currently, only watch-notify
messages trigger this allocation, and normally the page vector
is freed either in handle_watch_notify() or by the caller of
ceph_osdc_notify().  But if the message is freed before that
(e.g. if the session faults while reading in the message or
if the notify is stale), we leak the page vector.

This was supposed to be fixed by switching to a message-owned
pagelist, but that never happened.

Fixes: 1907920324f1 ("libceph: support for sending notifies")
Reported-by: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/messenger.h |  7 ++++---
 net/ceph/messenger.c           |  9 +++++++--
 net/ceph/osd_client.c          | 14 +++-----------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index c4458dc6a757..76371aaae2d1 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -175,9 +175,10 @@ struct ceph_msg_data {
 #endif /* CONFIG_BLOCK */
 		struct ceph_bvec_iter	bvec_pos;
 		struct {
-			struct page	**pages;	/* NOT OWNER. */
+			struct page	**pages;
 			size_t		length;		/* total # bytes */
 			unsigned int	alignment;	/* first page */
+			bool		own_pages;
 		};
 		struct ceph_pagelist	*pagelist;
 	};
@@ -356,8 +357,8 @@ extern void ceph_con_keepalive(struct ceph_connection *con);
 extern bool ceph_con_keepalive_expired(struct ceph_connection *con,
 				       unsigned long interval);
 
-extern void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-				size_t length, size_t alignment);
+void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
+			     size_t length, size_t alignment, bool own_pages);
 extern void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
 				struct ceph_pagelist *pagelist);
 #ifdef CONFIG_BLOCK
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5b4bd8261002..f8ca5edc5f2c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3248,12 +3248,16 @@ static struct ceph_msg_data *ceph_msg_data_add(struct ceph_msg *msg)
 
 static void ceph_msg_data_destroy(struct ceph_msg_data *data)
 {
-	if (data->type == CEPH_MSG_DATA_PAGELIST)
+	if (data->type == CEPH_MSG_DATA_PAGES && data->own_pages) {
+		int num_pages = calc_pages_for(data->alignment, data->length);
+		ceph_release_page_vector(data->pages, num_pages);
+	} else if (data->type == CEPH_MSG_DATA_PAGELIST) {
 		ceph_pagelist_release(data->pagelist);
+	}
 }
 
 void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-		size_t length, size_t alignment)
+			     size_t length, size_t alignment, bool own_pages)
 {
 	struct ceph_msg_data *data;
 
@@ -3265,6 +3269,7 @@ void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
 	data->pages = pages;
 	data->length = length;
 	data->alignment = alignment & ~PAGE_MASK;
+	data->own_pages = own_pages;
 
 	msg->data_length += length;
 }
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 51810db4130a..998e26b75a78 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -962,7 +962,7 @@ static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
 		BUG_ON(length > (u64) SIZE_MAX);
 		if (length)
 			ceph_msg_data_add_pages(msg, osd_data->pages,
-					length, osd_data->alignment);
+					length, osd_data->alignment, false);
 	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
 		BUG_ON(!length);
 		ceph_msg_data_add_pagelist(msg, osd_data->pagelist);
@@ -4433,9 +4433,7 @@ static void handle_watch_notify(struct ceph_osd_client *osdc,
 							CEPH_MSG_DATA_PAGES);
 					*lreq->preply_pages = data->pages;
 					*lreq->preply_len = data->length;
-				} else {
-					ceph_release_page_vector(data->pages,
-					       calc_pages_for(0, data->length));
+					data->own_pages = false;
 				}
 			}
 			lreq->notify_finish_error = return_code;
@@ -5424,9 +5422,6 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	return m;
 }
 
-/*
- * TODO: switch to a msg-owned pagelist
- */
 static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 {
 	struct ceph_msg *m;
@@ -5440,7 +5435,6 @@ static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 
 	if (data_len) {
 		struct page **pages;
-		struct ceph_osd_data osd_data;
 
 		pages = ceph_alloc_page_vector(calc_pages_for(0, data_len),
 					       GFP_NOIO);
@@ -5449,9 +5443,7 @@ static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 			return NULL;
 		}
 
-		ceph_osd_data_pages_init(&osd_data, pages, data_len, 0, false,
-					 false);
-		ceph_osdc_msg_data_add(m, &osd_data);
+		ceph_msg_data_add_pages(m, pages, data_len, 0, true);
 	}
 
 	return m;
-- 
2.19.2

