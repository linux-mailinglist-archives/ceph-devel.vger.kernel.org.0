Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27B31E8195
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgE2PUM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgE2PUA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 11:20:00 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB393C08C5C6
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:59 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id e10so2045043edq.0
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9SPpEyHygm7X5ge3cCYe93ZYDuTCyOGE4DpRBdSh5QE=;
        b=MW2leP16SmB/U1DIBWtl7B/eDK/WZ/VITxjDMLL/1DQpz80OuB20wuHp6W8P1IdCTG
         Ds0qgNpbHFK2yzKTa1jePL9EJFWwnjLbu57lmK54qHYABL/n46isfr0bTyz7YyHTYBcn
         CYQJIPzK4PHOCB0+zW9W+ZJ/0LPdv/FG/cRtzXoVIPizQiJ0J9C0mVNrD5pHEU9oQ2xG
         d2V03UnjP3GerUswruvbWqdcvId/p9CBfm7boj5JWJWdwho9CEhYgjk7xlDV9hxZy+31
         CtfylkJCmpTrovrjTg1UoFTC3GXj2Ka51Ykvc/m7Ddf+ZjPwZo0O0aeZ07KrJN5YLHei
         xmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9SPpEyHygm7X5ge3cCYe93ZYDuTCyOGE4DpRBdSh5QE=;
        b=ZSEW9EwfuunbJFESnhkEYqmGfZL8r9nJdGe9pA3mk+QAAqI4ITHmo2NKcJjPHem1pF
         8m99M2ny0zduA5KPDbDXzBIuPmmRIUzRNNmjoPvlRwyPJq1coNSAvwiqWXrL5wXEtMS+
         ac4B2GBdABm4yvN0jFyX1rZQwGhF3qHloqtfbOG+cHPaLw4hf/Cfc6gwQpCqoy/vme/1
         6oSTuv2nHOKODPI4SeR+/LsU7SZbRQl3jAZ+yNf8y1XKOSeQ1gRYu+Qwi3p2mlM3GYaM
         TEwtOLzvu0teEhESgjjL1Kypu+VApHfe2ZRqmF0aClneu36eDTdX4hqOhoqveGhWeYu5
         CRHA==
X-Gm-Message-State: AOAM533mYCBo2RuVJ1BMABYkqRdNYf3rwbKhr71+GiQiNX5e1Qk74/aC
        z3VzqaMbmdEQN0G2hgbcSg5WyRSBThA=
X-Google-Smtp-Source: ABdhPJyCVf0NMlMumIbcBKzB8JeyDpYuFbVwQ6jyH3OhChvm2LaG26TaQadzcYE91p+MI/A1X9c80Q==
X-Received: by 2002:a50:fd83:: with SMTP id o3mr8577194edt.329.1590765598122;
        Fri, 29 May 2020 08:19:58 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id cd17sm6616663ejb.115.2020.05.29.08.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:19:57 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5/5] libceph: read_policy option
Date:   Fri, 29 May 2020 17:19:52 +0200
Message-Id: <20200529151952.15184-6-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200529151952.15184-1-idryomov@gmail.com>
References: <20200529151952.15184-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Expose balanced and localized reads through read_policy=balance
and read_policy=localize.  The default is to read from primary.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/libceph.h |  2 ++
 net/ceph/ceph_common.c       | 26 ++++++++++++++++++++++++++
 net/ceph/osd_client.c        |  5 ++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 4733959f1ec7..0a9f807ceda6 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -52,6 +52,8 @@ struct ceph_options {
 	unsigned long osd_idle_ttl;		/* jiffies */
 	unsigned long osd_keepalive_timeout;	/* jiffies */
 	unsigned long osd_request_timeout;	/* jiffies */
+	unsigned int osd_req_flags;  /* CEPH_OSD_FLAG_*, applied to
+					each OSD request */
 
 	/*
 	 * any type that can't be simply compared or doesn't need
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 6d495685ee03..1a834cb0d04d 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -265,6 +265,7 @@ enum {
 	Opt_key,
 	Opt_ip,
 	Opt_crush_location,
+	Opt_read_policy,
 	/* string args above */
 	Opt_share,
 	Opt_crc,
@@ -274,6 +275,17 @@ enum {
 	Opt_abort_on_full,
 };
 
+enum {
+	Opt_read_policy_balance,
+	Opt_read_policy_localize,
+};
+
+static const struct constant_table ceph_param_read_policy[] = {
+	{"balance",	Opt_read_policy_balance},
+	{"localize",	Opt_read_policy_localize},
+	{}
+};
+
 static const struct fs_parameter_spec ceph_parameters[] = {
 	fsparam_flag	("abort_on_full",		Opt_abort_on_full),
 	fsparam_flag_no ("cephx_require_signatures",	Opt_cephx_require_signatures),
@@ -290,6 +302,8 @@ static const struct fs_parameter_spec ceph_parameters[] = {
 	fsparam_u32	("osdkeepalive",		Opt_osdkeepalivetimeout),
 	__fsparam	(fs_param_is_s32, "osdtimeout", Opt_osdtimeout,
 			 fs_param_deprecated, NULL),
+	fsparam_enum	("read_policy",			Opt_read_policy,
+			 ceph_param_read_policy),
 	fsparam_string	("secret",			Opt_secret),
 	fsparam_flag_no ("share",			Opt_share),
 	fsparam_flag_no ("tcp_nodelay",			Opt_tcp_nodelay),
@@ -470,6 +484,18 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 			return err;
 		}
 		break;
+	case Opt_read_policy:
+		switch (result.uint_32) {
+		case Opt_read_policy_balance:
+			opt->osd_req_flags |= CEPH_OSD_FLAG_BALANCE_READS;
+			break;
+		case Opt_read_policy_localize:
+			opt->osd_req_flags |= CEPH_OSD_FLAG_LOCALIZE_READS;
+			break;
+		default:
+			BUG();
+		}
+		break;
 
 	case Opt_osdtimeout:
 		warn_plog(&log, "Ignoring osdtimeout");
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 15c3afa8089b..da7046db9fbe 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2425,11 +2425,14 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 
 static void account_request(struct ceph_osd_request *req)
 {
+	struct ceph_osd_client *osdc = req->r_osdc;
+
 	WARN_ON(req->r_flags & (CEPH_OSD_FLAG_ACK | CEPH_OSD_FLAG_ONDISK));
 	WARN_ON(!(req->r_flags & (CEPH_OSD_FLAG_READ | CEPH_OSD_FLAG_WRITE)));
 
 	req->r_flags |= CEPH_OSD_FLAG_ONDISK;
-	atomic_inc(&req->r_osdc->num_requests);
+	req->r_flags |= osdc->client->options->osd_req_flags;
+	atomic_inc(&osdc->num_requests);
 
 	req->r_start_stamp = jiffies;
 	req->r_start_latency = ktime_get();
-- 
2.19.2

