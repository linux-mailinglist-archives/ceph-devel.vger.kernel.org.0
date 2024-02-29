Return-Path: <ceph-devel+bounces-936-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D67B86BCDF
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 01:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2C19B242FB
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Feb 2024 00:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DEE01F614;
	Thu, 29 Feb 2024 00:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHxrnwQM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EBD107B3
	for <ceph-devel@vger.kernel.org>; Thu, 29 Feb 2024 00:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709167093; cv=none; b=jhgVswAdE+rJINQNr8oGQzRCZmwlmwtAorVkx0rLQCwCuLj6PD/Cw9JJSByQFOpOioNFMCOwyy2h/j6dd92KM/lNSyqeK2A7dcdLxtXaDw+BWQ0wO0cs+RZ7jgOqTxA0gCzgZr/5Y3rsZKJsBDAciSxBL5cCmdCGLWGbD142MuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709167093; c=relaxed/simple;
	bh=zdmDmZBOd3SFC0jwS2ekHtoLe9Wo02yDanRCzI2UXqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oZm9+BxpUQLTqHycYNBBV6WBj6573yYvUeMH0ia5dK3Czi0IeObGuhucJlEWxBUhYCKTEXl1o4oXv0QeNmgC5CpGBZ21QDbs8KWhlh1NpYxqdmIYvthzN7lQe2mJeFd0JAb8N5et4yZEQzLRNOf60KkeivX9ol4AQeu0s4nCTVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHxrnwQM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709167090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YfpEyRdMnEBOuDbLwr2jbhFRxgF9v/FYFNIfm+Be1aI=;
	b=EHxrnwQMUWvqzL8VZV1sFcE6OkaPKrhOCP3SSdutCA6JE4bS8c8ORb13MyO7ktxAb9RDQq
	mx7iadtThcSUHGZEJY8CBJKYl2hloOnoHpQWnglHaSbOzl0bPDBCf/K03rTI9VLK/lLBr7
	RQDKz3lUae0A+5Q30b9HSkW9RFs6RrA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-8pT87sWEP_KsMxrF6qSDVQ-1; Wed, 28 Feb 2024 19:38:07 -0500
X-MC-Unique: 8pT87sWEP_KsMxrF6qSDVQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29a90e49c67so170290a91.2
        for <ceph-devel@vger.kernel.org>; Wed, 28 Feb 2024 16:38:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709167085; x=1709771885;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YfpEyRdMnEBOuDbLwr2jbhFRxgF9v/FYFNIfm+Be1aI=;
        b=poPfJb/fput8jeIzZmVDFaMBqvWzGmmcH5Zyw5v9DI5SicEbIOGZhNwqACpPbOdSD3
         3DotQziVFUyWbyqaA0ik0at35p2a9s+NYtJd03Acne3D+RQTPeuJyZkzs0+E349UZFgZ
         l/FPjTccKdVOgEHB+pjza5QHxsLVlik7Roz7rpP08QhlV/qAunUA0XihjHaL7BpD+23b
         2ZG59GdtibJlrrWi76yTSxiQhF6Cx3mbbKNr+qItmqVJbeALo1TiG3zhFjllopmarjEB
         zS2a1eZwRrPhq2tLB3qCf7mb1qk51AxSkqQVFqWsSMXmrYDSYDNDRoW28jTS1sSJV9gc
         2enw==
X-Forwarded-Encrypted: i=1; AJvYcCXQ9d/zD979xsb8Vw4d6tnBMYIgroYV5SIMN9C13PAaKigxP73eZezk4bilU8IFP8UJyRioCYJcEpM7OHRa9ugk/yoYE2+zx5YXtw==
X-Gm-Message-State: AOJu0Yx7oMVjcpylSWmOFsl4gRKzWOyRVC6f7casq+u/Hu+BBQDYzQZF
	PAv2puh6r0n2WtX6kpNZt2o8DKVEqBZ09KPhTHK36QQFWym31KW/FVQ3Tbgr8LGctZxFeqJ8WYF
	YMO/fuaho7e6rXRclsI5V2SqV/PzTFelE9Gog+QU08JA4DylpeW3hgnCM1Bk=
X-Received: by 2002:a17:90a:734a:b0:29a:6cf0:57a3 with SMTP id j10-20020a17090a734a00b0029a6cf057a3mr780173pjs.8.1709167085436;
        Wed, 28 Feb 2024 16:38:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGszdfYRJZp6tlT4Iv+7U3f3pqW70sm2nHeFWfeGFuTKrfVroRvZkuQ39/PNYPi7byINkwM9g==
X-Received: by 2002:a17:90a:734a:b0:29a:6cf0:57a3 with SMTP id j10-20020a17090a734a00b0029a6cf057a3mr780152pjs.8.1709167085101;
        Wed, 28 Feb 2024 16:38:05 -0800 (PST)
Received: from [10.72.112.85] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g10-20020a17090a714a00b0029ab460019asm158574pjs.1.2024.02.28.16.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 16:38:04 -0800 (PST)
Message-ID: <b0e7dc61-d595-4f26-9db4-c223b725bc47@redhat.com>
Date: Thu, 29 Feb 2024 08:37:55 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] printk_index: Fix false positives
Content-Language: en-US
To: Geert Uytterhoeven <geert+renesas@glider.be>,
 Chris Down <chris@chrisdown.name>, Petr Mladek <pmladek@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 John Ogness <john.ogness@linutronix.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
 Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
References: <cover.1709127473.git.geert+renesas@glider.be>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <cover.1709127473.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/28/24 22:00, Geert Uytterhoeven wrote:
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
>    - netdev_(v)dbg() and netif_(v)dbg() are not affected, as
>      net{dev,if}_printk() do not implement printk-indexing, except
>      for the single global internal instance of __netdev_printk().
>    - This series fixes only debug code in global header files under
>      include/.  There are more cases to fix in subsystem-specific header
>      files and in sources files.
>
> Thanks for your comments!
>
> Geert Uytterhoeven (4):
>    printk: Let no_printk() use _printk()
>    dev_printk: Add and use dev_no_printk()
>    dyndbg: Use *no_printk() helpers
>    ceph: Use no_printk() helper
>
>   include/linux/ceph/ceph_debug.h | 18 +++++++-----------
>   include/linux/dev_printk.h      | 25 +++++++++++++------------
>   include/linux/dynamic_debug.h   |  4 ++--
>   include/linux/printk.h          |  2 +-
>   4 files changed, 23 insertions(+), 26 deletions(-)
>
This series LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


