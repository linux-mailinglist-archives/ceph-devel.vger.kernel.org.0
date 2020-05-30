Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847E81E925B
	for <lists+ceph-devel@lfdr.de>; Sat, 30 May 2020 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgE3Pes (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 May 2020 11:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgE3Peq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 30 May 2020 11:34:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494D8C08C5C9
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l10so7101574wrr.10
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WW5GfPCR+be6vTs+awi41HxGU5be5Ui8VZCu7EZ9XbQ=;
        b=dth24AKSMmw+T5NOGcajuwqGSDRgWnW56GYO2sriOkf2GpB7U8lt84DWkl2TgEd9Xj
         zjpNfsDl/vEgSNu/fIWjHLljRMZTsVpnje8GT65DbhQXDuARoPxV0JG/s8pNfDjadGgM
         wxkoFcRUDXhkncn7QhKAAh+xm0/TW+1ZyP9lpSzm5tOSOiFc38GYmXAlHn42RhG1jpN0
         sjVL+0jxFxCP2AaSMIsnC/G6UOIDQknolqBJeEaaLIM1pLUGmeAnW0WqJ5tvlxeFitHb
         +C087VPC8eQ6SekM7UlWq7w45TH0LS5bcES4WWYfIlPizoG0uEf2PYFrs+LcclBQGAdr
         Q5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WW5GfPCR+be6vTs+awi41HxGU5be5Ui8VZCu7EZ9XbQ=;
        b=Um2juROyq+cjuHGy9NgTtC/eU07wzPMcNy5FW12kbTeylqyLPqLVPvUWQLT0QrMYOQ
         XvKqYcLq7CVaiEXmgazHgyGnXUR6UgM4F9ZW0G/PJbwoPtp5hdzxr22yvtqHcDs2K7tM
         qDXDphZSmHt0ZykU6CpXd8ZW1JlORqwhViTOIyCPgRTsw2MeK8bfz4KgpdqBAgm7IAqC
         DRBUjxT3kgTCpVqHI7FG8VMuOadZe5AHkZ3vkOx0A0UyYw3kryjcLOJgjvCTafEPgOMt
         5GgjJukYwZslc4Qximu5yFPN9QgqZTN52Qp099wIWNySkFixXocr/FbWP9XKFALA+Q00
         G96w==
X-Gm-Message-State: AOAM532elsVwlOxYAqwL8i8vOpPHRbIldtvUxCuraDHOl5qzv7HFHKCU
        mox6DciBXE/+d1jjHoyS3oG6oTC1F1A=
X-Google-Smtp-Source: ABdhPJzWasLlgSiSoqkbATEsPcsn/71htoxcxEZLcaaXzNf6bdre6gwCkB9OYsVT53N1Ail6Niip9g==
X-Received: by 2002:adf:b348:: with SMTP id k8mr15167635wrd.157.1590852883689;
        Sat, 30 May 2020 08:34:43 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id z132sm4835068wmc.29.2020.05.30.08.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 08:34:43 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 5/5] libceph: read_from_replica option
Date:   Sat, 30 May 2020 17:34:39 +0200
Message-Id: <20200530153439.31312-6-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200530153439.31312-1-idryomov@gmail.com>
References: <20200530153439.31312-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Expose replica reads through read_from_replica=balance and
read_from_replica=localize.  The default is to read from primary
(read_from_replica=no).

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/libceph.h |  2 ++
 net/ceph/ceph_common.c       | 39 ++++++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c        |  5 ++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

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
index 44770b60bc38..9bab3e9a039b 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -265,6 +265,7 @@ enum {
 	Opt_key,
 	Opt_ip,
 	Opt_crush_location,
+	Opt_read_from_replica,
 	/* string args above */
 	Opt_share,
 	Opt_crc,
@@ -274,6 +275,19 @@ enum {
 	Opt_abort_on_full,
 };
 
+enum {
+	Opt_read_from_replica_no,
+	Opt_read_from_replica_balance,
+	Opt_read_from_replica_localize,
+};
+
+static const struct constant_table ceph_param_read_from_replica[] = {
+	{"no",		Opt_read_from_replica_no},
+	{"balance",	Opt_read_from_replica_balance},
+	{"localize",	Opt_read_from_replica_localize},
+	{}
+};
+
 static const struct fs_parameter_spec ceph_parameters[] = {
 	fsparam_flag	("abort_on_full",		Opt_abort_on_full),
 	fsparam_flag_no ("cephx_require_signatures",	Opt_cephx_require_signatures),
@@ -290,6 +304,8 @@ static const struct fs_parameter_spec ceph_parameters[] = {
 	fsparam_u32	("osdkeepalive",		Opt_osdkeepalivetimeout),
 	__fsparam	(fs_param_is_s32, "osdtimeout", Opt_osdtimeout,
 			 fs_param_deprecated, NULL),
+	fsparam_enum	("read_from_replica",		Opt_read_from_replica,
+			 ceph_param_read_from_replica),
 	fsparam_string	("secret",			Opt_secret),
 	fsparam_flag_no ("share",			Opt_share),
 	fsparam_flag_no ("tcp_nodelay",			Opt_tcp_nodelay),
@@ -472,6 +488,24 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 			return err;
 		}
 		break;
+	case Opt_read_from_replica:
+		switch (result.uint_32) {
+		case Opt_read_from_replica_no:
+			opt->osd_req_flags &= ~(CEPH_OSD_FLAG_BALANCE_READS |
+						CEPH_OSD_FLAG_LOCALIZE_READS);
+			break;
+		case Opt_read_from_replica_balance:
+			opt->osd_req_flags |= CEPH_OSD_FLAG_BALANCE_READS;
+			opt->osd_req_flags &= ~CEPH_OSD_FLAG_LOCALIZE_READS;
+			break;
+		case Opt_read_from_replica_localize:
+			opt->osd_req_flags |= CEPH_OSD_FLAG_LOCALIZE_READS;
+			opt->osd_req_flags &= ~CEPH_OSD_FLAG_BALANCE_READS;
+			break;
+		default:
+			BUG();
+		}
+		break;
 
 	case Opt_osdtimeout:
 		warn_plog(&log, "Ignoring osdtimeout");
@@ -580,6 +614,11 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 		}
 		seq_putc(m, ',');
 	}
+	if (opt->osd_req_flags & CEPH_OSD_FLAG_BALANCE_READS) {
+		seq_puts(m, "read_from_replica=balance,");
+	} else if (opt->osd_req_flags & CEPH_OSD_FLAG_LOCALIZE_READS) {
+		seq_puts(m, "read_from_replica=localize,");
+	}
 
 	if (opt->flags & CEPH_OPT_FSID)
 		seq_printf(m, "fsid=%pU,", &opt->fsid);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 4ce6cdc744e4..22733e844be1 100644
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

