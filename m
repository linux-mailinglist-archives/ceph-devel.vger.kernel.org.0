Return-Path: <ceph-devel+bounces-943-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA9D586D866
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 01:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BA071F23928
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 00:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76492572;
	Fri,  1 Mar 2024 00:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.b="TpVOeK+l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B632568
	for <ceph-devel@vger.kernel.org>; Fri,  1 Mar 2024 00:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709253605; cv=none; b=bqKOXYjTGQaavBY+FONcrc0f4/vX7RWc3X8Mrp4YZCfnXhl1iiIeFzCQC/5zEHd9j9344jLdjyAzwpulvSWMMrKzpUCzegaLetZYaASlYc1D3fl+yePCU+GcUNKwwA4mmYMPXxDuAsWK+R1pvmBUuUBdGNXqCfQb+5BpsiSRqBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709253605; c=relaxed/simple;
	bh=lYtLzPPW/z966kwacpoZ8g46ZAY0gZ9kGfAS51bcavA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZgY84JA2fW1PqOn+buOqbY3pCwsoX3mS2XYhtvlxIxyeSg9iJO4vehPk+ox/+w0v8oU7XXJKYG+EmobKbEqm7yxCrIHaUNSao5FZ7vI1fZ7TBU8cmFd3Vfqh+kqzklf7uKCaEAntwEem6enOn2nxv2ZMpviTwNRGWrmV+QeTZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name; spf=pass smtp.mailfrom=chrisdown.name; dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.b=TpVOeK+l; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-412c1d50793so6838865e9.1
        for <ceph-devel@vger.kernel.org>; Thu, 29 Feb 2024 16:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1709253602; x=1709858402; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gV3niUCTSl6gtqi0cGOEMe9/Tm7btRuQ6YcO62YSGhA=;
        b=TpVOeK+lHsDCaPIgpWWlgKq8I5D9ULKCn0+69/2RxVQWBY03TyOlQ1iFQkiZYepVN5
         3oJODlcOc6vbtNjp9FL9JsRDCOjbU1uaBxxAVtxAIIpKpKuOpTmCoRdV9wArYE1ZF5y0
         HRXGjnC+vy3XRcdVCJJm57YRjm9YmgP5ZA9oI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709253602; x=1709858402;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gV3niUCTSl6gtqi0cGOEMe9/Tm7btRuQ6YcO62YSGhA=;
        b=DpBhb1zcP0v//pThIYrjZ0GdKWNT1F7fdUwuUDew/yEFL8h/++6Jp4cr7hsd5dZYhi
         YFrQbHAR9LaSZ1dFTiO271fsSXw7TRfLUF4de372CTFOM76DYQSl2BcPkraLVgqVj28m
         vMr5ouuF2gtiHQnf54OXSjrvaJyWP0MzRffqKaQ0BqGbA8qUIOfZGFqtRragKQH4kySN
         QNqHSbKaJcmFF6NvRekmfBnCbAWzM4uspKTmR82hrC9+kZHdScep6O0Ezp0A+VH2zwCY
         iG+tiEyOxe8M+EOkTOjdmas7yvV3Jl6pEXM8uSO0n93m8MOSExoTwUly56An1JjRQ3Ff
         Qdog==
X-Forwarded-Encrypted: i=1; AJvYcCUSNWAag1qpqGqq0d03cH8cXd4+R7js7lnVCaAOeV8p5e6O3TpL6YqeBMX0dZvPKKzmWs7XzcZIPut7jWJHhezQ+Qf1HlrjgGGDQQ==
X-Gm-Message-State: AOJu0YzXUs8haY02mQdMDee+e69tXb21AoTY9TZECNDjXPIpT8KO7Qwt
	9vhBQV8OHhMfqP2vtHR2HASu0a90PQwvHwLd4i2jfZDcBzOrxM9X1eH4DqNlFkY=
X-Google-Smtp-Source: AGHT+IEwfmcug1aTGUzafnFeCI/ObU1i6mZjItOY64bGc42eoE1907pWp003h6IR5J7XGh1bi4umjA==
X-Received: by 2002:a05:600c:4f0d:b0:412:beee:36b3 with SMTP id l13-20020a05600c4f0d00b00412beee36b3mr185074wmq.7.1709253602157;
        Thu, 29 Feb 2024 16:40:02 -0800 (PST)
Received: from localhost ([93.115.193.42])
        by smtp.gmail.com with ESMTPSA id f15-20020adffccf000000b0033dedd63382sm3045765wrs.101.2024.02.29.16.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 16:40:01 -0800 (PST)
Date: Fri, 1 Mar 2024 00:40:01 +0000
From: Chris Down <chris@chrisdown.name>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Petr Mladek <pmladek@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH net-next] Simplify net_dbg_ratelimited() dummy
Message-ID: <ZeEj4TmNGuRhfAHf@chrisdown.name>
References: <5d75ce122b5cbfe62b018a7719960e34cfcbb1f2.1709128975.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5d75ce122b5cbfe62b018a7719960e34cfcbb1f2.1709128975.git.geert+renesas@glider.be>
User-Agent: Mutt/2.2.12 (2023-09-09)

Geert Uytterhoeven writes:
>There is no need to wrap calls to the no_printk() helper inside an
>always-false check, as no_printk() already does that internally.
>
>Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

In the context of the larger printk index changes:

Acked-by: Chris Down <chris@chrisdown.name>

>---
> include/linux/net.h | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/include/linux/net.h b/include/linux/net.h
>index c9b4a63791a45948..15df6d5f27a7badc 100644
>--- a/include/linux/net.h
>+++ b/include/linux/net.h
>@@ -299,10 +299,7 @@ do {									\
> 	net_ratelimited_function(pr_debug, fmt, ##__VA_ARGS__)
> #else
> #define net_dbg_ratelimited(fmt, ...)				\
>-	do {							\
>-		if (0)						\
>-			no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); \
>-	} while (0)
>+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> #endif
>
> #define net_get_random_once(buf, nbytes)			\
>-- 
>2.34.1
>

