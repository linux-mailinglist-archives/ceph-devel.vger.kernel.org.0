Return-Path: <ceph-devel+bounces-3871-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C47C07914
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 19:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 474D01C48694
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 17:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3795032B997;
	Fri, 24 Oct 2025 17:43:53 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C510E31B807;
	Fri, 24 Oct 2025 17:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761327833; cv=none; b=n0JXfeA3BgLOG3M7wFRopGpSAlMHy9U5ktKsmZdOPvoSuvD06miNA55O+3Jv/yDJSDdJ4Y41fZNS2m0l63mPv08hetKWHRt60F/rfMZKUmoFfbP+Zf2VikrJ/YxMGj1sPDsSj7b0ODS83xZ9YMq31sHRi7mlxOuM7yg+bfTmcGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761327833; c=relaxed/simple;
	bh=PsWBr7YsFWtWhF7FlL5K1rDQ9l6gbNdQ9htJrJgJxZs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brN0VYipnwUeIhixuuEefd7QZ11vKiR9d+I6n5hcbUGI3oA+kVZf6TFHWVldOj/6Oozq1FFINS7+lCHAB94JdDHsXumestCL2caQMdyoFEOhys8YiAPTR2CFv087Sa1+IEDRWXxnxGsD36SjwwLDfPJpjPVKIKN6HjFBvtcHD1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C157ABE5AA;
	Fri, 24 Oct 2025 17:43:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id E11351B;
	Fri, 24 Oct 2025 17:43:40 +0000 (UTC)
Date: Fri, 24 Oct 2025 13:44:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com,
 idryomov@gmail.com, mingo@redhat.com, juri.lelli@redhat.com,
 kees@kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de,
 mhocko@suse.com, rppt@kernel.org, peterz@infradead.org, surenb@google.com,
 vschneid@redhat.com, vincent.guittot@linaro.org, vbabka@suse.cz,
 xiubli@redhat.com, Slava.Dubeyko@ibm.com
Subject: Re: [RFC PATCH 1/5] sched, fork: Wire BLOG contexts into task
 lifecycle
Message-ID: <20251024134409.72275dd4@gandalf.local.home>
In-Reply-To: <20251024084259.2359693-2-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	<20251024084259.2359693-2-amarkuze@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 66riooj1xrzu98ghf9wd6u9fqad75sf7
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: E11351B
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19CRueCw1nm5uT9RZSPlGEKzC/t+oG4hig=
X-HE-Tag: 1761327820-638118
X-HE-Meta: U2FsdGVkX18hDnsr4TkruwiFojbQTdlVwxH+CtBQ+69mybQlxSP/NF57Bx/vKlv0n4Fh6saZcnBJAwvpzxaBEholvuYmbRZbFXHJuRuvVxt5K2/gBoYSDPi4S4hcpP3sVHxcMJYYWBxgUDYmOzgc2VUR/LCvcFlI8wHIMqM5LY4frd8vuPH+u+hYpku7Cxe+BWkUUCnfEjDdpXOYdB+Y/rVQjgiYxCbE4g8kGBpP9r9ASG1M0PVCWH8xefZLyQhz6L5nS/XjRorGJJKUIEIQjbhjnendjVQJBjh/E0NfJif17t0CtiMF/iDeok9mAbaGHOnFgNBhQ6h+Mnjpp73ixlJRBz7e1vDU4P++/gqlVS8lxCqmgP6fuw+4G2tJuLSN



On Fri, 24 Oct 2025 08:42:55 +0000
Alex Markuze <amarkuze@redhat.com> wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 07576479c0ed..e381f8421a11 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1278,6 +1278,13 @@ struct task_struct {
>  	/* Journalling filesystem info: */
>  	void				*journal_info;
>  
> +/* BLOG support - max modules defined here for use by other headers */
> +#define BLOG_MAX_MODULES 8
> +
> +#ifdef CONFIG_BLOG
> +	struct blog_tls_ctx		*blog_contexts[BLOG_MAX_MODULES];
> +#endif
> +
>  	/* Stacked block device info: */
>  	struct bio_list			*bio_list;
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3da0f08615a9..b06843af05a9 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -24,6 +24,9 @@
>  #include <linux/sched/cputime.h>
>  #include <linux/sched/ext.h>
>  #include <linux/seq_file.h>
> +#ifdef CONFIG_BLOG
> +#include <linux/blog/blog.h>
> +#endif

The proper way to do this is to have the #ifdef in the header file and not
in the C file.

>  #include <linux/rtmutex.h>
>  #include <linux/init.h>
>  #include <linux/unistd.h>
> @@ -186,6 +189,29 @@ static inline struct task_struct *alloc_task_struct_node(int node)
>  
>  static inline void free_task_struct(struct task_struct *tsk)
>  {
> +#ifdef CONFIG_BLOG
> +	/* Clean up any BLOG contexts */
> +	{

There should be a function that gets called here that frees up the context.
This does not belong in the fork.c file.

	blog_free(task);

In the header file have:

#ifdef CONFIG_BLOG
[..]
void blog_free(struct task_struct *task);
#else
static inline blog_free(struct task_struct *task)
{
}
#endif /* CONFIG_BLOG */



> +		struct blog_tls_ctx *contexts[BLOG_MAX_MODULES];
> +		int i;
> +
> +		/* Step 1: Atomically detach all contexts while holding lock */
> +		task_lock(tsk);
> +		for (i = 0; i < BLOG_MAX_MODULES; i++) {
> +			contexts[i] = tsk->blog_contexts[i];
> +			tsk->blog_contexts[i] = NULL;
> +		}
> +		task_unlock(tsk);
> +
> +		/* Step 2: Release contexts outside the lock */
> +		for (i = 0; i < BLOG_MAX_MODULES; i++) {
> +			struct blog_tls_ctx *ctx = contexts[i];
> +
> +			if (ctx && ctx->release)
> +				ctx->release(ctx);
> +		}
> +	}
> +#endif
>  	kmem_cache_free(task_struct_cachep, tsk);
>  }
>  
> @@ -2012,6 +2038,17 @@ __latent_entropy struct task_struct *copy_process(
>  	p = dup_task_struct(current, node);
>  	if (!p)
>  		goto fork_out;
> +
> +#ifdef CONFIG_BLOG
> +	/* Initialize BLOG contexts */
> +	{
> +		int i;
> +
> +		for (i = 0; i < BLOG_MAX_MODULES; i++)
> +			p->blog_contexts[i] = NULL;
> +	}
> +#endif

Same here.

> +
>  	p->flags &= ~PF_KTHREAD;
>  	if (args->kthread)
>  		p->flags |= PF_KTHREAD;

-- Steve


