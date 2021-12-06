Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACB946930E
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Dec 2021 10:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbhLFKBK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Dec 2021 05:01:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241535AbhLFKBJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Dec 2021 05:01:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638784660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PnvAnVPJKE7LfWzQLfAFgVcDbTSvkeVJoOpSZgUcg5U=;
        b=SXq8IQcRWflRy/wMNzwYIuo+nvH6ZmKjyieMAZfbEg5/3sc17MNuZ4+W05pn9dpAs3pKZS
        SaOz1FkBn/6rxwg9uOW2AyA3SEdizCBO5gPXrdyRMKIDPjme5AFqwPIgfbI02tuf4QXsrh
        8o+pUt1PKEdsxF0vjCV8njnddnaiS+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-wzW486haOTS23zgk5ChRgQ-1; Mon, 06 Dec 2021 04:57:39 -0500
X-MC-Unique: wzW486haOTS23zgk5ChRgQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68DC010144ED;
        Mon,  6 Dec 2021 09:57:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3429F60BF1;
        Mon,  6 Dec 2021 09:57:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20211129162907.149445-2-jlayton@kernel.org>
References: <20211129162907.149445-2-jlayton@kernel.org> <20211129162907.149445-1-jlayton@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ceph: conversion to new fscache API
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1219680.1638784646.1@warthog.procyon.org.uk>
Date:   Mon, 06 Dec 2021 09:57:26 +0000
Message-ID: <1219681.1638784646@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

>  		if (!(gfp & __GFP_DIRECT_RECLAIM) || !(gfp & __GFP_FS))

There's a function for the first part of this:

		if (!gfpflags_allow_blocking(gfp) || !(gfp & __GFP_FS))

> +	fsc->fscache = fscache_acquire_volume(name, NULL, 0);
>  
>  	if (fsc->fscache) {
>  		ent->fscache = fsc->fscache;
>  		list_add_tail(&ent->list, &ceph_fscache_list);

It shouldn't really be necessary to have ceph_fscache_list since
fscache_acquire_volume() will do it's own duplicate check.  I wonder if I
should make fscache_acquire_volume() return -EEXIST or -EBUSY rather than NULL
in such a case and not print an error, but rather leave that to the filesystem
to display.

That would allow you to get rid of the ceph_fscache_entry struct also, I
think.

> +#define FSCACHE_USE_NEW_IO_API

That doesn't exist anymore.

> +		/*
> +		 * If we're truncating up, then we should be able to just update
> +		 * the existing cookie.
> +		 */
> +		if (size > isize)
> +			ceph_fscache_update(inode);

Might look better to say "expanding" rather than "truncating up".

David

