Return-Path: <ceph-devel+bounces-966-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF33F875ED7
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Mar 2024 08:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 695912845FA
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Mar 2024 07:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875E65026F;
	Fri,  8 Mar 2024 07:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="rOFY+bfK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBBF4F61C
	for <ceph-devel@vger.kernel.org>; Fri,  8 Mar 2024 07:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709884380; cv=none; b=Z7K8QpWTgCfkmNwH6C7dUXxY6lS4gq0ZFYY2KePgJt8BorQ6W1FJT86ZRSUQkwqqxwbsnIlOLiM91bK7LyKwKraZdHJma1G2Dpx3fDXM0jlZYmvtWL7uS1nmEaUlOBMYcwlhF/hn01wpuWz2Lr39jpFkOUExnqR9N/3H65FzGBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709884380; c=relaxed/simple;
	bh=sH4bAKDnIswJKnbTcqpk0Pb3FW7/UPFUpIR+aBApz4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R4eNpgo59n+D3Z3cOvUFXsD0gzLn8SnYhp3z4TxsJMtXnL8h75dEQHgIUcuqZayrw1ctYLHuF+sxd8iTIO2XhOtcM0e2E4LTp/9GRWZj+YaUnYtRvnXcCAwsHbUxpX1NFntKf6Jt8STkNi9XyHZW8CivxViZ37S9tPZeVknYMzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=rOFY+bfK; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a44665605f3so256264866b.2
        for <ceph-devel@vger.kernel.org>; Thu, 07 Mar 2024 23:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1709884376; x=1710489176; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hrvCXGaVO3HhvR4A5xt8TDit+qLJ9i7NLCGUzaXWqIQ=;
        b=rOFY+bfK+k8+GVG7m5U9B3i2k0CHJlG1bQPzVjFG6hEfEKbfsJ8ty0BXbr/l8SOZ36
         b1Libwo+P0O519HMzwnrc3bSvuLYAc66Jox3XPUV0AROzk+X5APywrZbmKaVqdPlGnQq
         7kG4z9LIM0C0AGbXlcZ2+ka7IFIvl7RVsyKAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709884376; x=1710489176;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrvCXGaVO3HhvR4A5xt8TDit+qLJ9i7NLCGUzaXWqIQ=;
        b=CLDRj5lQT934Tnsvpif2TZn08/Fodnt/3rsyq2uFQHohvHhTwjBAUaOW8an7ybkB9Y
         4BKhdU+/3giy2XdUFWs4KL1YGa0SudBwzj7i8SE6LnDHrP/fjto2VMau1EuEVCxIfaq9
         fiIhmSTe0xPJjHV6fzuFmyBFe79GZqOlerq+YrTYIagaRbGPPHVXH+RnWS+wVHhJprLc
         9paP8DK1QdSeykArcCWj3lPbRnsOttTFbiHs/NSR1lho49sxMEEsXiQI9bKAeY4C5Uug
         +od7n0yQGZGcDVoX1dw2hodv4dkDZJo5SE7xfOMh33B6PTExfxZRGj8UjDcTit7udgge
         zLgA==
X-Forwarded-Encrypted: i=1; AJvYcCVj1u81FypT4pHH75i/9+sL9Yvk9N+GbqdfUYUGyJhaSj6Z2jJkzkr77EGnnhII8oVYo4Zd1sppwP7QQUAhn5+buB/ixcB2GxoK9Q==
X-Gm-Message-State: AOJu0Yyey7x+vhgB8s3gsHMH9tedGzxg1ltqQiTy9eQ6vvCFXZ247v47
	2rYR9gU8Vkgvnphw9fao5NxzhyAC8esEUEHT35FtGIIPuQ+sz2taZfRGPgOCSzvY1Uj6D1vvlHK
	2DSYlO7ccelpcblW7tpl1CKqjVZWd/UFJQ/hfjg==
X-Google-Smtp-Source: AGHT+IGfxe+G6Hzhhm3qO2+tkAluEdwQIf++vT61Cv18s0V9jevPsUAy++K+ZRtxdczK/SgeeJRbLSjfJGJhUS+augI=
X-Received: by 2002:a17:906:a2cf:b0:a44:488d:8e42 with SMTP id
 by15-20020a170906a2cf00b00a44488d8e42mr13783793ejb.66.1709884376420; Thu, 07
 Mar 2024 23:52:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1668172.1709764777@warthog.procyon.org.uk> <ZelGX3vVlGfEZm8H@casper.infradead.org>
 <1831809.1709807788@warthog.procyon.org.uk>
In-Reply-To: <1831809.1709807788@warthog.procyon.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 8 Mar 2024 08:52:44 +0100
Message-ID: <CAJfpegv8X0PY7PvxEF=zEwRbdZ7yZZcwB80iDO+XLverognx+g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Replace ->launder_folio() with flush and wait
To: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, 
	Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	netfs@lists.linux.dev, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, 
	ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, devel@lists.orangefs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 7 Mar 2024 at 11:36, David Howells <dhowells@redhat.com> wrote:

>  (2) invalidate_inode_pages2() is used in some places to effect invalidation
>      of the pagecache in the case where the server tells us that a third party
>      modified the server copy of a file.  What the right behaviour should be
>      here, I'm not sure, but at the moment, any dirty data will get laundered
>      back to the server.  Possibly it should be simply invalidated locally or
>      the user asked how they want to handle the divergence.

Skipping ->launder_page will mean there's a window where the data
*will* be lost, AFAICS.

Of course concurrent cached writes on different hosts against the same
region (the size of which depends on how the caching is done) will
conflict.

But if concurrent writes are to different regions, then they shouldn't
be lost, no?  Without the current ->launder_page thing I don't see how
that could be guaranteed.

Thanks,
Miklos

