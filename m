Return-Path: <ceph-devel+bounces-3865-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE1CC052E9
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 10:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3662C50742F
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 08:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B201305E31;
	Fri, 24 Oct 2025 08:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hnwxe5Yp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5A7305972
	for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 08:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761295397; cv=none; b=BWx4PdIZApWGH5+J4lLlvOyg8ZApEW5GFXcqDHPw2ZboXQAhygMMfSBbzVeSP3KeUsSmfC3moX7Q0LrJZCXDHWAYu7T1MBbSiCVu7Yvhgwptg+HtL6FxJFo6R6oCx8FYcGvT3NCNKESQvxRRjMYHixTCy9UhbXcJ8Chyhkg483I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761295397; c=relaxed/simple;
	bh=qNABFLRjA28nhL5h0t5GjNyyRoTaZq2pkpbzTzbpjkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JB4VZDBX65KGy9OHI63uoXzb7USP6CNPlPcxnak4PpAF6qBlK5rVc+HpN33GwaBiQgLp8CIJQ2W03AlnlDDeIa07rYMFoho+pdvpHihxGMDS1yvK5ZS6t6CTE/Y4dArkEYd/bdOgOUsrHTvH2AtM7zsO605j3AZn+Y/yVq2/yAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hnwxe5Yp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2mVM+FZvknTGaq+hz6VSPwugdEKaAfrXhCpssczAec=;
	b=hnwxe5Yp/H3YN8iOHiBza1JiWk/qPjB4EejKyoXIvSkjoY3VVYLNhNHJJmoPKUp1O2Dk2O
	TXKnVKcu1MCeICtOmpZLDHU6gj0Egw8viK7sDcGRXL5f2LWyE6jBfKQWPgErA4cMtOo2nk
	xmt53s39lrfKQyB0Qf6Obhd+E/LeQDg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63--H1MbZ7cNUe67w8vwy2lNg-1; Fri, 24 Oct 2025 04:43:13 -0400
X-MC-Unique: -H1MbZ7cNUe67w8vwy2lNg-1
X-Mimecast-MFC-AGG-ID: -H1MbZ7cNUe67w8vwy2lNg_1761295392
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b6d7405e6a8so54469966b.1
        for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 01:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295392; x=1761900192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2mVM+FZvknTGaq+hz6VSPwugdEKaAfrXhCpssczAec=;
        b=QgdGGaw5RSaxcOrm5DhossRin+9AwpFwM3X8ikMibBhtcKSarB1WPcBRvAUri68q2B
         LKgUe2dO45adEKKM8bYwZz1WoerucS/mwMfQDQKCBYjtNepRYEvga4uB74wsdEvOkums
         BpugOWTLbFqqK5ujEKZvJImc56/HHAsBgpRqobNobuvP0ZeQFXOfz//ETqtcQ0PyWFcQ
         HsgKfBZUsqOrsg0N8eh6NOKR4ERnudfFZ3oPyU88yZk1DhT0uA5vsvkOnUvcUQdIk59s
         naDXKcLRq+LYQtkVwAg9xVzcGob7dztdMXg46aZdgPQ4UOdY8op3b+rBpUSUnn3b6Pks
         tT1Q==
X-Gm-Message-State: AOJu0YxyKOZMHzg+n5vhj4sile/NYJ3FQCQ1RPVWW5g/A118juPE27HZ
	PFvFBwtr7o8I7twAa9AqL9K9fFwLaFvsQFEA7wyqy04C3NQ8jicGybVSjd/6kTtqZsSRqYPC6az
	WS9giHPgnqeqIhmZvsZq9GgNiqVe0Wsf0k6q06gaH7VU5bViiDjeb1Yh2kEnbp/avXqyWVNh9jC
	JJJR9UPzakbJA5enimQnOXFeQfz/FPTYc6fs+Jq5emcLJ8D/Bg306wm+M=
X-Gm-Gg: ASbGnctzgazlVXUUs6NMOGL2h7sDhAQz52Y+X9eKc+da3p0ptiqEC+uLMxhuPsH9xmf
	PMuaxZDvpEqiFKy7W5aWId1nRxr8WxcFtM+XwAFBeZt9gtdv8WypOvG1BOJnF0ZsJTivFTWlu2v
	UQWyd5Lw27q6UKR+X9DT23Nfb1VYdfU2V97q5c9IF8m5Y+uS6AHi/R0h/2Cjnf6k8qBJTBTDHIq
	sEUGz575+C41lKf0xITfttkLtJBhE+Ed1RUso34OwEekTUM49ncNNZSxvGIIxKh2DzQaB9eRzRk
	XEmf/g5CplI+ndfW7jhwMOPzznSzN+uZxoHCLqChu2YVIiMMV3d+J2/Ik2lDcEZq2io8kBMsG/r
	FYyA8XTKihJbmCFnArI1tZRgKxwegmdnt
