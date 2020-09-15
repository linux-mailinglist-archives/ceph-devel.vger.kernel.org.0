Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6836526AEBE
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Sep 2020 22:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgIOUgn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Sep 2020 16:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgIOUdm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Sep 2020 16:33:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB46AC06178B
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so4628492wrl.12
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=l0OZyB3jK1MU0XGgtW1uEDqOwg807WSWps7CvqNMBMQ=;
        b=bwu7IF+p4nIUVn2Adk0j3WMz3LQw0l2kUyF3E8sASQnzK+C714p0pFM9Odcwoq3pQH
         k8xaZmWGwo4XbIo32D9iqOUQpqi9GxSglanu3r+yIE8Z/b4jS+xgWE08dWfjbZJ/tHAa
         /+tfZZ8RT6zsH967iJ5EsuqHVBAc0cudMbkHrJHxqwdA5grvnp2bAVhIILppDPkZ2lgv
         eZIOV8Q30hW4TQT0BUVicIbeKDbPilJ/oEUlaRWpA7eUOML7f9iyarL0VabCruG7b9d6
         KoBoySCY2YoT2chQj0jCpsojTuHaP9yEUkKyNP9NsTpqoWRYoWD50hFc4AACauy2GNce
         eDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l0OZyB3jK1MU0XGgtW1uEDqOwg807WSWps7CvqNMBMQ=;
        b=VWdClxmJ3Be3heMDyBLipsBdsHESPs6TCbc84G3c346FdxOY7kmrV1itG2BoSPGWTb
         cw4OBGV1nN4BGdXKAMzw7lNRN4sjzeJcZ8ANf+l7HhJpDgU4m5nO1VhJZdkeOC+Pkdme
         fG5lvjhP5T5mKvqEmTV7qis04QVm1wUeWlGhmVTAPW5h/VLTWVLnysEEVD4mN4Npa5kI
         bJNY0qhBdv8eyIZm7gSs7EwyrfOcQjUjSf5agmLCjaB7Q0Cgsrvbaa5e/6lOrhlLvCsN
         W7ul1B/9SoQNCW2ENpF+z2qXhhI1lKnLulbN1c8CVGw8P8yXDg7zaLtnp1LmbSPR1YN+
         480A==
X-Gm-Message-State: AOAM530hRS6/P2y35GITQnbkvn5D9MADA7Ivx+yjMItv5letCzDAFzUi
        2/6mZJg5d2nmkdm5fqbtL4GX7HNGP2rkpQ==
X-Google-Smtp-Source: ABdhPJyCZ0mikE5Qfotn+vLxRo7zheZyxrId3XudtkA0xjS3sLmu7tiJv1zADi5tS0B/IPfrYp4LKQ==
X-Received: by 2002:a5d:5404:: with SMTP id g4mr22221158wrv.134.1600202014329;
        Tue, 15 Sep 2020 13:33:34 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id q12sm27487250wrs.48.2020.09.15.13.33.33
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 13:33:33 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 3/3] ceph: add a note explaining session reject error string
Date:   Tue, 15 Sep 2020 22:33:23 +0200
Message-Id: <20200915203323.4688-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200915203323.4688-1-idryomov@gmail.com>
References: <20200915203323.4688-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

error_string key in the metadata map of MClientSession message
is intended for humans, but unfortunately became part of the on-wire
format with the introduction of recover_session=clean mode in commit
131d7eb4faa1 ("ceph: auto reconnect after blacklisted").

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/mds_client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index bb2d938a17ac..08f1c0c31dc2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3317,6 +3317,10 @@ static int __decode_session_metadata(void **p, void *end,
 		*p += len;
 		ceph_decode_32_safe(p, end, len, bad);
 		ceph_decode_need(p, end, len, bad);
+		/*
+		 * Match "blocklisted (blacklisted)" from newer MDSes,
+		 * or "blacklisted" from older MDSes.
+		 */
 		if (err_str && strnstr(*p, "blacklisted", len))
 			*blocklisted = true;
 		*p += len;
-- 
2.19.2

