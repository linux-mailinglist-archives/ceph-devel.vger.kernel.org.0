Return-Path: <ceph-devel+bounces-3357-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A00B1C3C5
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 11:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CC45189B846
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 09:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFD628AAE6;
	Wed,  6 Aug 2025 09:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="P2FQjxdU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6E424677C
	for <ceph-devel@vger.kernel.org>; Wed,  6 Aug 2025 09:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754473746; cv=none; b=YYKqVZL0SUwu53GKPRK5k1ZgtNkZycbXYoVilxxBzSNllea2TWUpRPFq3hR1rXdocHo5sFcpA5x6kdz/6GLO97byYbRNw0Y9FhibQv/TBjkFc1/hAerv2IAiXabROQwPhP2a5PLM2FAOwi7E1tQUYMqBMQTwu0wColRLAFKjpFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754473746; c=relaxed/simple;
	bh=OUNTpGpOyHEACCY3f52sli6ZIozk/y/E+v4cvUaJRQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuFXWiAPjc/Q9hxB06LMHp3kgHOVOTNy/e6xmaCqDM6ddd96F4jn9VYkSWcYheDs4W5lqe++8R4fkMU4IdcY7hFi50cL9Z+o+ksqNSLAvMqIhXJNXfHTjPFh58JMqFpyP9RRKbF0kBOvPwxhP/TRCu2ZDWAKvSeEp6cDhm+RLPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=P2FQjxdU; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6155e75a9acso9732498a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 06 Aug 2025 02:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1754473742; x=1755078542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DlDihxHSTEJD5Q+/V0RYrSEM7+zdm1rlpG9EF1SpuY=;
        b=P2FQjxdUFLRRtCD7kDlfFpL9SaQ1KZqrswWj1VSPctb2X8Hk3oZh8RYy0ugr9uHAgc
         ClXu+HtKP5nMkKe+SH5qvKA/CpwZ4suk3q/55g6bQbW7LfGT6EpdXOK7SV26VuSU6lVe
         Ctr11lVOt+FMWGZUrPKIPbGWpAJzBEqBAG2uS3ROrsKhnCzJYvPuG0UcHlR8Z5BhKiel
         rg/oXUAA6OcEbm0KiLKwBcUkiLObZ8tkAMSRoIZMVBFXKHd0pjLHUQHUuqy/3MDVS39G
         cOAHhnSfDNPR6wPQZ77nSFiOQflY5z5WtEvJSOOpF4aChD829rZyWjUXJRA0lKqIMEEP
         SnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754473742; x=1755078542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3DlDihxHSTEJD5Q+/V0RYrSEM7+zdm1rlpG9EF1SpuY=;
        b=Mulhq3vSL/xUvJYaZ8CtZS06Sq0XWB/GG2lraCxRD8/q1THpKSJiVanzZHo3VNFGfJ
         bLtvdL5IT9Tjd6Ux4BGkV5uBj1RW2byNFch8/JbDgGE5MSE0Cm8cYNHyq0UhTxJPXvvk
         NkAkffMlEQLf4iq41lq3Z0WuyQbJMqpf5j2A17orwuf6FLjOcGZpsCXgNpuJeBk7KPIu
         /Z7vXF6nIZdbGKy2e/PAwQABYV7+hvAatdC8dpODVjj51Bs0poXhreez0hmjIK1P/NPX
         GUQO8+2CT7u/kxXa/pazGL4gb5fhxdYHKAlqXgAd8f/XB41pdYqC6//PhPbYPBJ+M8QN
         uFqA==
X-Forwarded-Encrypted: i=1; AJvYcCUarZvY+toQ40NZq4zb7MkYJKMqPKltzjT9ejY+xbcqxLpdwqGbKUXXBw7LEI2RflwkX5F73oniUtL0@vger.kernel.org
X-Gm-Message-State: AOJu0YwGRCixJd2K7yHmCo4VVAgb2TkJLhlNlxI4PcPTXV2NPvv514Ap
	E0+SeYiDsV6zg0IpY3WFG173RwKTmOBmqNM76hgBLnWPIElZujzUmsY97l1KFxTK2NU=
X-Gm-Gg: ASbGnct4QJxaGUyLuyYLEC5qso1USrclrw4R77ZGsbqpsXcLFsTXk141mmpa0EnqFLd
	w7ghgIgRd88Lb0sTZPtri/MqpCwfaQJ3B5vZm2OTo2p3ImR3jkisPEteay96EB3QK5SLc6tGUhp
	zERJuKEGWCqbH6CYPA/w2dl2HiXTgOJBVKz9+25aOEfqaQM+ggXDvlQr1mDG8OEfL10bf7lADXx
	a803IJiMefKe1Z2ZiUuNp0EWcrAPxydRTigfoaah8AMl08GFtV/46Tql6BgT7lbJA72OLu/0Rnx
	U/dUAzQ3862p6D+ZDE4AZLiSWY0psiwSaz+IACs/B7b070aCmGLHD/WgIY9GdUMQ2OMGhjZEhi7
	SrlepizY3LtqFHB6hIamlO2Y5tCdC66rC53DjEgtSqjlVPrytX5HCxAK5fTgA8V9rOem2NCeLr6
	vkBiQUF8rEvgGn0hIEguVasw==
