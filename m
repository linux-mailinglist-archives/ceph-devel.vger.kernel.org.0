Return-Path: <ceph-devel+bounces-986-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D560880040
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 16:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D82C11F23416
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 15:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF52C657D1;
	Tue, 19 Mar 2024 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DizG0a9m"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37149657C6
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710860944; cv=none; b=RILBS1wkyU6yc0Mk4xMtJVzmL4yu2sJoTOOSD5BOCLAO/wSIvARGlSKyP6+I9Ab8pKZ41d5/aN+ImngDH1YNgRmdOeYIeEhglyiVjy6JWtMfdQKje9ycB8Wglrmz4y3o6KNSZ+5p8n0BYFZT9O12abCItPBvQ5HgqqZNbloECsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710860944; c=relaxed/simple;
	bh=AduthGbtQ503NWc/iPovz6pKbBm8npo69sGP7oQmalc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQcZbEU84hjCDfWLCnSr2oXqeHD1l0EwL3lAS/YkNwt+nPe0+OfttFU6WqDp4cNEmO5kwSZC+S0yyhmxtIpczi1wctaSby13IVEXQf5GNwsECQYp04TfN1xXIkXSDtqwLr0M92Sv4zEG/Baknp3L37El3jNNr1XUN9Jm1MECxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DizG0a9m; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a450bedffdfso693338466b.3
        for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 08:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710860940; x=1711465740; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8vVW1HzP6IOcVuRYdPUYojDY6rzYnYjkQOqlmjORT00=;
        b=DizG0a9mRs2JYkrg7/n/6oZ7h0KsYJtZDVNmIjG1y2muDmfjm69wWeqfGQKECndFay
         mDqR5a6vgZGdr3cr1FLB3ONUqH2ct1wP3xtZB+F0CkEDhOW1ioLOYyNZ5NAvmMab7e+7
         YnFjgAim086t6DnN7ApNjZpXiaJmkc/JYtocW5VjhxulmuNPTNB1XkvO+I2jMjVejeXc
         HFBt7UuXEwoHVeheGPaFRXP4+CQJVtliiGRM5zbBG3a3j8ovy/lcqTWGkLfyPSDrMnAm
         iox0tVRbms2FEL2dseEslYJjTRyup3aYJNfhG8Q7q3PAM2iUJPWKnvKAElejpV4t/Xsh
         HUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710860940; x=1711465740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vVW1HzP6IOcVuRYdPUYojDY6rzYnYjkQOqlmjORT00=;
        b=lGMBP8bs71KArmt/9D6Er4bg/9uBNWikPXxlCxwp9Y+1yU7HMvLqYsub+20+Mmg+2G
         flVXGFPjQNTwq5GomJCfh5sBCBY86lVZWbRsnfMCNzPCN0elkO5mokQWo3PbJ7e3hiGF
         gK6xI26mUbFe7T7m2kJYh2BeasU8kdw5L4CE/IGm9f9ov05SYekZ8UBYahsYBWgLGYwr
         Twp77sbrIBxMeG0hDsS+u+ZzIbU4UKJgH9RUPccLMRQebtf2aloRVHJXKbT2XtAEAuqi
         vwPyTeanMO0JS3YhkyP/lbMA/RA6tqXab6AKyjsBRFRwB0Xk00wIiI5s4zpDBmbdTxod
         c9PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxQT4hfrcXgO43RVXHzbni3qJcNqbnGj2CDYhyhfgI83Ko9xtyHjilm6SukO1riBB2/BYMhYEBgCOBKZo/cXdKVRK/vOxehojltQ==
X-Gm-Message-State: AOJu0Yy4DgMnsTHGkrl/vfYnzmF/omejnfWVoAYmyy9fBmhu/L5c7S3G
	6TLXpBe/pf/rEo+orbraWYeHyPdM5tLkpuAddDTj9f1He2L9Q3Njn++1nEoD78E=
X-Google-Smtp-Source: AGHT+IEU4aA3OJtwbmANEftZa3Y1K8Y1Av3UtRZT7xLYjrH5u09EsLG01f4jd+nbMYggdaVPSMdzDg==
X-Received: by 2002:a17:906:3105:b0:a46:13a9:b78e with SMTP id 5-20020a170906310500b00a4613a9b78emr10602241ejx.2.1710860940584;
        Tue, 19 Mar 2024 08:09:00 -0700 (PDT)
Received: from alley (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id d15-20020a170906344f00b00a46e07cd1fcsm809541ejb.133.2024.03.19.08.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 08:09:00 -0700 (PDT)
Date: Tue, 19 Mar 2024 16:08:58 +0100
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
Message-ID: <ZfmqihpAyrhPn-7P@alley>
References: <cover.1709127473.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1709127473.git.geert+renesas@glider.be>

On Wed 2024-02-28 15:00:01, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> When printk-indexing is enabled, each printk() invocation emits a
> pi_entry structure, containing the format string and other information
> related to its location in the kernel sources.  This is even true when
> the printk() is protected by an always-false check, as is typically the
> case for debug messages: while the actual code to print the message is
> optimized out by the compiler, the pi_entry structure is still emitted.
> Hence when debugging is disabled, this leads to the inclusion in the
> index of lots of printk formats that cannot be emitted by the current
> kernel.
> 
> This series fixes that for the common debug helpers under include/.
> It reduces the size of an arm64 defconfig kernel with
> CONFIG_PRINTK_INDEX=y by ca. 1.5 MiB, or 28% of the overhead of
> enabling CONFIG_PRINTK_INDEX=y.
> 
> Notes:
>   - netdev_(v)dbg() and netif_(v)dbg() are not affected, as
>     net{dev,if}_printk() do not implement printk-indexing, except
>     for the single global internal instance of __netdev_printk().
>   - This series fixes only debug code in global header files under
>     include/.  There are more cases to fix in subsystem-specific header
>     files and in sources files.
> 
> Thanks for your comments!
> 
> Geert Uytterhoeven (4):
>   printk: Let no_printk() use _printk()
>   dev_printk: Add and use dev_no_printk()
>   dyndbg: Use *no_printk() helpers
>   ceph: Use no_printk() helper
> 
>  include/linux/ceph/ceph_debug.h | 18 +++++++-----------
>  include/linux/dev_printk.h      | 25 +++++++++++++------------
>  include/linux/dynamic_debug.h   |  4 ++--
>  include/linux/printk.h          |  2 +-
>  4 files changed, 23 insertions(+), 26 deletions(-)

The whole series looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>

I am going take it via printk tree for 6.10.

I am sorry that I haven't looked at it in time before the merge
window for 6.9. I have been snowed under various tasks. The changes
are not complicated. But they also are not critical to be pushed
an expedite way.

Best Regards,
Petr

