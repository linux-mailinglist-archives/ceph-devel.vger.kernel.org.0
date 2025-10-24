Return-Path: <ceph-devel+bounces-3870-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C8302C06FD2
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 17:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B9BD24FD62D
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Oct 2025 15:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E094324B1A;
	Fri, 24 Oct 2025 15:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cf4O/7XS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F591DA62E
	for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761319982; cv=none; b=nW1LEy+8J6Muae3kbTqY02tHy2iT3epFr4LDSe7uk7azHfKclr2k5ZCX2CC5yiPhk700nTvpsbFhwNzWsBaFKD1TMfaDlnRuLIMEHeQMb+qmDJUWdqQTK/ygHGCpDP2kCvblXqO2lbAMdoYkEjm+bMAuu6t0HiELolIJJ7UAnts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761319982; c=relaxed/simple;
	bh=nBQbOeJ9fafSNstbE69IBcB658LxnYwg80HiKAtkHkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ERosw5PQLobzBlyU8GBxpKH4Y5ZSSdqkr1vIeZJ0VxHRN8fiBVnX9ISCw5kJ9ekbUeJNBeoomtV3iGl0pOkprw6cMMrJPZ5jcARmQOh2ybuoRF6jRcuLucj0KEP30CnuxZggL/4PlKN3m7xAcGHucBgCI12RjIxfa/X2i26UZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cf4O/7XS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761319979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qFb+WOeWRjNA4xYaoA738u6I2as3i8020Ro6oXjpffQ=;
	b=Cf4O/7XSIVJElZmcB6g3ZgavtJv5Mp7qj/QnNNo33JqwkXvEiclObqEFlZ1TGap6X1QYQl
	9wRDwRKY3HQY2XXQ1PkFNCgtlWJ0T8E4ND0YyoJLLYNISoKfPLqNxkCJrwecgGmRTwVi5K
	IdPlPpqocHH0YFNJwEHta/SKLRUcP14=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-PgT_iZsbN0yKuqo9DmobTg-1; Fri, 24 Oct 2025 11:32:56 -0400
X-MC-Unique: PgT_iZsbN0yKuqo9DmobTg-1
X-Mimecast-MFC-AGG-ID: PgT_iZsbN0yKuqo9DmobTg_1761319975
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-470fd59d325so10094875e9.0
        for <ceph-devel@vger.kernel.org>; Fri, 24 Oct 2025 08:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761319975; x=1761924775;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFb+WOeWRjNA4xYaoA738u6I2as3i8020Ro6oXjpffQ=;
        b=dlinZGlMc2gHdf9CZT1K4oqxRG3RogNnIonOtgbx6D5jH0BkVTNJWRes+knOtZDzfM
         U8EL08M+Tna83VmJujT5OgZ6oR0N4ju7g2Lq2pxKaSkV6YyxAJ6xpzX7SZVzkeWILBNw
         n8/0vaygXOZK95T8uOJ312uAYNBQykXmpnYYDXgSXJKIQWrnd/cUQu0vVBAu3svHnxjv
         PP5VZIwBvMmef551jkblvY5+pHpaSYkS69pQXJ+Qkj4Jn+4vtC71BeaKxfSxKx4ZUaZ6
         /OesLNV6MmARmcek9U1BE7J2o3jIaYsJ2OGL7IKVNwp0GJBq1q482CHjYOKDV7ez/GEJ
         +R9w==
X-Forwarded-Encrypted: i=1; AJvYcCVgtXBYAR1Wd9OFFlLWuhwLLrK/og3izbUpmdIoinOCNrG5qcwNXfLlBxUKRd8KokSvxyQBcCvk7L8c@vger.kernel.org
X-Gm-Message-State: AOJu0YzgMRz+KECk4E9sDbApydkedx265scCLw2aIbGNYYbozJFvfC+5
	VlF+4AD++hfgYiw1/RYb9hChLNNBFJPJ5fWmWVOyFASIDWvuZBnbtpBhXQq5nOyCqqFd+9WBj7l
	rfkp9hnDKJkgxxvuSbz/IhAHvUkR5uokrRIcCSjWN4+2g9e6P32niOSt/222g7HmkSxtnxxQ=
X-Gm-Gg: ASbGnct8AORC5zPGeQ4O3456gRM8vIGO1haISsRvVTCyj9Yp2FPdauH+UWHIL2fsTzg
	2beiH9gklTVBUKvwQV8zlix00xTRPtgruXwHKoqccnGcx04Me3BvojaXpSEjz4oxCCLqnPNXLmN
	O30OvoOVeq5Jj67cHTryN+jlT9nz80jbul1yDLL0XVBNOOkgRoMKhUoSTfDET8WZx3JbHT/MEDk
	x/Bd+X9FfV5T7Xc6iiLJceQzygpL5Uf3Ha1LMiKjdxRObR2PPPewT4fOdnBc6pzqkY3Aae9Y/oa
	O9+GimClpUh5Zb9ak9IF1pwQRHQe0XHEAgvEQKX21CfI8Oqak94hZ/BvGubvQbyzF9qchYo3HcE
	5Tgmzc7vQ8xwbziIeNheOdHkRYxzleo+K/8gCXCWkZCXjiWiz0rqByVOeo++qAkzx/jZPOFwi9K
	oPVzn12Jy0V8C6C2A6+x4s7iPRXyc=
