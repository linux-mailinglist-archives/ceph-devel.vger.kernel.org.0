Return-Path: <ceph-devel+bounces-3882-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D39BC0ECA6
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Oct 2025 16:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D0D542189A
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Oct 2025 14:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3486E2ECE80;
	Mon, 27 Oct 2025 14:58:53 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB008309EF3;
	Mon, 27 Oct 2025 14:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577133; cv=none; b=lGZyZsV0JKQtZclJNh1PPLSpurynnFXUJKFYL6V6SSLKIfsB8FYrVdKQtotvrWVwVdOBKS5tgTjJeln+dP8khw/0SH3XgCORed8AQeuPxWd/neJqhRLXlsepDUWgvich9sWfJL8R1rNbHPCFmSvfrrVNjvA2d/Fyr+1pKrurt0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577133; c=relaxed/simple;
	bh=LBaCICudemK5hqX8hGCj3Ny3uuhnAOdCVI/QK0vqE8U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFYFoMgrOfbXrgEtbyQwMPZQ6DpBc2+1Z7EzVLju3IlYts5jAMzRe9AhdVqXgNWZXvRQtUGVdfklj0WKcACG/ofrElkG4iJgrhhqkbvNqDc1oG1yD1td7IQWRVaAeEJYrNgzN+oTZw2sokSHjRYG6I2ysQ3fIGx7UhyjMZg2KVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 158CE1DE3B6;
	Mon, 27 Oct 2025 14:53:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 28FBC20028;
	Mon, 27 Oct 2025 14:53:28 +0000 (UTC)
Date: Mon, 27 Oct 2025 10:54:03 -0400
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
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph
 consumer
Message-ID: <20251027105403.2d020b8d@gandalf.local.home>
In-Reply-To: <CAO8a2SgZ8gZ0VdtBAeW8wLMDxa+Eq42ppr-99tUpiu3Tpwqz5w@mail.gmail.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	<20251024135301.0ed4b57d@gandalf.local.home>
	<CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
	<20251025105944.1a04e518@batman.local.home>
	<CAO8a2SgZ8gZ0VdtBAeW8wLMDxa+Eq42ppr-99tUpiu3Tpwqz5w@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 28FBC20028
X-Stat-Signature: btabxbh6rn4s9y75i8tsernxrkczhxfu
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18QkOO9R21LVBrW4cwrEsvG40q+N7FRrKg=
X-HE-Tag: 1761576808-121962
X-HE-Meta: U2FsdGVkX1/y2rxUidxPu/q4n8C0KJZeyG9NUfc267rFSYjiZBs19+cLFZ1Ce5eI25D7AtEIUV88ToUUjzXl12lsYbGAgOTQYwQg5nE7AyNBP1f7Bt2CIa4mybazVYojiJXsfpZEyBhhJuY8YYQW/U0XRduqJYyOMi4Xk3v9Mo1bW7ImUBopldJfQW9+NP+Moo18A+AzIZtEdv8wx0PpAiegJ9cvnQI705vJv4huyvM5eprVEIcCifuhhNtKcMV6hRz124rK2MjqUDdFccljiUkErq6KpbP2LYaxEaDSoqwcHaVp1KD7b3B6Zz26gXdoH4pIcwzKBvP09JRLCAVwIjFCzDQSEur7

On Sat, 25 Oct 2025 20:54:00 +0300
Alex Markuze <amarkuze@redhat.com> wrote:

> Please correct me if I am wrong, I was not aware that ftrace is used
> by any kernel component as the default unstructured logger.
> This is the point of BLog, having a low impact unstructured logger,
> it's not always possible or easy to provide a debug kernel where
> ftarce is both enabled and used for dumping logs.
> Having an always-on binary logger facilitates better debuggability.
> When anything happens, a client with BLog has the option to send a
> large log file with their report.
> An additional benefit is that each logging buffer is attached to the
> associated tasks and the whole module has its own separate cyclical
> log buffer.

This looks like a very specific solution trying to be a little more generic.

The more generic a solution becomes, the more "bloated" it becomes as well.
That's the nature of tracers and loggers. Ftrace was designed to be very
generic, and yes, it can be more bloated because of that. But it is also
designed to be tuned down to be a highly efficient tracer. One that can be
used in a production environment. Sure, if you enable every event, it will
cause a noticeable overhead, but ftrace is designed to surgically pick
which events should be enabled or not, keeping the overhead within the
noise.

Ftrace is more of an "infrastructure" than a tool. It provides access to
trace almost every function , but you can use that same code to implement
live kernel patching or BPF hooks to functions. The trace event and
tracepoints are part of ftrace, and are used for things other than tracing.

Perhaps it may be more suitable to make BLOG use the tracefs interface,
then to create an entirely new interface based on debugfs (which BTW, a lot
of production systems do not enable debugfs which is why ftrace uses its
own tracefs that does not depend on it).

-- Steve