X-Google-Smtp-Source: AGHT+IHw49tgHJW7XSDygJR2NggxiIk7qwiHB6yykI13Vvyz+84jOeZsCm6cwy4/ZwWs/cmFRcBtTg==
X-Received: by 2002:a05:6402:268a:b0:615:7047:4efd with SMTP id 4fb4d7f45d1cf-617960c735amr2019608a12.13.1754473742414;
        Wed, 06 Aug 2025 02:49:02 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f12d500023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f12:d500:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f00247sm10139093a12.9.2025.08.06.02.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 02:49:02 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 3/3] net/ceph/messenger: add empty check to ceph_con_get_out_msg()
Date: Wed,  6 Aug 2025 11:48:55 +0200
Message-ID: <20250806094855.268799-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250806094855.268799-1-max.kellermann@ionos.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This moves the list_empty() checks from the two callers (v1 and v2)
into the base messenger.c library.  Now the v1/v2 specializations do
not need to know about con->out_queue; that implementation detail is
now hidden behind the ceph_con_get_out_msg() function.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 net/ceph/messenger.c    |  4 +++-
 net/ceph/messenger_v1.c | 15 ++++++++++-----
 net/ceph/messenger_v2.c |  4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 424fb2769b71..8886c38a55d2 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2113,7 +2113,9 @@ struct ceph_msg *ceph_con_get_out_msg(struct ceph_connection *con)
 {
 	struct ceph_msg *msg;
 
-	BUG_ON(list_empty(&con->out_queue));
+	if (list_empty(&con->out_queue))
+		return NULL;
+
 	msg = list_first_entry(&con->out_queue, struct ceph_msg, list_head);
 	WARN_ON(msg->con != con);
 
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 516f2eeb122a..5eb6cfdbc494 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -189,12 +189,18 @@ static void prepare_write_message_footer(struct ceph_connection *con, struct cep
 
 /*
  * Prepare headers for the next outgoing message.
+ *
+ * @return false if there are no outgoing messages
  */
-static void prepare_write_message(struct ceph_connection *con)
+static bool prepare_write_message(struct ceph_connection *con)
 {
 	struct ceph_msg *m;
 	u32 crc;
 
+	m = ceph_con_get_out_msg(con);
+	if (m == NULL)
+		return false;
+
 	con_out_kvec_reset(con);
 	con->v1.out_msg_done = false;
 
@@ -208,8 +214,6 @@ static void prepare_write_message(struct ceph_connection *con)
 			&con->v1.out_temp_ack);
 	}
 
-	m = ceph_con_get_out_msg(con);
-
 	dout("prepare_write_message %p seq %lld type %d len %d+%d+%zd\n",
 	     m, con->out_seq, le16_to_cpu(m->hdr.type),
 	     le32_to_cpu(m->hdr.front_len), le32_to_cpu(m->hdr.middle_len),
@@ -256,6 +260,8 @@ static void prepare_write_message(struct ceph_connection *con)
 	}
 
 	ceph_con_flag_set(con, CEPH_CON_F_WRITE_PENDING);
+
+	return true;
 }
 
 /*
@@ -1543,8 +1549,7 @@ int ceph_con_v1_try_write(struct ceph_connection *con)
 			goto more;
 		}
 		/* is anything else pending? */
-		if (!list_empty(&con->out_queue)) {
-			prepare_write_message(con);
+		if (prepare_write_message(con)) {
 			goto more;
 		}
 		if (con->in_seq > con->in_seq_acked) {
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 90109fa0fe60..e0b5f2e2582d 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -3292,6 +3292,7 @@ static void finish_message(struct ceph_connection *con)
 
 static int populate_out_iter(struct ceph_connection *con)
 {
+	struct ceph_msg *msg;
 	int ret;
 
 	dout("%s con %p state %d out_state %d\n", __func__, con, con->state,
@@ -3337,8 +3338,7 @@ static int populate_out_iter(struct ceph_connection *con)
 			pr_err("prepare_keepalive2 failed: %d\n", ret);
 			return ret;
 		}
-	} else if (!list_empty(&con->out_queue)) {
-		struct ceph_msg *msg = ceph_con_get_out_msg(con);
+	} else if ((msg = ceph_con_get_out_msg(con)) != NULL) {
 		ret = prepare_message(con, msg);
 		if (ret) {
 			pr_err("prepare_message failed: %d\n", ret);
-- 
2.47.2


