Return-Path: <ceph-devel+bounces-930-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F3B86B1B9
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 15:29:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2E1AB2620E
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 14:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23EC159573;
	Wed, 28 Feb 2024 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="QJGreJLG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B1D1586E7
	for <ceph-devel@vger.kernel.org>; Wed, 28 Feb 2024 14:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709130536; cv=none; b=g0tfPib2TKigj91SwjmbBNFujo6LHXllMbUQy+tjOo9eBRO7Ppn3qhCXMyX8kfnUm0Kbh0ZoXCmCKRwfLdYzFUK9aphdlfychs9k43puC/YlFPj/ky5tZkiZGqmlZCgjrwnsvvTYvWWlEvtVNi+VpQvsX5IjPgg6SnBkk5f2O2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709130536; c=relaxed/simple;
	bh=ct0J5ub7CpVcB4T4gt1kVD0ubxu04oViM8dbCjDL748=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z18MARTrEH/t1OAGrcLtIQSr5a5/OO01XzVK23zvx0Mg8z4dz5LsqJZkCaq4/Lr5XVMLaEIQ9Dx18o1Wb3ScIwwgiGn1YIe96tfEBEYDeCBqvuWNEksE9by6h4FooEiTi7SPjpozszxbygbk9v9Ju+Qd9S/TDnOYW6I1ir0NkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=QJGreJLG; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7c794deb6cdso246351939f.0
        for <ceph-devel@vger.kernel.org>; Wed, 28 Feb 2024 06:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1709130533; x=1709735333; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R/VNqbMlIFoO8TrqZKnmVvV4jmXzQqgaOCYXnoYlwZo=;
        b=QJGreJLGrQHOeLn1LitB29HLjbs8NWpL4u3tuEl6kyTNxj8EaYpmQn3zjE8QnYkkuc
         gkKrCB+vFwTQQGImkQ7MNjuzlF3VeIcFdc8We76u+Vc3wU6KgSyvhSxeF1qjO36+20Ry
         l4JlyU33YzSlvWEq+cnoj/2wycMUYw1O4lPI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709130533; x=1709735333;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/VNqbMlIFoO8TrqZKnmVvV4jmXzQqgaOCYXnoYlwZo=;
        b=asHeoZ2b7iruoicK25GFdfclQbmoX+Ci0SQ9H1kFVp0c8e5LdAf25eumcABy5y64xN
         bJczywbnFB3yfNshq0vrYib4cMdjn3LErmudYsfnZ4mvxkCtfWEXRwy6GnFSQr+m35BX
         uzJUlgmFK/QUl/bm9E7awbBhq/VmB+56EAWviqVA6CZzTnU4RiKyNi6uSco1GZcCoH4K
         Zpvi1cWcq8HoG+4kKAzmIkLcEIU4pZlPqEaSAfVjIjflX3ZJx9WenyHXkyEYnOAi9INu
         39ADR7/BylMdRUB33cSqk6t4FOq178qvGrrJxOvb0UbffFO96ERK/ILFfa3UehKnKbQ1
         FX8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWC7YkjMIkePoCS7n7zg8+hI1eAlvwW2ip3j1//T25tWmSkuf44xYfjZLs5UX7GAhQlfsoMksM0CqJGfeMb02J15s0IkkuI3II99A==
X-Gm-Message-State: AOJu0Yzg0HNepRbbwKWYzUQ5xj0fiC6eEivHRdJntjvpqA57kAa9YOoJ
	TMy4QXF9A15LDR0iR2Wh6M283B0G9nrPxmGUc5QXGcHW0jOXMJj7foHT2Yt5sA==
X-Google-Smtp-Source: AGHT+IFOZDnUA8vKuXo3dN5Rd+MluGSLpBBSUnhYeINpz/2oocuaHObawPbh5/FeNQN3U1KrZrFzIw==
X-Received: by 2002:a05:6602:1547:b0:7c7:cd51:4483 with SMTP id h7-20020a056602154700b007c7cd514483mr11825011iow.4.1709130533625;
        Wed, 28 Feb 2024 06:28:53 -0800 (PST)
Received: from [172.22.22.28] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.googlemail.com with ESMTPSA id a8-20020a056638004800b00474a4b05cfesm472386jap.83.2024.02.28.06.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 06:28:53 -0800 (PST)
Message-ID: <9a8657f9-e6c8-49b2-9597-21b2192491d3@ieee.org>
Date: Wed, 28 Feb 2024 08:28:51 -0600
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] Simplify net_dbg_ratelimited() dummy
Content-Language: en-US
To: Geert Uytterhoeven <geert+renesas@glider.be>,
 Chris Down <chris@chrisdown.name>, Petr Mladek <pmladek@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
 Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
 Jeff Layton <jlayton@kernel.org>
Cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
References: <5d75ce122b5cbfe62b018a7719960e34cfcbb1f2.1709128975.git.geert+renesas@glider.be>
From: Alex Elder <elder@ieee.org>
In-Reply-To: <5d75ce122b5cbfe62b018a7719960e34cfcbb1f2.1709128975.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/24 8:05 AM, Geert Uytterhoeven wrote:
> There is no need to wrap calls to the no_printk() helper inside an
> always-false check, as no_printk() already does that internally.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

This looks fine.  The only difference I see is that no_printk()
returns a value (always 0), while the old way does not.  You
could cast the result to void to avoid that.

Otherwise:

Reviewed-by: Alex Elder <elder@linaro.org>



> ---
>   include/linux/net.h | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index c9b4a63791a45948..15df6d5f27a7badc 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -299,10 +299,7 @@ do {									\
>   	net_ratelimited_function(pr_debug, fmt, ##__VA_ARGS__)
>   #else
>   #define net_dbg_ratelimited(fmt, ...)				\
> -	do {							\
> -		if (0)						\
> -			no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); \
> -	} while (0)
> +	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>   #endif
>   
>   #define net_get_random_once(buf, nbytes)			\