X-Received: by 2002:a05:600c:5026:b0:470:bcc4:b07c with SMTP id 5b1f17b1804b1-47117925d38mr228933225e9.37.1761319975203;
        Fri, 24 Oct 2025 08:32:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEk3FLSarboUuhSt9mQ9AgqM+55zrUrrCCjoH7Es1EmB3qSUYkMO5a7UnFUEL85UmUL54f5qQ==
X-Received: by 2002:a05:600c:5026:b0:470:bcc4:b07c with SMTP id 5b1f17b1804b1-47117925d38mr228932985e9.37.1761319974703;
        Fri, 24 Oct 2025 08:32:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf2ef9fsm97056175e9.13.2025.10.24.08.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 08:32:54 -0700 (PDT)
Message-ID: <94d62ba4-e203-408e-9200-b153ce97555d@redhat.com>
Date: Fri, 24 Oct 2025 17:32:52 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph
 consumer
To: Alex Markuze <amarkuze@redhat.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com,
 dietmar.eggemann@arm.com, idryomov@gmail.com, mingo@redhat.com,
 juri.lelli@redhat.com, kees@kernel.org, lorenzo.stoakes@oracle.com,
 mgorman@suse.de, mhocko@suse.com, rppt@kernel.org, peterz@infradead.org,
 rostedt@goodmis.org, surenb@google.com, vschneid@redhat.com,
 vincent.guittot@linaro.org, vbabka@suse.cz, xiubli@redhat.com,
 Slava.Dubeyko@ibm.com
References: <20251024084259.2359693-1-amarkuze@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.10.25 10:42, Alex Markuze wrote:
> Motivation: improve observability in production by providing subsystemsawith
> a logger that keeps up with their verbouse unstructured logs and aggregating
> logs at the process context level, akin to userspace TLS.
> 
> Binary LOGging (BLOG) introduces a task-local logging context: each context
> owns a single 512 KiB fragment that cycles through “ready → in use → queued for
> readers → reset → ready” without re-entering the allocator. Writers copy the
> raw parameters they already have; readers format them later when the log is
> inspected.
> 
> BLOG borrows ideas from ftrace (captureabinary  data now, format later) but
> unlike ftrace there is no global ring. Each module registers its own logger,
> manages its own buffers, and keeps the state small enough for production use.
> 
> To host the per-module pointers we extend `struct task_struct` with one
> additional `void *`, in line with other task extensions already in the kernel.
> Each module keeps independent batches: `alloc_batch` for contexts with
> refcount 0 and `log_batch` for contexts that have been filled and are waiting
> for readers. The batching layer and buffer management were migrated from the
> existing Ceph SAN logging code, so the behaviour is battle-tested; we simply
> made the buffer inline so every composite stays within a single 512 KiB
> allocation.
> 
> The patch series lands the BLOG library first, then wires the task lifecycle,
> and finally switches Ceph’s `bout*` logging macros to BLOG so we exercise the
> new path.
> 
> Patch summary:
>    1. sched, fork: wire BLOG contexts into task lifecycle
>       - Adds `struct blog_tls_ctx *blog_contexts[BLOG_MAX_MODULES]` to
>         `struct task_struct`.
>       - Fork/exit paths initialise and recycle contexts automatically.
> 
>    2. lib: introduce BLOG (Binary LOGging) subsystem
>       - Adds `lib/blog/` sources and headers under `include/linux/blog/`.
>       - Each composite (`struct blog_tls_pagefrag`) consists of the TLS
>         metadata, the pagefrag state, and an inline buffer sized at
>         `BLOG_PAGEFRAG_SIZE - sizeof(struct blog_tls_pagefrag)`.
> 
>    3. ceph: add BLOG scaffolding
>       - Introduces `include/linux/ceph/ceph_blog.h` and `fs/ceph/blog_client.c`.
>       - Ceph registers a logger and maintains a client-ID map for the reader
>         callback.
> 
>    4. ceph: add BLOG debugfs support
>       - Adds `fs/ceph/blog_debugfs.c` so filled contexts can be drained.
> 
>    5. ceph: activate BLOG logging
>       - Switches `bout*` macros to BLOG, making Ceph the first consumer.

Hi!

You CCed plenty of MM folks, and I am sure most of them observe "this 
doesn't seem to touch any core-mm files" and wonder "what's hiding in 
there that requires a pair of MM eyes".

Is there anything specific we should be looking at (and if so, in which 
patch)?

-- 
Cheers

David / dhildenb


