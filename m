Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8254961A2
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Jan 2022 15:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381427AbiAUO6C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Jan 2022 09:58:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381422AbiAUO6C (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Jan 2022 09:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642777081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wmm2pzLuFbqnZkreYBfva5qrdyVHmoJxWJNn7ir8rBo=;
        b=OCkHC/mm/6DJCAi8UjUU21I3cY3ImEu1RZS9/AQ/eZaj6cQDde7MPOl8fMEROUhme5CSjB
        YG6jRCZVf/KwcDdtm4CvnT39kNeRoxuBZOEYblJgerHE4yq2jt7mTDdZQOsVPsi/7VtWi7
        1pTSUkDHmd9906KKboX5lPI81O6mw3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-xnb1H_w_PzObNQzqWZm4Bw-1; Fri, 21 Jan 2022 09:58:00 -0500
X-MC-Unique: xnb1H_w_PzObNQzqWZm4Bw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 257B685EE60;
        Fri, 21 Jan 2022 14:57:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 249C67E5AC;
        Fri, 21 Jan 2022 14:57:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220121141838.110954-3-jlayton@kernel.org>
References: <20220121141838.110954-3-jlayton@kernel.org> <20220121141838.110954-1-jlayton@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] ceph: Make ceph_netfs_issue_op() handle inlined data
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1130436.1642777077.1@warthog.procyon.org.uk>
Date:   Fri, 21 Jan 2022 14:57:57 +0000
Message-ID: <1130437.1642777077@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

> +	len = iinfo->inline_len;
> +	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
> +	err = copy_to_iter(iinfo->inline_data, len, &iter);

I think this is probably wrong.  It will read the entirety of the inline data
into the buffer, even if it's bigger than the buffer and you need to offset
pointer into the buffer.

You need to limit it to subreq->len.  Maybe:

	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);
	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages,
			subreq->start, len);
	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &iter);

David

