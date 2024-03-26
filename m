Return-Path: <ceph-devel+bounces-1004-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9E988C771
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Mar 2024 16:41:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D98B1F682B2
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Mar 2024 15:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4002513D272;
	Tue, 26 Mar 2024 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FU+gkBTH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350B13C8ED
	for <ceph-devel@vger.kernel.org>; Tue, 26 Mar 2024 15:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711467395; cv=none; b=Vd65DYkcEcbWfJ0bHXmJ9BmnlJts9QVB4mu6ebvOx7LV94rI5YWfaGPjuXy2Y3H21RW502uspQ1jDRjSo5cYIoIdQVoUcUjuxcwPfwRk/z9hMh5v9i8xU6e3iF0jmk2Dj4Oy0x/wFtlH5nI82eMxOZexGvrleR7IThBBJB0rqeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711467395; c=relaxed/simple;
	bh=ed5+VWC5wvky3Uqb83H3Ghri5kxsYjWy0B0ksNy+wDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efe0Aj01GVBTVv+4m5D3TXrZFgWtqVv80lkYrjCU0s/Oez95aecibGWZO1Cr/pi/O6tMWnLozSI3lXIcjZ1p2+wlgRD/lUO/c01snoSEznwqdUjwR7Lc7nQkcMDAd4cAx3uBUUDtj1PWVkfyXryBdEbXU/zYGvahOD6s1iIJ7rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FU+gkBTH; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a4702457ccbso728814666b.3
        for <ceph-devel@vger.kernel.org>; Tue, 26 Mar 2024 08:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711467392; x=1712072192; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ePvCs1Z2FnylYkus0K9OBiNjZtXP+dPS6SCXTC+sxh0=;
        b=FU+gkBTHWtsCc+5ypB6wGMTlbF2G+LhlEQovlfiqh3LUu9qTbN6TG4l2SA/YKmrZ3+
         clwZBolzmhdNEyYW/Dn/rtgdlOZ6X+6urxg8XdduiKKupYlx0w9F0xdLyCYuAP4rrUrW
         06Gi/oz4v7k7RAJw1D0zlsqK1M9ClFRMdUxam/RqObJnSPbMCxTrbLVXP77QkyGCi07A
         TsqZwHJW2uamn7Bs3bXNb0MHGlEpBaPixQb7JgSzdtHLJxczqoxo1AXRylkGerc6c7YN
         fVjD2GxYSpJWYoSZzWGAOzOr2EodY/Eo60ZhC7/+GcKnp/a+aMGl9mxXC887KcL2c3H1
         qB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711467392; x=1712072192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePvCs1Z2FnylYkus0K9OBiNjZtXP+dPS6SCXTC+sxh0=;
        b=ZzNRm+lqT+c/JN22DU78B4VJcLwvuLZQAVQG7qCSyfSh+GWA9RG3Iw9suUWDCvzOIG
         bppUXQDnRUUVpmkKN0/8qA8KNMgAwjcOzzopmzjltmaECpDK3O/LgBksNGlixGZTC11E
         1oeUJMDfJEYvVhCxTHuIsrhckK0rOucgcvKCQQ5aHlzujFaMylUq6UgYZOOMGhFwEcKR
         +0WBXUz75XPYUGmHykl62Rs99tvu66VpT0XqmOBOcBR5lz0hocXUJsrKqG7rMy8SwRdP
         BzKghm/l3bRgRef3vODReGdf5xWNrgppyQ6MkBauIrv589bvHPxY86Hl4VgnpUAffOh5
         08rw==
X-Forwarded-Encrypted: i=1; AJvYcCXG6jdudUjEFsB6zOIMZ6I4DgWd92fq84LXKPCj96E4UAEFO0ZOUoAYlsuEjC6wh83qGAFECB53hvvPWqP2phcYudtGWBBkj3BiOA==
X-Gm-Message-State: AOJu0Ywn++5KbbCcEWJjsvSqQ34qvz8gPkU0HH3iR40JIjBlaMxqk1lE
	DLVJ/vurQanMFxy3GCEvfCvaunpYkSFFB0CMghdpLxHOCzj9yJNDrM6iYl7ox5U=
X-Google-Smtp-Source: AGHT+IHbh4n/1ZdaSBVSm9HNyyXwDDnWrgPGbIJ/GpeK7xfXhmqR2KKND9oQ7Es7phpkmhR9Fv08yg==
X-Received: by 2002:a17:906:128d:b0:a47:11a9:9038 with SMTP id k13-20020a170906128d00b00a4711a99038mr7617158ejb.58.1711467392013;
        Tue, 26 Mar 2024 08:36:32 -0700 (PDT)
Received: from alley ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id x20-20020a170906b09400b00a469e55767dsm4330686ejy.214.2024.03.26.08.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 08:36:31 -0700 (PDT)
Date: Tue, 26 Mar 2024 16:36:30 +0100
From: Petr Mladek <pmladek@suse.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Chris Down <chris@chrisdown.name>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH 0/4] printk_index: Fix false positives
Message-ID: <ZgLrfvRD63aB3gMT@alley>
References: <cover.1709127473.git.geert+renesas@glider.be>
 <ZfmqihpAyrhPn-7P@alley>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfmqihpAyrhPn-7P@alley>

On Tue 2024-03-19 16:09:01, Petr Mladek wrote:
> On Wed 2024-02-28 15:00:01, Geert Uytterhoeven wrote:
> > 	Hi all,
> > 
> > When printk-indexing is enabled, each printk() invocation emits a
> > pi_entry structure, containing the format string and other information
> > related to its location in the kernel sources.  This is even true when
> > the printk() is protected by an always-false check, as is typically the
> > case for debug messages: while the actual code to print the message is
> > optimized out by the compiler, the pi_entry structure is still emitted.
> > Hence when debugging is disabled, this leads to the inclusion in the
> > index of lots of printk formats that cannot be emitted by the current
> > kernel.
> > 
> > This series fixes that for the common debug helpers under include/.
> > It reduces the size of an arm64 defconfig kernel with
> > CONFIG_PRINTK_INDEX=y by ca. 1.5 MiB, or 28% of the overhead of
> > enabling CONFIG_PRINTK_INDEX=y.
> > 
> > Notes:
> >   - netdev_(v)dbg() and netif_(v)dbg() are not affected, as
> >     net{dev,if}_printk() do not implement printk-indexing, except
> >     for the single global internal instance of __netdev_printk().
> >   - This series fixes only debug code in global header files under
> >     include/.  There are more cases to fix in subsystem-specific header
> >     files and in sources files.
> > 
> > Thanks for your comments!
> > 
> > Geert Uytterhoeven (4):
> >   printk: Let no_printk() use _printk()
> >   dev_printk: Add and use dev_no_printk()
> >   dyndbg: Use *no_printk() helpers
> >   ceph: Use no_printk() helper
> > 
> >  include/linux/ceph/ceph_debug.h | 18 +++++++-----------
> >  include/linux/dev_printk.h      | 25 +++++++++++++------------
> >  include/linux/dynamic_debug.h   |  4 ++--
> >  include/linux/printk.h          |  2 +-
> >  4 files changed, 23 insertions(+), 26 deletions(-)
> 
> The whole series looks good to me:
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> I am going take it via printk tree for 6.10.

JFYI, the patchset has been committed into printk/linux.git, branch
for-6.10.

Best Regards,
Petr

