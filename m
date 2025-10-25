Return-Path: <ceph-devel+bounces-3874-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 178BAC09250
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Oct 2025 17:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 424B6404B40
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Oct 2025 15:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F033016F7;
	Sat, 25 Oct 2025 15:00:00 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE24A301460;
	Sat, 25 Oct 2025 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761404400; cv=none; b=b9BiEFGDmxKzcqeWpjr8DEf+Zy5VxGDlsmjF0RoP6h5CklzcOfrcJvvrtf0+lQSXyoiPA18BsoKUKayIYWGJ5YWsyaMtKXq/NHsvr2Q/XEUCl1VNUqbBcTOx/ZYHpnIQVjLcCRqDkdzATjksFkbUjGPV9LCb07YM9NWa5gNzw2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761404400; c=relaxed/simple;
	bh=1JO+EN464i94sSls5+ZcLrofTbrCCyyLTqwSUlS3HrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xh65xheGk8rUV+9Mfk8zVSo/ukC6q8BCGLegxIKJ2LlwajIC8HlomQaI9mme8WDHESLCsq3ZvAfCbSGwFepMlClGiYx9JC7cC6u5E6XqnYt7LWxA751Txf7XOZdEI0+KGOZStNqAoHl0D6Fll1YIeTw+S2V2ISNNAkOuT68OdkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A92C56348;
	Sat, 25 Oct 2025 14:59:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 6111E20026;
	Sat, 25 Oct 2025 14:59:44 +0000 (UTC)
Date: Sat, 25 Oct 2025 10:59:44 -0400
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
Message-ID: <20251025105944.1a04e518@batman.local.home>
In-Reply-To: <CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	<20251024135301.0ed4b57d@gandalf.local.home>
	<CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pc3a3bfpb9hcnm9iaxnw6do4upq79gnw
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 6111E20026
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18nBZUO/jhduNiWRSKvYzbdBO98QxDlMpA=
X-HE-Tag: 1761404384-373123
X-HE-Meta: U2FsdGVkX1+4lKsGaA7TKsVLzBxuvMoWhjOFNULKRM5Mg0jsoYWD1a6mSIKQSnfaBR1DcTcfFpjvTbAMWYdymXTSdrSlXJdDkC3RM+lJ9uDjCpgSdxpk2ZxqRN11r1TPLtIVgMvSOdISCn0CFXKrE8tZ9SSWJagKo/U0ktmYl1lsN4n/M1if5zi06ycFz7Avb5aPvoUU9WaNalGOu6WGpUMPlpULHnk5g1BcY7RNnuNHnrTdZJSHT8TnDmxXQ13NCZAMIjzV0EXdr2FEBN9TBuvgBR8R77k6XtR/24SGMAy/GckjuLyBujCgzeWdfxKzmrP4UdmfShDq+dNV5a4mDdcPqo29q1dr

On Sat, 25 Oct 2025 13:50:39 +0300
Alex Markuze <amarkuze@redhat.com> wrote:

> First of all, Ftrace is for debugging and development; you won't see
> components or kernel modules run in production with ftrace enabled.
> The main motivation is to have verbose logging that is usable for
> production systems.

That is totally untrue. Several production environments use ftrace. We
have it enabled and used in Chromebooks and in Android. Google servers
also have it enabled.


> The second improvement is that the logs have a struct task hook which
> facilitates better logging association between the kernel log and the
> user process.
> It's especially handy when debugging FS systems.

So this is for use with debugging too?

> 
> Specifically we had several bugs reported from the field that we could
> not make progress on without additional logs.

This still doesn't answer my question about not using ftrace. Heck,
when I worked for Red Hat, we used ftrace to debug production
environments. Did that change?

-- Steve