X-Received: by 2002:a17:907:1c85:b0:b46:7e8c:c0e3 with SMTP id a640c23a62f3a-b6d6bb533f0mr227698666b.20.1761295392119;
        Fri, 24 Oct 2025 01:43:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUhN3/9Ay6vxjiqFD8NjT6jaMrJJNSP5ARNhpCmGSoKcrjb4HW3vxJJXustlTOWkwKXslKQg==
X-Received: by 2002:a17:907:1c85:b0:b46:7e8c:c0e3 with SMTP id a640c23a62f3a-b6d6bb533f0mr227693366b.20.1761295391573;
        Fri, 24 Oct 2025 01:43:11 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:11 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com,
	amarkuze@redhat.com,
	akpm@linux-foundation.org,
	bsegall@google.com,
	david@redhat.com,
	dietmar.eggemann@arm.com,
	idryomov@gmail.com,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	kees@kernel.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	rppt@kernel.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	surenb@google.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	vbabka@suse.cz,
	xiubli@redhat.com,
	Slava.Dubeyko@ibm.com
Subject: [RFC PATCH 1/5] sched, fork: Wire BLOG contexts into task lifecycle
Date: Fri, 24 Oct 2025 08:42:55 +0000
Message-Id: <20251024084259.2359693-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend struct task_struct with a blog_contexts array to hold per-module
BLOG TLS pointers. Each task may have up to BLOG_MAX_MODULES (currently 8)
distinct logging contexts, allowing multiple subsystems to attach binary
loggers without interference.

The fork path (copy_process) initializes blog_contexts to NULL for new
tasks, ensuring clean initial state. The exit path (do_exit) calls
blog_tls_clear_task() to release any active contexts before task teardown,
ensuring contexts are properly recycled to the magazine pool and preventing
use-after-free scenarios.

These changes are conditional on CONFIG_BLOG. Kernels built without BLOG
support incur no storage or runtime overhead in task_struct.

This commit establishes the foundation for per-task binary logging contexts
but does not activate any logging functionality. The BLOG subsystem itself
is introduced in subsequent commits.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 include/linux/sched.h |  7 +++++++
 kernel/fork.c         | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 07576479c0ed..e381f8421a11 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1278,6 +1278,13 @@ struct task_struct {
 	/* Journalling filesystem info: */
 	void				*journal_info;
 
+/* BLOG support - max modules defined here for use by other headers */
+#define BLOG_MAX_MODULES 8
+
+#ifdef CONFIG_BLOG
+	struct blog_tls_ctx		*blog_contexts[BLOG_MAX_MODULES];
+#endif
+
 	/* Stacked block device info: */
 	struct bio_list			*bio_list;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..b06843af05a9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -24,6 +24,9 @@
 #include <linux/sched/cputime.h>
 #include <linux/sched/ext.h>
 #include <linux/seq_file.h>
+#ifdef CONFIG_BLOG
+#include <linux/blog/blog.h>
+#endif
 #include <linux/rtmutex.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
@@ -186,6 +189,29 @@ static inline struct task_struct *alloc_task_struct_node(int node)
 
 static inline void free_task_struct(struct task_struct *tsk)
 {
+#ifdef CONFIG_BLOG
+	/* Clean up any BLOG contexts */
+	{
+		struct blog_tls_ctx *contexts[BLOG_MAX_MODULES];
+		int i;
+
+		/* Step 1: Atomically detach all contexts while holding lock */
+		task_lock(tsk);
+		for (i = 0; i < BLOG_MAX_MODULES; i++) {
+			contexts[i] = tsk->blog_contexts[i];
+			tsk->blog_contexts[i] = NULL;
+		}
+		task_unlock(tsk);
+
+		/* Step 2: Release contexts outside the lock */
+		for (i = 0; i < BLOG_MAX_MODULES; i++) {
+			struct blog_tls_ctx *ctx = contexts[i];
+
+			if (ctx && ctx->release)
+				ctx->release(ctx);
+		}
+	}
+#endif
 	kmem_cache_free(task_struct_cachep, tsk);
 }
 
@@ -2012,6 +2038,17 @@ __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+
+#ifdef CONFIG_BLOG
+	/* Initialize BLOG contexts */
+	{
+		int i;
+
+		for (i = 0; i < BLOG_MAX_MODULES; i++)
+			p->blog_contexts[i] = NULL;
+	}
+#endif
+
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
-- 
2.34.1


