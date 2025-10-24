Return-Path: <ceph-devel+bounces-3872-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EF974C07995
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 19:53:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B7244FEBC2
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 17:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49297343D7A;
	Fri, 24 Oct 2025 17:52:48 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A927A28314A;
	Fri, 24 Oct 2025 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761328368; cv=none; b=J3sZENc5qVd9NfNW6MArK/kvm8lcQ2MNR0nZmBdbWQqBRJqmOq5xynhCrQ5PNrNfgmyYG5ezHVmodS9cCyGwOedxE9SAwZ6eHKJjaMUJvvI3xYV3DBYxCmYsap8AohfR5RnGzuMRBwAufDJlujgKK/yfjzD05rBgq2/q0vLlUKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761328368; c=relaxed/simple;
	bh=jwCZ9Szb8mJarpOhY+DhUu9lYM5DqnikWZbNvw+HY3U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSPfiYFnvg4+BJkKHwVeMGGexmQGtnQ8np0bvu750SGbfDVHPJnVq1ufRv2Ax/2y7CEF3wWCVp+WqEqc9xjZ9OlVsvHUHi6/+feQn2xqnY1MqAfCLv8DNZY73U7TbtQYWRZLQ9eZdba2rQXUJATwWWtTnvvj7uz2Hzpe8Vuj1gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1434988C4E;
	Fri, 24 Oct 2025 17:52:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 3528A80014;
	Fri, 24 Oct 2025 17:52:32 +0000 (UTC)
Date: Fri, 24 Oct 2025 13:53:01 -0400
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
Message-ID: <20251024135301.0ed4b57d@gandalf.local.home>
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6x1d69shcekb9xwi81uzzujg83hzkb37
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 3528A80014
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18Il+RPgBw+4y/Ol7NLnuI2IjUEEWEcKgE=
X-HE-Tag: 1761328352-50590
X-HE-Meta: U2FsdGVkX19E8qyxD0KBCanmO5HEjEeVw85UOUdVtIZFFJHxSdhRzzuTOgQ5V4tZ23nAtpGUqOrxEtZSBTDgJr8Ukz2f5OQlctoC2nenIodpUFxlGK4TvDYeldYDN+U+gkIGYVOtWFBkFCUqIW+47AFLYAQ+SUcSw7RkMJcYA8wLoN2WGKOzxQi1SK1mkO95k0D+0Mo3tJ7fiWrqnjYRTRCK87BKA7QTVC4RC6puo3wsXv8vKUk/8cPkVxcAQC0sIlfQul0YbGnVJ8bzlJK2eO1zy5wrg/bjHX4k7WzcvRwXVdCKrhC70dOJxVhJjBh0GtdrE+rjmHDZGV8TOs3hHVJADyW6P8Vk

On Fri, 24 Oct 2025 08:42:54 +0000
Alex Markuze <amarkuze@redhat.com> wrote:

> Motivation: improve observability in production by providing subsystemsawith 
> a logger that keeps up with their verbouse unstructured logs and aggregating
> logs at the process context level, akin to userspace TLS. 
> 

I still don't understand the motivation behind this.

What exactly is this doing that the current tracing infrastructure can't do?

-- Steve

